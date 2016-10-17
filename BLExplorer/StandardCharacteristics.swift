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
    CBUUID(string: "2A32"): "Boot Keyboard Output Report",
    CBUUID(string: "2A33"): "Boot Mouse Input Report",
    CBUUID(string: "2A34"): "Glucose Measurement Context",
    CBUUID(string: "2A35"): "Blood Pressure Measurement",
    CBUUID(string: "2A36"): "Intermediate Cuff Pressure",
    CBUUID(string: "2A37"): "Heart Rate Measurement",
    CBUUID(string: "2A38"): "Body Sensor Location",
    CBUUID(string: "2A39"): "Heart Rate Control Pont",
    CBUUID(string: "2A3F"): "Alert Status",
    CBUUID(string: "2A40"): "Ringer Control Point",
    CBUUID(string: "2A41"): "Ringer Setting",
    CBUUID(string: "2A42"): "Alert Category ID Bit Mask",
    CBUUID(string: "2A43"): "Alert Category ID",
    CBUUID(string: "2A44"): "Alert Notification Control Point",
    CBUUID(string: "2A45"): "Unread Alert Status",
    CBUUID(string: "2A46"): "New Alert",
    CBUUID(string: "2A47"): "Supported New Alert Categoy",
    CBUUID(string: "2A48"): "Alert Category ID Bit Mask",
    CBUUID(string: "2A49"): "Blood Pressure Feature",
    CBUUID(string: "2A4A"): "HID Information",
    CBUUID(string: "2A4B"): "Report Map",
    CBUUID(string: "2A4C"): "HID Control Point",
    CBUUID(string: "2A4D"): "Report",
    CBUUID(string: "2A4E"): "Alert Category ID Bit Mask",
    CBUUID(string: "2A4F"): "Scan Interval Window",
    CBUUID(string: "2A50"): "PnP ID",
    CBUUID(string: "2A52"): "Random Access Control Point",
    CBUUID(string: "2A53"): "RSC Measurement",
    CBUUID(string: "2A54"): "RSC Feature",
    CBUUID(string: "2A55"): "SC Control Point",
    CBUUID(string: "2A56"): "Digital",
    CBUUID(string: "2A58"): "Analog",
    CBUUID(string: "2A5A"): "Aggregate",
    CBUUID(string: "2A5B"): "CSC Measurement",
    CBUUID(string: "2A5C"): "CSC Feature",
    CBUUID(string: "2A5E"): "PLX Spot-check measurement",
    CBUUID(string: "2A5F"): "PLX continues measurement",
    CBUUID(string: "2A60"): "PLX features",
    CBUUID(string: "2A63"): "Cycling Power Measurement",
    CBUUID(string: "2A64"): "Cycling Power Vector",
    CBUUID(string: "2A65"): "Cycling Power Feature",
    CBUUID(string: "2A66"): "Cycling Power Controller Window",
    CBUUID(string: "2A67"): "Location",
    CBUUID(string: "2A68"): "Navigation",
    CBUUID(string: "2A69"): "Position Quake",
    CBUUID(string: "2A6A"): "LN Feature",
    CBUUID(string: "2A6B"): "LN Control",
    CBUUID(string: "2A6C"): "Elevation",
    CBUUID(string: "2A6D"): "Pressure",
    CBUUID(string: "2A6E"): "Temperatire",
    CBUUID(string: "2A6F"): "Humidity",
    CBUUID(string: "2A70"): "True Wind Speed",
    CBUUID(string: "2A71"): "True Wind Direction",
    CBUUID(string: "2A72"): "Apparent Wind Speed",
    CBUUID(string: "2A73"): "Apparent Wind Direction",
    CBUUID(string: "2A74"): "Gust Factor",
    CBUUID(string: "2A75"): "Pollen Concentration",
    CBUUID(string: "2A76"): "UV Index",
    CBUUID(string: "2A77"): "Irradiance",
    CBUUID(string: "2A78"): "Rainfall",
    CBUUID(string: "2A79"): "Wind Chill",
    CBUUID(string: "2A7A"): "Heat Index",
    CBUUID(string: "2A7B"): "Dew Point",
    CBUUID(string: "2A7D"): "Descriptor Value Changed",
    CBUUID(string: "2A7F"): "Aerobic Threshold",
    CBUUID(string: "2A80"): "Аgе",
    CBUUID(string: "2A81"): "Anaerobic Heart Rate Lower Limit",
    CBUUID(string: "2A82"): "Anaerobic Heart Rate Upper Limit",
    CBUUID(string: "2A83"): "Anaerobic Threshold",
    CBUUID(string: "2A84"): "Aerobic Heart Rate Upper Limit",
    CBUUID(string: "2A85"): "Date of Birth",
    CBUUID(string: "2A86"): "Date of Threshold Assessment",
    CBUUID(string: "2A87"): "Email Address",
    CBUUID(string: "2A88"): "Fat Burn Heart Rate Lower Limit",
    CBUUID(string: "2A89"): "Fat Burn Heart Rate Upper Limit",
    CBUUID(string: "2A8A"): "First Name",
    CBUUID(string: "2A8B"): "Five Zone Heart Rate Limits",
    CBUUID(string: "2A8C"): "Gender",
    CBUUID(string: "2A8D"): "Heart Rate Max",
    CBUUID(string: "2A8E"): "Height",
    CBUUID(string: "2A8F"): "Hip Circumference",
]
