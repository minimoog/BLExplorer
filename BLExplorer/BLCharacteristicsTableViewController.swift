//
//  BLCharacteristicsTableViewController.swift
//  BLExplorer
//
//  Created by Antonie Jovanoski on 6/29/16.
//  Copyright © 2016 Antonie Jovanoski. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLCharacteristicsTableViewController: UITableViewController {
    var service: CBService? {
        didSet {
            if let service = self.service {
                characteristics = service.characteristics!
            }
        }
    }
    
    var characteristics = [CBCharacteristic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    // ------------ Table view --------------
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characteristics.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CharacteristicCell", forIndexPath: indexPath)
        
        //cell.textLabel?.text = String(data: characteristics[indexPath.row], encoding: NSUTF8StringEncoding)
        cell.textLabel?.text = characteristics[indexPath.row].UUID.UUIDString
        
        return cell
    }
}
