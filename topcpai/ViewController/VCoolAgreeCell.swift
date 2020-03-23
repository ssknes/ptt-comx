//
//  VCoolAgreeCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 27/5/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class VCoolAgreeCell: UITableViewCell {
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setView(Value: String) {
        lbl1.font = UIFont.init(name: lbl1.font.fontName, size: GlobalVar.sharedInstance.getSmallFontSize())
        lbl2.font = UIFont.init(name: lbl1.font.fontName, size: GlobalVar.sharedInstance.getSmallFontSize())
        
        if Value == "disagree" {
            self.img1.image = UIImage.init(named: "radio")
            self.img2.image = UIImage.init(named: "radio_active")
        } else {
            self.img1.image = UIImage.init(named: "radio_active")
            self.img2.image = UIImage.init(named: "radio")
        }
    }
}
