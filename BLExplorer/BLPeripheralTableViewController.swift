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
    }
    
    // ---------------- BLEManagerDelegate ---------------------------
    
    func didDiscoverPeripheral(manager: BLEManager, peripheral: CBPeripheral, localName: String?, isConnectable: Bool?) {
        
        print("Discovered \(peripheral.name)")
        
        var peripheralWithExtraData = PeripheralWithExtraData(peripheral: peripheral, localName: "", isConnectable: true)
            
        peripheralWithExtraData.localName = localName
        peripheralWithExtraData.isConnectable = isConnectable
        
        peripherals.append(peripheralWithExtraData)
        
        tableView.reloadData()
    }
    
    func didDisconnectPeripheral(manager: BLEManager, peripheral: CBPeripheral) {
        print("Disconnecting \(peripheral.name)")
        
        //### TODO: Rescan?
        //### TODO: Fail to connect handler
    }

    func didPoweredOn(manager: BLEManager) {
        bleManager?.scan()
    }
        
    // --------------- BLServicesTableViewController-----------
    func finishedShowing(controller: BLServicesTableViewController, peripheral: CBPeripheral) {
        //cbManager?.delegate = self
        
        //cbManager?.cancelPeripheralConnection(peripheral)
    }
    
    // --------------- Segue --------------------
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ServicesSegue" {
            if let servicesTableViewController = segue.destinationViewController as? BLServicesTableViewController {
                
                if let indexPath = tableView.indexPathForSelectedRow {                    
                    servicesTableViewController.peripheral = peripherals[indexPath.row].peripheral
                    servicesTableViewController.delegate? = self
                    
                    //switch the delegate
                    //cbManager?.delegate = servicesTableViewController
                }
            }
        }
    }
    
    // --------------- Table View ---------------
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PeripheralCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = peripherals[indexPath.row].peripheral.name
        cell.detailTextLabel?.text = peripherals[indexPath.row].localName
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        bleManager?.connect(peripherals[indexPath.row].peripheral) {
            self.performSegueWithIdentifier("ServicesSegue", sender: self)
        }
    }
}