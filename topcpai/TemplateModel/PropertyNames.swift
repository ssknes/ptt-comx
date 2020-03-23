//
//  PropertyNames.swift
//  SmartPay
//
//  Created by ATA on 7/13/2559 BE.
//  Copyright © 2559 Ruttanachai Auitragool. All rights reserved.
//

import Foundation

protocol PropertyNames {
    func propertyNames() -> [String]
}

extension PropertyNames {

    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.filter { $0.label != nil }.map { $0.label! }
    }

}
