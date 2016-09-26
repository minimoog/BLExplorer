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
    func didDiscoverPeripheral(_ manager: BLEManager, peripheral: CBPeripheral, localName: String?, isConnectable: Bool?)
    func didDisconnectPeripheral(_ manager: BLEManager, peripheral: CBPeripheral)
    func didPoweredOn(_ manager: BLEManager)
    func didPoweredOff(_ manager: BLEManager)
}

extension BLEManagerDelegate {
    func didDiscoverPeripheral(_ manager: BLEManager, peripheral: CBPeripheral, localName: String?, isConnectable: Bool?) {
        
    }
    
    func didPoweredOn(_ manager: BLEManager) {
    }
    
    func didPoweredOff(_ manager: BLEManager) {
        
    }
}

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var connectedPeripheral: CBPeripheral?
    
    fileprivate var cbManager: CBCentralManager?
    fileprivate var didConnectCompletionHandler: (() -> ())?
    fileprivate var didDisconnectCompletionHandler: (() -> ())?
    fileprivate var didDiscoverServicesCompletionHandler: (() -> ())?
    fileprivate var didDiscoverCharacteristicsCompletionHandler: (() -> ())?
    fileprivate var didUpdateValue: (() -> ())?
    
    weak var delegate: BLEManagerDelegate?
    
    override init() {
        super.init()
        cbManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func scan() {
        print("Start scanning...")
        cbManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScan() {
        cbManager?.stopScan()
    }
    
    func connect(_ peripheral: CBPeripheral, completionHandler: @escaping () -> ()) {
        connectedPeripheral = peripheral
        cbManager?.connect(peripheral, options: nil)
        
        didConnectCompletionHandler = completionHandler
    }
    
    func disconnect() {
        if let peripheral = connectedPeripheral {
            cbManager?.cancelPeripheralConnection(peripheral)
        }
    }
    
    func discoverServices(_ completionHandler: @escaping () -> ()) {
        didDiscoverServicesCompletionHandler = completionHandler
        
        if let peripheral = connectedPeripheral {
            if peripheral.state == .disconnected {
                connect(peripheral) {
                    peripheral.discoverServices(nil)
                }
            } else {
                if peripheral.services == nil {
                    peripheral.discoverServices(nil)
                } else if let handler = didDiscoverServicesCompletionHandler {
                    handler()
                }
            }
        }
    }
    
    func discoverCharacteristics(_ service: CBService, completionHandler: @escaping () -> ()) {
        didDiscoverCharacteristicsCompletionHandler = completionHandler
        
        if let p = connectedPeripheral {
            if p.state == .disconnected {
                connect(p) {
                    p.discoverCharacteristics(nil, for: service)
                }
            } else if p.state == .connected {
                p.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func updateValue(_ characteristic: CBCharacteristic, completionHandler: @escaping () -> ()) {
        didUpdateValue = completionHandler
        
        if let p = connectedPeripheral {
            if p.state == .connected {
                if characteristic.properties.contains(.read) {
                    p.readValue(for: characteristic)
                }
            }
        }
    }
    
    //--------------- CBCentralManagerDelegate
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral?.delegate = self
        
        if let connectedHandler = didConnectCompletionHandler {
            connectedHandler()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected: \(peripheral)")
        
        connectedPeripheral = nil
        
        if let disconnectHandler = didDisconnectCompletionHandler {
            disconnectHandler()
        }
        
        
        
        delegate?.didDisconnectPeripheral(self, peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        // ### Closure
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOff {
            print("Core BLE powered off")
            delegate?.didPoweredOff(self)
        } else if central.state == .poweredOn {
            print("Core BLE powered on")
            delegate?.didPoweredOn(self)
        } else if (central.state == .unauthorized) {
            print("Core BLE unauthorized")
        } else if (central.state == .unknown) {
            print("Core BLE state unknown")
        } else if (central.state == .unsupported) {
            print("Core BLE state unsuppored")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name)")
        print("RSSI: \(RSSI)")
        
        var localName: String?
        var isConnectable: Bool?
        
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            print("Local name \(name)")
            
            localName = name
        }
        
        if let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [CBUUID:  Data] {
            for (uuid, service) in serviceData {
                print("uuid: \(uuid.uuidString), service data: \(service)")
            }
        }
        
        if let dataServiceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            for uuid in dataServiceUUIDs {
                print("service uuid: \(uuid.uuidString)")
            }
        }
        
        if let connectable = advertisementData[CBAdvertisementDataIsConnectable] as? NSNumber {
            print("is connectable: \(connectable.boolValue)")
            
            isConnectable = connectable.boolValue
        }
        
        delegate?.didDiscoverPeripheral(self, peripheral: peripheral, localName: localName, isConnectable: isConnectable)
    }
    
    // ------------------ CBPeripheralDelegate ------------------
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error == nil {
            print("Discovered services...")
            
            if let discoverServicesHandler = didDiscoverServicesCompletionHandler {
                discoverServicesHandler()
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error == nil {
            print("Discovered charactetistics for the service \(service.uuid.uuidString)")
            
            if let handler = didDiscoverCharacteristicsCompletionHandler {
                handler()
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if error == nil {
            print(characteristic.value)
            
            if let handler = didUpdateValue {
                handler()
            }
        }
    }
}
