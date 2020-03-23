//
//  SlideDataCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 3/5/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class SlideDataCell: UICollectionViewCell {
    @IBOutlet weak var lblData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setText(Data: String) {
        lblData.font = UIFont.init(name: lblData.font.fontName, size: GlobalVar.sharedInstance.getFontSize())
        lblData.text = Data
        layoutIfNeeded()
        //return lblValue.frame.size.height + 6
    }
}
