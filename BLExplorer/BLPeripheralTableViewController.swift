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
    var isConnectable: Bool? = true
}

class BLPeripheralTableViewController: UITableViewController, BLEManagerDelegate, BLServicesDelegate
{
    var bleManager: BLEManager?
    var peripherals = [PeripheralWithExtraData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bleManager = BLEManager()
        bleManager?.delegate = self
    }
    
    // ---------------- BLEManagerDelegate ---------------------------
    
    func didDiscoverPeripheral(_ manager: BLEManager, peripheral: CBPeripheral, localName: String?, isConnectable: Bool?) {
        
        print("Discovered \(peripheral.name)")
        
        var peripheralWithExtraData = PeripheralWithExtraData(peripheral: peripheral, localName: "", isConnectable: true)
            
        peripheralWithExtraData.localName = localName
        peripheralWithExtraData.isConnectable = isConnectable
        
        peripherals.append(peripheralWithExtraData)
        
        tableView.reloadData()
    }
    
    func didDisconnectPeripheral(_ manager: BLEManager, peripheral: CBPeripheral) {
        print("Disconnecting \(peripheral.name)")
        
        //### TODO: Rescan?
        //### TODO: Fail to connect handler
    }

    func didPoweredOn(_ manager: BLEManager) {
        bleManager?.scan()
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
                
                servicesTableViewController.delegate = self
                servicesTableViewController.bleManager = bleManager!
                
                servicesTableViewController.bleManager?.delegate = servicesTableViewController
                
            }
        }
    }
    
    // --------------- Table View ---------------
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeripheralCell", for: indexPath)
        
        cell.textLabel?.text = peripherals[(indexPath as NSIndexPath).row].peripheral.name
        cell.detailTextLabel?.text = peripherals[(indexPath as NSIndexPath).row].localName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bleManager?.connect(peripherals[(indexPath as NSIndexPath).row].peripheral) {
            self.performSegue(withIdentifier: "ServicesSegue", sender: self)
        }
    }
}
