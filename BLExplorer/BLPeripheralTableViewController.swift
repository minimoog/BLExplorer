//
//  BLPeripheralTableViewController.swift
//  BLExplorer
//
//  Created by Antonie Jovanoski on 6/22/16.
//  Copyright © 2016 Antonie Jovanoski. All rights reserved.
//

import UIKit
import CoreBluetooth

struct PeripheralWithExtraData {
    var peripheral: CBPeripheral
    var localName: String?
    var rssi: NSNumber?
    var isConnectable: Bool? = true
}

class BLPeripheralTableViewController: UIViewController, BLEManagerDelegate, BLServicesDelegate, UITableViewDelegate, UITableViewDataSource
{
    var bleManager: BLEManager?
    var peripherals = [PeripheralWithExtraData]()
    @IBOutlet var peripheralsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bleManager?.delegate = self
        
        peripheralsTableView?.delegate = self
        peripheralsTableView?.dataSource = self
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshPeripherals(sender:)), for: .valueChanged)
        peripheralsTableView?.addSubview(refreshControl)
        peripheralsTableView.refreshControl = refreshControl
    }
    
    func clear() {
        peripherals = []
        peripheralsTableView?.reloadData()
    }
    
    func refreshPeripherals(sender: AnyObject) {
        bleManager?.stopScan()
        
        peripherals = []
        peripheralsTableView.reloadData()
        
        sender.endRefreshing()
        bleManager?.scan()
    }
    
    // ---------------- BLEManagerDelegate ---------------------------
    
    func didDiscoverPeripheral(_ manager: BLEManager, peripheral: CBPeripheral, localName: String?, rssi: NSNumber, isConnectable: Bool?) {
        
        var peripheralWithExtraData = PeripheralWithExtraData(peripheral: peripheral, localName: "",rssi: 0, isConnectable: true)
            
        peripheralWithExtraData.localName = localName
        peripheralWithExtraData.isConnectable = isConnectable
        peripheralWithExtraData.rssi = rssi
        
        if let pos = peripherals.index(where: {
            return $0.peripheral.name == peripheralWithExtraData.peripheral.name
        }) {
            //just update only rssi value
           peripherals[pos].rssi = rssi
            
            // fix this
            peripheralsTableView?.reloadData()
        } else {
            peripherals.append(peripheralWithExtraData)
            
            // fix this
            peripheralsTableView?.reloadData()
        }
    }
    
    func didDisconnectPeripheral(_ manager: BLEManager, peripheral: CBPeripheral) {
        //print("Disconnecting \(peripheral.name)")
        
        //### TODO: Rescan?
        //### TODO: Fail to connect handler
    }

    func didPoweredOn(_ manager: BLEManager) {
        bleManager?.scan()
    }
    
    func didPoweredOff(_ manager: BLEManager) {
    }
    
    // --------------- BLServicesTableViewController-----------
    func finishedShowing(_ controller: BLServicesTableViewController) {
        bleManager?.delegate = self
        
        //start again scanning
        bleManager?.scan()
    }
    
    // --------------- Segue --------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ServicesSegue" {
            if let servicesTableViewController = segue.destination as? BLServicesTableViewController {
                //stop scanning
                bleManager?.stopScan()
                peripherals = []
                peripheralsTableView?.reloadData()
                
                servicesTableViewController.delegate = self
                servicesTableViewController.bleManager = bleManager!
                
                servicesTableViewController.bleManager?.delegate = servicesTableViewController
            }
        }
    }
    
    // --------------- Table View ---------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeripheralCell", for: indexPath) as! PeripheralTableViewCell
        
        cell.name.text = peripherals[indexPath.row].peripheral.name
        
        if cell.name.text == "" {
            cell.name.text = "NoName"
        }
        
        if let rssi = peripherals[indexPath.row].rssi {
            cell.rssi.text = "RSSI: \(rssi)"
        } else {
            cell.rssi.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bleManager?.connect(peripherals[indexPath.row].peripheral) {
            self.performSegue(withIdentifier: "ServicesSegue", sender: self)
        }
    }
}
