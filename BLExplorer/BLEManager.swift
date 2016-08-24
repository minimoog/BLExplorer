//
//  BLEManager.swift
//  BLExplorer
//
//  Created by Antonie Jovanoski on 7/12/16.
//  Copyright © 2016 Antonie Jovanoski. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BLEManagerDelegate : class {
    func didDiscoverPeripheral(manager: BLEManager, peripheral: CBPeripheral, localName: String?, isConnectable: Bool?)
}

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var cbManager: CBCentralManager?
    var connectedPeripheral: CBPeripheral?
    var characteristics = [CBCharacteristic]()
    var mapServiceCharacteristics = [CBUUID: [CBCharacteristic]]()
    var didConnectCompletionHandler: (() -> ())?
    var didDisconnectCompletionHandler: (() -> ())?
    var didDiscoverServicesCompletionHandler: (() -> ())?
    
    weak var delegate: BLEManagerDelegate?
    
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
    
    func discoverServices(completionHandler: () -> ()) {
        if let peripheral = connectedPeripheral {
            if peripheral.state == .Disconnected {
                connect(peripheral) {
                    peripheral.discoverServices(nil)
                }
            } else {
                if peripheral.services == nil {
                    peripheral.discoverServices(nil)
                }
            }
        }
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
        if let disconnectHandler = didDisconnectCompletionHandler {
            disconnectHandler()
        }
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        // ### Closure
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
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("Discovered \(peripheral.name)")
        print("RSSI: \(RSSI)")
        
        var localName: String?
        var isConnectable: Bool?
        
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            print("Local name \(name)")
            
            localName = name
        }
        
        if let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [CBUUID:  NSData] {
            for (uuid, service) in serviceData {
                print("uuid: \(uuid.UUIDString), service data: \(service)")
            }
        }
        
        if let dataServiceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            for uuid in dataServiceUUIDs {
                print("service uuid: \(uuid.UUIDString)")
            }
        }
        
        if let connectable = advertisementData[CBAdvertisementDataIsConnectable] as? NSNumber {
            print("is connectable: \(connectable.boolValue)")
            
            isConnectable = connectable.boolValue
        }
        
        delegate?.didDiscoverPeripheral(self, peripheral: peripheral, localName: localName, isConnectable: isConnectable)
    }
    
    // ------------------ CBPeripheralDelegate ------------------
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if error == nil {
            print("Discovered services...")
            
            if let discoverServicesHandler = didDiscoverServicesCompletionHandler {
                discoverServicesHandler()
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
                        peripheral.readValueForCharacteristic(ch)
                    }
                }
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        if error != nil {
            print(characteristic.value)
        }
        
        let characteristicArray = mapServiceCharacteristics[characteristic.service.UUID]
        
        if let index = characteristicArray?.indexOf(characteristic) {
            mapServiceCharacteristics[characteristic.service.UUID]?[index] = characteristic
        } else {
            mapServiceCharacteristics[characteristic.service.UUID]?.append(characteristic)
        }
    }
}