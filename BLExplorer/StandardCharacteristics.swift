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
    CBUUID(string: "2A0A"): "Day Date Time",
    CBUUID(string: "2A0C"): "Exact Time 256",
    CBUUID(string: "2A0D"): "DST Offset",
    CBUUID(string: "2A0E"): "Time Zone",
    CBUUID(string: "2A0F"): "Local Time Information",
    CBUUID(string: "2A11"): "Time with DST",
    CBUUID(string: "2A12"): "Time Accuracy",
    CBUUID(string: "2A13"): "Time Source",
    CBUUID(string: "2A14"): "Reference Time Information",
    CBUUID(string: "2A16"): "Time Update Control Point",
    CBUUID(string: "2A17"): "Time Update State",
    CBUUID(string: "2A18"): "Glucose Measurement",
    CBUUID(string: "2A19"): "Battery Level",
    CBUUID(string: "2A1C"): "Temperature Measurement",
    CBUUID(string: "2A1D"): "Temperature Type",
    CBUUID(string: "2A1E"): "Intermediate Temperature",
    CBUUID(string: "2A21"): "Measurement Interval",
    CBUUID(string: "2A22"): "Boot Keyboard Input Report",
    CBUUID(string: "2A23"): "System ID",
    CBUUID(string: "2A24"): "Model Number String",
    CBUUID(string: "2A25"): "Serial Number String",
    CBUUID(string: "2A26"): "Firmware Revision String",
    CBUUID(string: "2A27"): "Hardware Revision String",
    CBUUID(string: "2A28"): "Software Revision String",
    CBUUID(string: "2A29"): "Manufacturer Name String",
    CBUUID(string: "2A2A"): "IEEE 11073-20601 Regulatory Certification Data List",
    CBUUID(string: "2A2B"): "Current Time",
    CBUUID(string: "2A2C"): "Magnetic Declination",
    CBUUID(string: "2A31"): "Scan Refresh",
]
