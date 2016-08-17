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
        
        characteristics = []
        cbPeripheral?.discoverCharacteristics(nil, forService: cbService!)
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
    
    //--------------- CBPeripheralDelegate -------------
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
        tableView.beginUpdates()
        
        characteristics.append(characteristic)
        
        let indexPath = NSIndexPath(forRow: characteristics.count - 1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        
        tableView.endUpdates()
    }
}
