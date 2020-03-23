//
//  SideMenuCell2.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 22/4/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

protocol SideMenuCell2Delegate: class {
    func onSwitch(Sender: UISwitch)
}

class SideMenuCell2: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var swSwitch: UISwitch!
    @IBOutlet weak var vwLine: UIView!
    weak var delegate: SideMenuCell2Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    @IBAction func onSwitch(Sender: UISwitch) {
        delegate?.onSwitch(Sender: Sender)
    }
}
