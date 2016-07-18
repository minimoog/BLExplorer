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
    var services = [CBService]()
    
    var discoverClosure: ((peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) -> ())?
    var connectClosure: ((peripheral: CBPeripheral) -> ())?
    var disconnectClosure: ((peripheral: CBPeripheral) -> ())?
    
    override init() {
        super.init()
        cbManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        connectClosure!(peripheral: peripheral)
        
        peripheral.delegate = self
        
        connectClosure = nil
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        disconnectClosure!(peripheral: peripheral)
        
        disconnectClosure = nil
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        // ### TODO
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("Discovered \(peripheral.name)")
       
        peripherals.append(peripheral)
        
        discoverClosure!(peripheral: peripheral, advertisementData: advertisementData, RSSI: RSSI)
        
        discoverClosure = nil
    }
    
    func scan(closure: (peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) -> ()) {
        discoverClosure = closure
        
        cbManager?.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func connect(peripheral: CBPeripheral, didConnectClosure: (peripheral: CBPeripheral) -> ()) {
        cbManager?.connectPeripheral(peripheral, options: nil)
        
        connectClosure = didConnectClosure
    }
    
    func disconnect(peripheral: CBPeripheral, didDisconnectClosure: (peripheral: CBPeripheral) -> ()) {
        cbManager?.cancelPeripheralConnection(peripheral)
        
        disconnectClosure = didDisconnectClosure
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        if central.state == .PoweredOff {
            print("Core BLE powered off")
        } else if central.state == .PoweredOn {
            
            //start scanning
            cbManager?.scanForPeripheralsWithServices(nil, options: nil)
            
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
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if error == nil {
            print("Discovered charactetistics for the service \(service.UUID.UUIDString)")
        }
    }
}