//
//  StatusButtonCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 3/23/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class StatusButtonCell : UICollectionViewCell{
    @IBOutlet weak var lblCounter :UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    var isSelect: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    func initView(){
        self.lblStatus.sizeToFit()
    }
    
    func setText(Counter : String, Stat : String){
        self.lblCounter.text = Counter
        self.lblStatus.text = Stat
        self.layoutIfNeeded()
    }
    
    func setSelect(input : Bool){
        self.isSelect = input
        if input {
            self.backgroundColor = UIColor(red: 216 / 255, green: 8 / 255, blue: 117 / 124, alpha: 1)
        }else{
            self.backgroundColor = UIColor(red: 48 / 255, green: 44 / 255, blue: 117 / 255, alpha: 1)
        }
    }
}
