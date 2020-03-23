//
//  Button.swift
//  topcpai
//
//  Created by Piyanant Srisirinant on 12/14/2559 BE.
//  Copyright © 2559 PTT ICT Solutions. All rights reserved.
//

import UIKit

class Button: PropertyNames {
    var name = ""
    var page_url = ""
    var call_xml = ""
    
    init() {
        // do nothing
    }
    
    init(name: String, page_url: String, call_xml: String) {
        self.name = name
        self.page_url = page_url
        self.call_xml = call_xml
    }
    
}
