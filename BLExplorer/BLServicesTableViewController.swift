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

class BLServicesTableViewController: UITableViewController, CBPeripheralDelegate {
    var peripheral: CBPeripheral?
    var services = [CBService]()
    var characteristics = [CBCharacteristic]()
    var mapServiceCharacteristics = [CBUUID: [CBCharacteristic]]()
    
    var numberOfCharacteristicsRead: Int = 0
    
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
                }
            }
        }
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
        //discover characteristics for the service
        
        if (services[indexPath.row].characteristics == nil) {
            peripheral?.discoverCharacteristics(nil, forService: services[indexPath.row])
        } else {
            performSegueWithIdentifier("CharacteristicsSegue", sender: self)
        }
    }
    
    // ------------ CBPeripheralDelegate -----------
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if error == nil {
            print("Discovered services...")
            
            if let discoveredServices = peripheral.services {
                services = discoveredServices
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
                        numberOfCharacteristicsRead += 1
                        peripheral.readValueForCharacteristic(ch)
                    }
                }
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        numberOfCharacteristicsRead -= 1
        
        if error != nil {
            print(characteristic.value)
        }
        
        characteristics.append(characteristic)
        
        if numberOfCharacteristicsRead == 0 {
            mapServiceCharacteristics[characteristic.service.UUID] = characteristics
            
            performSegueWithIdentifier("CharacteristicsSegue", sender: self)
        }
    }
}
