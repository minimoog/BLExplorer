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
}

protocol BLCharacteristicsDelegate : class {
    func finishedShowing(_ controller: BLCharacteristicsTableViewController)
}

class BLCharacteristicsTableViewController: UITableViewController, CBPeripheralDelegate {
    var bleManager: BLEManager?
    var characteristics = [CBCharacteristic]()
    
    weak var delegate: BLCharacteristicsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Characteristics"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        characteristics = []
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
        
        cell.textLabel?.text = characteristics[(indexPath as NSIndexPath).row].value?.toHexString()
        
        return cell
    }
    
    //--------------- CBPeripheralDelegate -------------
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error == nil {
            print("Discovered charactetistics for the service \(service.uuid.uuidString)")
            
            if let characteristics = service.characteristics {
                for ch in characteristics {
                    let properties = ch.properties
                    if properties.contains(.read) {
                        peripheral.readValue(for: ch)
                    }
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        tableView.beginUpdates()
        
        characteristics.append(characteristic)
        
        let indexPath = IndexPath(row: characteristics.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .none)
        
        tableView.endUpdates()
    }
}
