//
//  ListDataHeaderCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 9/7/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit


class ListDataHeaderCell: UITableViewCell {
    @IBOutlet weak var lblHeader: UILabel!
    
    let txtColor = UIColor(red: 48 / 255, green: 44 / 255, blue: 117 / 255, alpha: 1)
    let txtColorBold = UIColor(red: 216 / 255, green: 8 / 255, blue: 124 / 255, alpha: 1)
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView(header: String) {
        lblHeader.font = UIFont.init(name: lblHeader.font.fontName, size: GlobalVar.sharedInstance.getFontSize())
        lblHeader.text = header
        layoutIfNeeded()
        //return lblValue.frame.size.height + 6
    }
}
