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
    var service: CBService?
    var characteristics = [CBCharacteristic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        characteristics = (service?.characteristics)!
    }
        
    // ------------ Table view --------------
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characteristics.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CharacteristicCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = String(data: characteristics[indexPath.row].value!, encoding: NSUTF8StringEncoding)
        
        return cell
    }
}
