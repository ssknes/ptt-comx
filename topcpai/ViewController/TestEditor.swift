//
//  TestEditor.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 2/9/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class TestEditor: ZSSRichTextEditor {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Brief Edit"
        
        self.shouldShowKeyboard = false
        self.formatHTML = true
        self.alwaysShowToolbar = false
        self.toolbarHolder.frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
        self.enabledToolbarItems = [ZSSRichTextEditorToolbarNone]
        self.placeholder = "Brief Edit"
        self.baseURL = URL.init(string: "http://www.zedsaid.com")
        self.setHTML("")
    }
    
    func setView(Value: String) {
        self.setHTML(Value)
    }
}
