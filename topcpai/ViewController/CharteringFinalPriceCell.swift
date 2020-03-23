//
//  CharteringFinalPriceCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 9/5/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class  CharteringFinalPriceCell: UITableViewCell {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    
}
