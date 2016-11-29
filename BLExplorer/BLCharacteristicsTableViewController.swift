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

struct BLECharacteristicValue {
    var name: String = ""
    var utf8Value: String = ""
    var hexValue: String = ""
}

protocol BLCharacteristicsDelegate : class {
    func finishedShowing(_ controller: BLCharacteristicsTableViewController)
}

class BLCharacteristicsTableViewController: UIViewController, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var characteristicsTableView: UITableView!
    
    var bleManager: BLEManager?
    var service: CBService?
    var characteristics = [CBCharacteristic]()
    var values = [BLECharacteristicValue]()
    
    weak var delegate: BLCharacteristicsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Characteristics"
        
        characteristicsTableView?.delegate = self
        characteristicsTableView?.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let uuid = service?.uuid.uuidString {
            navigationItem.title = "Characteristics of " + uuid
        }
        
        bleManager?.discoverCharacteristics(service!) {
            if let ch = self.service?.characteristics {
                self.characteristics = ch
            }
            
            self.values = []
            
            self.characteristics.forEach {
                self.bleManager?.updateValue($0) {
                    characteristic, value in
                    
                    var bleValue = BLECharacteristicValue()
                    
                    if let v = value {
                        bleValue.utf8Value = v.toUtf8String()
                        bleValue.hexValue = v.toHexString()
                    }
                    
                    if let name = StandardCharacteristics[characteristic.uuid] {
                        bleValue.name = name
                    } else {
                        bleValue.name = characteristic.uuid.uuidString
                    }
                    
                    self.values.append(bleValue)
                    
                    self.characteristicsTableView?.reloadData()
                }
            }
            
            self.characteristicsTableView?.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isBeingDismissed || isMovingFromParentViewController {
            delegate?.finishedShowing(self)
        }
    }
    
    // ------------ Table view --------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacteristicCell", for: indexPath) as! CharacteristicTableViewCell
        
        cell.stringValue.text = values[indexPath.row].utf8Value
        cell.hexValue.text = values[indexPath.row].hexValue
        cell.name.text = values[indexPath.row].name
        
        return cell
    }
}
