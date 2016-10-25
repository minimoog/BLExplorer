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
    CBUUID(string: "1806"): "Reference Time Update Service",
    CBUUID(string: "1807"): "Next DST Change Service",
    CBUUID(string: "1808"): "Glucose",
    CBUUID(string: "1809"): "Health Thermometer",
    CBUUID(string: "180A"): "Device Information",
    CBUUID(string: "180D"): "Hearth Rate",
    CBUUID(string: "180E"): "Phone Alert Status Service",
    CBUUID(string: "180F"): "Battery Service",
    CBUUID(string: "1810"): "Blood Pressure",
    CBUUID(string: "1811"): "Alert Notification Service",
    CBUUID(string: "1812"): "Human Interface Device",
    CBUUID(string: "1813"): "Scan Parameters",
    CBUUID(string: "1814"): "Running Speed and Cadence",
    CBUUID(string: "1815"): "Automation IO",
    CBUUID(string: "1816"): "Cycling Speed and Cadence",
    CBUUID(string: "1818"): "Cycling Power",
    CBUUID(string: "1819"): "Location and Navigation",
    CBUUID(string: "181A"): "Environmental Sensing",
    CBUUID(string: "181B"): "Body Composition",
    CBUUID(string: "181C"): "User Data",
    CBUUID(string: "181D"): "Weight Scale",
    CBUUID(string: "181E"): "Bond Management",
    CBUUID(string: "181F"): "Continuous Glucose Monitoring",
    CBUUID(string: "1820"): "Internet Protocol Support",
    CBUUID(string: "1821"): "Indoor Positioning",
    CBUUID(string: "1822"): "Pulse Oximeter",
    CBUUID(string: "1823"): "HTTP Proxy",
    CBUUID(string: "1824"): "Transport Discovery",
    CBUUID(string: "1825"): "Object Transfer",
]
