//
//  BLEManager.swift
//  BLExplorer
//
//  Created by Antonie Jovanoski on 7/12/16.
//  Copyright © 2016 Antonie Jovanoski. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var cbManager: CBCentralManager?
    var peripherals = [CBPeripheral]()
    
    var connectedPeripheral: CBPeripheral?
    var services = [CBService]()
    var characteristics = [CBCharacteristic]()
    var mapServiceCharacteristics = [CBUUID: [CBCharacteristic]]()
    
    var numberOfCharacteristicsRead: Int = 0
    
    var didConnectCompletionHandler: (() -> ())?
    
    override init() {
        super.init()
        cbManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func scan() {
        cbManager?.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func connect(peripheral: CBPeripheral, completionHandler: () -> ()) {
        connectedPeripheral = peripheral
        cbManager?.connectPeripheral(peripheral, options: nil)
        
        didConnectCompletionHandler = completionHandler
    }
    
    func disconnect(peripheral: CBPeripheral) {
        cbManager?.cancelPeripheralConnection(peripheral)
    }
    
    //--------------- CBCentralManagerDelegate
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        peripheral.delegate = self
        
        if let connectedHandler = didConnectCompletionHandler {
            connectedHandler()
        }
        
        peripheral.discoverServices(nil)
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        // ### Closure
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("Discovered \(peripheral.name)")
       
        peripherals.append(peripheral)
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        if central.state == .PoweredOff {
            print("Core BLE powered off")
        } else if central.state == .PoweredOn {
            
            /////////// closure 
            
            print("Core BLE powered on")
        } else if (central.state == .Unauthorized) {
            print("Core BLE unauthorized")
        } else if (central.state == .Unknown) {
            print("Core BLE state unknown")
        } else if (central.state == .Unsupported) {
            print("Core BLE state unsuppored")
        }
    }
    
    // ------------------ CBPeripheralDelegate ------------------
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if error == nil {
            print("Discovered services...")
            
            if let discoveredServices = peripheral.services {
                services = discoveredServices
            }
            
            for service in services {
                numberOfCharacteristicsRead = 0
                peripheral.discoverCharacteristics(nil, forService: service)
            }
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
        }
    }
}