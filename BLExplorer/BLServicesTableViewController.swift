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
                
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell) {
                    
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
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = services[indexPath.row].UUID.UUIDString
        
        return cell
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
}
