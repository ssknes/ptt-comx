//
//  DemurageFilterViewCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 7/12/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class DemurageFilterView: BaseFilterView {

    let h: CGFloat = 130
    
    override func setupView() {
        super.setupView()
    }
    
    @IBAction func onBtnClear() {
        clearDefultText()
    }
    
    func checkEmptyText() -> Bool {
        if checkdefaultEmpty() {
            return true
        }
        return false
    }
}
