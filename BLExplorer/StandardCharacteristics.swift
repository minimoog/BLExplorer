//
//  StandardCharacteristics.swift
//  BLExplorer
//
//  Created by Toni Jovanoski on 10/4/16.
//  Copyright © 2016 Antonie Jovanoski. All rights reserved.
//

import Foundation
import CoreBluetooth

let StandardCharacteristics: [CBUUID: String] = [
    CBUUID(string: "2A00"): "Device Name",
    CBUUID(string: "2A01"): "Appearance",
    CBUUID(string: "2A02"): "Peripheal Privacy Flag",
    CBUUID(string: "2A03"): "Reconnection Address",
    CBUUID(string: "2A04"): "Peripheral Preferred Connection Parameters",
    CBUUID(string: "2A05"): "Service Changed",
    CBUUID(string: "2A06"): "Alert Level",
    CBUUID(string: "2A07"): "Tx Power Level",
    CBUUID(string: "2A08"): "Date Time",
    CBUUID(string: "2A09"): "Day of Week",
    
]
