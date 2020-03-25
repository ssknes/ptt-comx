//
//  SlideHeaderCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 3/5/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class SlideHeaderCell: UITableViewCell {
    @IBOutlet weak var lblHeader: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setText(header: String) {
        lblHeader.font = UIFont.init(name: lblHeader.font.fontName, size: GlobalVar.sharedInstance.getFontSize())
        lblHeader.text = header
        layoutIfNeeded()
        //return lblValue.frame.size.height + 6
    }
}
