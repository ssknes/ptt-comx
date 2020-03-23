//
//  IOSVersion.swift
//  SmartPay
//
//  Created by admin on 11/19/2558 BE.
//  Copyright © 2558 Ruttanachai Auitragool. All rights reserved.
//

import UIKit

public class IOSVersion {

    class func getVersion() -> String {
        return UIDevice.current.systemVersion
    }

    class func SYSTEM_VERSION_EQUAL_TO(version: String) -> Bool { // tailor:disable
        return UIDevice.current.systemVersion.compare(version as String,
            options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
    }

    class func SYSTEM_VERSION_GREATER_THAN(version: String) -> Bool { // tailor:disable
        return UIDevice.current.systemVersion.compare(version as String,
            options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
    }

    class func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: String) -> Bool { // tailor:disable
        return UIDevice.current.systemVersion.compare(version as String,
            options: NSString.CompareOptions.numeric) != ComparisonResult.orderedAscending
    }

    class func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {    // tailor:disable
        return UIDevice.current.systemVersion.compare(version as String,
            options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
    }

    class func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: String) -> Bool {    // tailor:disable
        return UIDevice.current.systemVersion.compare(version as String,
            options: NSString.CompareOptions.numeric) != ComparisonResult.orderedAscending
    }

}
