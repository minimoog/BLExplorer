//
//  BLCharacteristicsTableViewController.swift
//  BLExplorer
//
//  Created by Antonie Jovanoski on 6/29/16.
//  Copyright © 2016 Antonie Jovanoski. All rights reserved.
//

import UIKit
import CoreBluetooth

extension Data {
    
    func toHexString() -> String {
        
        var hexString: String = String()
        let dataBytes =  (self as NSData).bytes.bindMemory(to: CUnsignedChar.self, capacity: self.count)
        
        for i in 0..<self.count {
            hexString +=  String(format: "%02X", dataBytes[i])
        }
        
        return hexString
    }
    
    func toUtf8String() -> String {
        return String(data: self, encoding: .utf8)!
    }
}

protocol BLCharacteristicsDelegate : class {
    func finishedShowing(_ controller: BLCharacteristicsTableViewController)
}

class BLCharacteristicsTableViewController: UITableViewController, CBPeripheralDelegate {
    var bleManager: BLEManager?
    var service: CBService?
    var characteristics = [CBCharacteristic]()
    
    weak var delegate: BLCharacteristicsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Characteristics"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        characteristics = []
        
        bleManager?.discoverCharacteristics(service!) {
            if let ch = self.service?.characteristics {
                self.characteristics = ch
            }
            
            self.characteristics.forEach {
                self.bleManager?.updateValue($0) {
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isBeingDismissed || isMovingFromParentViewController {
            delegate?.finishedShowing(self)
        }
    }
    
    // ------------ Table view --------------
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characteristics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacteristicCell", for: indexPath)
        
        //cell.textLabel?.text = characteristics[indexPath.row].value?.toHexString()
        cell.textLabel?.text = characteristics[indexPath.row].value?.toUtf8String()
        
        if let characteristicsName = StandardCharacteristics[characteristics[indexPath.row].uuid] {
            cell.detailTextLabel?.text = characteristicsName
        } else {
            cell.detailTextLabel?.text = characteristics[indexPath.row].uuid.uuidString
        }
        
        return cell
    }
}
