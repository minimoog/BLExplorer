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
    fileprivate var didUpdateValue: ((_ characteristic: CBCharacteristic, _ value: Data?) -> ())?
    
    weak var delegate: BLEManagerDelegate?
    
    override init() {
        super.init()
        cbManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func scan() {     
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
            if peripheral.state == .connected {
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
            if p.state == .connected {
                if service.characteristics == nil {
                    p.discoverCharacteristics(nil, for: service)
                } else if let handler = didDiscoverCharacteristicsCompletionHandler {
                    handler()
                }
            }
        }
    }
    
    func updateValue(_ characteristic: CBCharacteristic, completionHandler: @escaping (_ characteristic: CBCharacteristic, _ value: Data?) -> ()) {
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
        //print("Disconnected: \(peripheral)")
        
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
            delegate?.didPoweredOff(self)
        } else if central.state == .poweredOn {
            delegate?.didPoweredOn(self)
        } else if (central.state == .unauthorized) {
        } else if (central.state == .unknown) {
        } else if (central.state == .unsupported) {
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
#if DEBUG
        print("RSSI: \(RSSI)")
#endif
        
        var localName: String?
        var isConnectable: Bool?
        
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            localName = name
        }
        
        if let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [CBUUID:  Data] {
            for (uuid, service) in serviceData {
                #if DEBUG
                print("uuid: \(uuid.uuidString), service data: \(service)")
                #endif
            }
        }
        
        if let dataServiceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            for uuid in dataServiceUUIDs {
                #if DEBUG
                print("service uuid: \(uuid.uuidString)")
                #endif
            }
        }
        
        if let connectable = advertisementData[CBAdvertisementDataIsConnectable] as? NSNumber {
            isConnectable = connectable.boolValue
        }
        
        delegate?.didDiscoverPeripheral(self, peripheral: peripheral, localName: localName, isConnectable: isConnectable)
    }
    
    // ------------------ CBPeripheralDelegate ------------------
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error == nil {
            if let discoverServicesHandler = didDiscoverServicesCompletionHandler {
                discoverServicesHandler()
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error == nil {
            //print("Discovered charactetistics for the service \(service.uuid.uuidString)")
            
            if let handler = didDiscoverCharacteristicsCompletionHandler {
                handler()
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if error == nil {
            //print(characteristic.value)
            
            if let handler = didUpdateValue {
                handler(characteristic, characteristic.value)
            }
        }
    }
}
