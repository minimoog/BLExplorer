//
//  BLPeripheralTableViewController.swift
//  BLExplorer
//
//  Created by Antonie Jovanoski on 6/22/16.
//  Copyright © 2016 Antonie Jovanoski. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLPeripheralTableViewController: UITableViewController, CBCentralManagerDelegate
{
    var cbManager: CBCentralManager?
    var peripherals = [CBPeripheral]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cbManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // ---------------- CBCentralManagerDelegate ---------------------
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        performSegueWithIdentifier("ServicesSegue", sender: self)
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        // ### TODO
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        // ### TODO
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("Discovered \(peripheral.name)")
        
//        print("Local name \(advertisementData[CBAdvertisementDataLocalNameKey] as! String)")
//        
//        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] {
//            print("Manufacturer data \(manufacturerData as! NSData)")
//        }
//        
//        if let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [CBUUID:  NSData] {
//            for (uuid, service) in serviceData {
//                print("uuid: \(uuid.UUIDString), service data: \(service)")
//            }
//        }
//        
//        if let dataServiceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
//            for uuid in dataServiceUUIDs {
//                print("service uuid: \(uuid.UUIDString)")
//            }
//        }
//        
//        if let dataOverflowServiceUUIDS = advertisementData[CBAdvertisementDataOverflowServiceUUIDsKey] as? [CBUUID] {
//            for uuid in dataOverflowServiceUUIDS {
//                print("overflow uuid: \(uuid.UUIDString)")
//            }
//        }
//        
//        if let txPowerLevel = advertisementData[CBAdvertisementDataTxPowerLevelKey] as? NSNumber {
//            print("tx power level: \(txPowerLevel.floatValue)")
//        }
//        
//        if let connectable = advertisementData[CBAdvertisementDataIsConnectable] as? NSNumber {
//            print("is connectable: \(connectable.boolValue)")
//        }
//        
//        if let dataSolicitedServiceUUIDs = advertisementData[CBAdvertisementDataSolicitedServiceUUIDsKey] as? [CBUUID] {
//            for uuid in dataSolicitedServiceUUIDs {
//                print("Solicited uuid: \(uuid.UUIDString)")
//            }
//        }
        
        peripherals.append(peripheral)
        
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
    
    // --------------- Segue --------------------
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ServicesSegue" {
            if let servicesTableViewController = segue.destinationViewController as? BLServicesTableViewController {
                
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell) {
                    
                    servicesTableViewController.peripheral = peripherals[indexPath.row]
                }
            }
        }
    }
    
    // --------------- Table View ---------------
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = peripherals[indexPath.row].name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        cbManager?.connectPeripheral(peripherals[indexPath.row], options: nil)
    }
}