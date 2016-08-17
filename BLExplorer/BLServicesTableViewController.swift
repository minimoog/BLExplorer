//
//  BLServicesTableViewController.swift
//  BLExplorer
//
//  Created by Antonie Jovanoski on 6/23/16.
//  Copyright © 2016 Antonie Jovanoski. All rights reserved.
//

import UIKit
import CoreBluetooth

extension UITableViewCell {
    func enable(on: Bool) {
        self.userInteractionEnabled = on
        for view in contentView.subviews {
            view.userInteractionEnabled = on
            view.alpha = on ? 1 : 0.5
        }
    }
}

protocol BLServicesDelegate : class {
    func finishedShowing(controller: BLServicesTableViewController, peripheral: CBPeripheral)
}

class BLServicesTableViewController: UITableViewController, CBPeripheralDelegate, CBCentralManagerDelegate,BLCharacteristicsDelegate {
    var cbManager: CBCentralManager?
    var peripheral: CBPeripheral?
    var services = [CBService]()
    var mapServiceCharacteristics = [CBUUID: [CBCharacteristic]]()
    
    weak var delegate: BLServicesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Services"
        
        peripheral?.delegate = self
        
        peripheral?.discoverServices(nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CharacteristicsSegue" {
            if let characteristicsTableViewController = segue.destinationViewController as? BLCharacteristicsTableViewController {
                
                if let indexPath = tableView.indexPathForSelectedRow {
                    if let characteristic = mapServiceCharacteristics[services[indexPath.row].UUID] {
                        characteristicsTableViewController.characteristics = characteristic
                    }
                    
                    characteristicsTableViewController.cbManager = cbManager
                    characteristicsTableViewController.cbPeripheral = peripheral
                    characteristicsTableViewController.cbService = services[indexPath.row]
                    
                    characteristicsTableViewController.delegate? = self
                    
                    //switch again delegate?
                    cbManager?.delegate = characteristicsTableViewController
                    peripheral?.delegate = characteristicsTableViewController
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let peripheral = peripheral {
            
            if isBeingDismissed() || isMovingFromParentViewController() {
                delegate?.finishedShowing(self, peripheral: peripheral)
            }
        }
    }
    
    // --------------- BLCharacteristicsTableViewController-----------
    func finishedShowing(controller: BLCharacteristicsTableViewController) {
        cbManager?.delegate = self
        peripheral?.delegate = self
    }
    
    // ------------ Table view --------------
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ServiceCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = services[indexPath.row].UUID.UUIDString
        
        //disable included services for now services for now
        cell.enable(services[indexPath.row].isPrimary)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("CharacteristicsSegue", sender: self)
    }
    
    // ------------ CBPeripheralDelegate -----------
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if error == nil {
            print("Discovered services...")
            
            if let discoveredServices = peripheral.services {
                services = discoveredServices
            }
            
            for service in services {
                mapServiceCharacteristics[service.UUID] = []
                peripheral.discoverCharacteristics(nil, forService: service)
            }
            
            tableView.reloadData()
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if error == nil {
            print("Discovered charactetistics for the service \(service.UUID.UUIDString)")
            
            if let characteristics = service.characteristics {
                for ch in characteristics {
                    let properties = ch.properties
                    if properties.contains(.Read) {
                        peripheral.readValueForCharacteristic(ch)
                    }
                }
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if error != nil {
            print(characteristic.value)
        }
        
        let characteristicArray = mapServiceCharacteristics[characteristic.service.UUID]
        
        if let index = characteristicArray?.indexOf(characteristic) {
            mapServiceCharacteristics[characteristic.service.UUID]?[index] = characteristic
        } else {
            mapServiceCharacteristics[characteristic.service.UUID]?.append(characteristic)
        }
        
    }
    
    //  ------------ CBCentralManagerDelegate --------
    func centralManagerDidUpdateState(central: CBCentralManager) {
        // unused
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        // unused
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Disconnected from \(peripheral.name)")
    }
}
