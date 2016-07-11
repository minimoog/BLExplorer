//
//  BLServicesTableViewController.swift
//  BLExplorer
//
//  Created by Antonie Jovanoski on 6/23/16.
//  Copyright © 2016 Antonie Jovanoski. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLServicesTableViewController: UITableViewController, CBPeripheralDelegate {
    var peripheral: CBPeripheral?
    var services = [CBService]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peripheral?.delegate = self
        
        peripheral?.discoverServices(nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CharacteristicsSegue" {
            if let characteristicsTableViewController = segue.destinationViewController as? BLCharacteristicsTableViewController {
                
                if let indexPath = tableView.indexPathForSelectedRow {
                    characteristicsTableViewController.service = services[indexPath.row]

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
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //discover characteristics for the service
        peripheral?.discoverCharacteristics(nil, forService: services[indexPath.row])
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
            
            performSegueWithIdentifier("CharacteristicsSegue", sender: self)
        }
    }
}
