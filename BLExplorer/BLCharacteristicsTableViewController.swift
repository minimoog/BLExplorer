//
//  BLCharacteristicsTableViewController.swift
//  BLExplorer
//
//  Created by Antonie Jovanoski on 6/29/16.
//  Copyright © 2016 Antonie Jovanoski. All rights reserved.
//

import UIKit
import CoreBluetooth

extension NSData {
    
    func toHexString() -> String {
        
        var hexString: String = String()
        let dataBytes =  UnsafePointer<CUnsignedChar>(self.bytes)
        
        for i in 0..<self.length {
            hexString +=  String(format: "%02X", dataBytes[i])
        }
        
        return hexString
    }
}

protocol BLCharacteristicsDelegate : class {
    func finishedShowing(controller: BLCharacteristicsTableViewController)
}

class BLCharacteristicsTableViewController: UITableViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
    var cbManager: CBCentralManager?
    var cbPeripheral: CBPeripheral?
    var cbService: CBService?
    var characteristics = [CBCharacteristic]()
    
    weak var delegate: BLCharacteristicsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Characteristics"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isBeingDismissed() || isMovingFromParentViewController() {
            delegate?.finishedShowing(self)
        }
    }
    
    // ------------ Table view --------------
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characteristics.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CharacteristicCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = characteristics[indexPath.row].value?.toHexString()
        
        return cell
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
