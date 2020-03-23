//
//  VCoolPurchaseCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 27/5/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

protocol VCoolPurchaseCellDelegate: class {
    func onChangePurchaseValue(value: String)
}

class VCoolPurchaseCell: UITableViewCell {
    @IBOutlet weak var txtPurchase: UITextField!
    var pickerView = UIPickerView()
    weak var delegate: VCoolPurchaseCellDelegate?
    
    private var purchaseTitle = ["Yes", "No"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        pickerView.delegate = self
        pickerView.dataSource = self
        txtPurchase.inputView = pickerView
    }
    
    func setView(status: String, text: String){
        if status == "WAITING APPROVE SUMMARY" || status == "APPROVED" || status == "TERMINATED" {
            self.txtPurchase.backgroundColor = UIColor.clear
            self.txtPurchase.isUserInteractionEnabled = false
            self.txtPurchase.borderStyle = .none
            self.txtPurchase.text = text
        } else {
            self.txtPurchase.backgroundColor = UIColor.white
            self.txtPurchase.isUserInteractionEnabled = true
            self.txtPurchase.borderStyle = .bezel
            self.txtPurchase.text = purchaseTitle[0]
        }
    }
}

extension VCoolPurchaseCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return purchaseTitle[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if purchaseTitle.count > 0 {
            txtPurchase.text = purchaseTitle[row]
            delegate?.onChangePurchaseValue(value: purchaseTitle[row])
        }
    }
}
