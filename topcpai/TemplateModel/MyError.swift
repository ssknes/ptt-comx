//
//  APIError.swift
//  PocketPay
//
//  Created by admin on 9/10/2558 BE.
//  Copyright (c) 2558 Ruttanachai Auitragool. All rights reserved.
//

import Foundation

class MyError: NSObject {

    var code: String
    var message: String
    var internalMessage: String?

    var info: Any?

    override init() {
        self.code = ""
        self.message = ""
        self.internalMessage = ""
        super.init()
    }

    init(code: String, message: String, internalMessage: String?, info: Any?) {

        self.code = code
        self.message = message
        self.internalMessage = internalMessage
        self.info = info
    }

    convenience init(message: String) {
        self.init(code: "-1", message: message, internalMessage: nil, info: nil)
    }

    convenience init(code: String, message: String) {
        self.init(code: code, message: message, internalMessage: nil, info: nil)
    }

    convenience init(code: String, message: String, internalMessage: String) {
        self.init(code: code, message: message, internalMessage: internalMessage, info: nil)
    }
}
