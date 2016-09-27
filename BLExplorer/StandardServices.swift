//
//  StandardServices.swift
//  BLExplorer
//
//  Created by Toni Jovanoski on 9/28/16.
//  Copyright © 2016 Antonie Jovanoski. All rights reserved.
//

import Foundation
import CoreBluetooth

let StandardServices: [CBUUID: String] = [
    CBUUID(string: "1800"): "Generic Access",
    CBUUID(string: "1801"): "Generic Attribute",
    CBUUID(string: "1802"): "Immediate Alert",
    CBUUID(string: "1803"): "Link Lost",
    CBUUID(string: "1804"): "Tx Power",
    CBUUID(string: "1805"): "Current Time Service",
    
    CBUUID(string: "180A"): "Device Information",
]
