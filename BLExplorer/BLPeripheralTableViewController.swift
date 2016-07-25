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
    var localName: String
    var isConnectable: Bool = true
}

class BLPeripheralTableViewController: UITableViewController, CBCentralManagerDelegate, BLServicesDelegate
{
    var cbManager: CBCentralManager?
    var peripherals = [PeripheralWithExtraData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cbManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // ---------------- CBCentralManagerDelegate ---------------------
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        cbManager?.stopScan()
        performSegueWithIdentifier("ServicesSegue", sender: self)
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Disconnecting \(peripheral.name)")
        
        //### TODO: Rescan?
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        // ### TODO
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("Discovered \(peripheral.name)")
        print("RSSI: \(RSSI)")
        
        var peripheralWithExtraData = PeripheralWithExtraData(peripheral: peripheral, localName: "", isConnectable: true)
        
        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            print("Local name \(localName)")
            
            peripheralWithExtraData.localName = localName
        }
        
        if let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [CBUUID:  NSData] {
            for (uuid, service) in serviceData {
                print("uuid: \(uuid.UUIDString), service data: \(service)")
            }
        }
        
        if let dataServiceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            for uuid in dataServiceUUIDs {
                print("service uuid: \(uuid.UUIDString)")
            }
        }
        
        if let connectable = advertisementData[CBAdvertisementDataIsConnectable] as? NSNumber {
            print("is connectable: \(connectable.boolValue)")
            
            peripheralWithExtraData.isConnectable = connectable.boolValue
        }
        
        peripherals.append(peripheralWithExtraData)
        
        tableView.reloadData()
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        if central.state == .PoweredOff {
            print("Core BLE powered off")
        } else if central.state == .PoweredOn {
            
            //start scanning
            cbManager?.scanForPeripheralsWithServices(nil, options: nil)
            
            print("Core BLE powered on")
        } else if (central.state == .Unauthorized) {
            print("Core BLE unauthorized")
        } else if (central.state == .Unknown) {
            print("Core BLE state unknown")
        } else if (central.state == .Unsupported) {
            print("Core BLE state unsuppored")
        }
    }
    
    // --------------- BLServicesTableViewController-----------
    func finishedShowing(controller: BLServicesTableViewController, peripheral: CBPeripheral) {
        cbManager?.cancelPeripheralConnection(peripheral)
    }
    
    // --------------- Segue --------------------
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ServicesSegue" {
            if let servicesTableViewController = segue.destinationViewController as? BLServicesTableViewController {
                
                if let indexPath = tableView.indexPathForSelectedRow {                    
                    servicesTableViewController.peripheral = peripherals[indexPath.row].peripheral
                    servicesTableViewController.delegate = self
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
        cbManager?.connectPeripheral(peripherals[indexPath.row].peripheral, options: nil)
    }
}