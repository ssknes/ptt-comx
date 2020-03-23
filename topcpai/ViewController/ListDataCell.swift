//
//  ListDataCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 24/4/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit


protocol ListDataCellDelegate: class {
    func onBtnBriefEdit(Value: String)
}

class ListDataCell: UITableViewCell {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var btnEdit: UIButton!

    
    weak var delegate: ListDataCellDelegate?
    var htmlValue: String = ""
    
    let txtColor = UIColor(red: 48 / 255, green: 44 / 255, blue: 117 / 255, alpha: 1)
    let txtColorBold = UIColor(red: 216 / 255, green: 8 / 255, blue: 124 / 255, alpha: 1)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView(header: String, value: String, bold: Bool) {
        lblHeader.font = UIFont.init(name: lblHeader.font.fontName, size: GlobalVar.sharedInstance.getFontSize())
        lblHeader.text = header
        if (lblHeader.text?.lowercased().contains("brief"))! {
            btnEdit.isHidden = false
            lblValue.text = ""
            lblValue.font = UIFont.init(name: "Kanit-Light", size: GlobalVar.sharedInstance.getFontSize())
            lblValue.textColor = txtColor
            htmlValue = value
            lblValue.text = value.html2String
        }
        else {
            btnEdit.isHidden = true
            
            if bold {
                lblValue.font = UIFont.init(name: "Kanit-SemiBold", size: GlobalVar.sharedInstance.getFontSize())
                lblValue.textColor = txtColorBold
            }
            else if (lblHeader.text?.lowercased().contains("advance for"))! {
                lblValue.font = UIFont.init(name: "Kanit-Light", size: GlobalVar.sharedInstance.getFontSize())
                lblValue.textColor = txtColorBold
            }
            else if (lblHeader.text?.lowercased().contains("status"))! {
                lblValue.font = UIFont.init(name: "Kanit-Light", size: GlobalVar.sharedInstance.getFontSize())
                lblValue.textColor = txtColorBold
            }
            else {
                lblValue.font = UIFont.init(name: "Kanit-Light", size: GlobalVar.sharedInstance.getFontSize())
                lblValue.textColor = txtColor
            }
            lblValue.text = value
        }
        layoutIfNeeded()
    }
    @IBAction func onBtnEdit(_ Sender: UIButton) {
        delegate?.onBtnBriefEdit(Value: htmlValue)
        //delegate?.onBtnBriefEdit(Value: lblValue.attributedText?.htmlString ?? "")
    }
}
