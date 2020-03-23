//
//  CodeName.swift
//  SmartPay
//
//  Created by admin on 2/1/2559 BE.
//  Copyright © 2559 Ruttanachai Auitragool. All rights reserved.
//

import Foundation

class ExtensibleResult: NSObject {
    
    var success: Bool
    
    var code: String
    var message: String
    
    var ext1: Any?
    var ext2: Any?
    
    override init() {
        self.success = true
        self.code = ""
        self.message = ""
        
        super.init()
    }
    
    init(code: String, message: String, success: Bool, ext1: Any?, ext2: Any?) {
        self.success = true
        self.code = code
        self.message = message
        self.ext1 = ext1
        self.ext2 = ext2
    }
    
    convenience init(code: String, message: String, success: Bool) {
        self.init(code: code, message: message, success: success, ext1: nil, ext2: nil)
    }
    
}
