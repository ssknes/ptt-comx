//
//  CrudeFilterViewCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/23/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class CrudeFilterView: BaseFilterView {
    @IBOutlet var hdrCrudeName: UILabel!
    @IBOutlet var txtCrudeName: UITextField!
    @IBOutlet var txtFeedStock: UITextField!
    
    let h: CGFloat = 190
    
    var crudeValue = [PickerObject]()
    var feedStockValue = [PickerObject]()
    
    var selectedCrudeNameIndex = -1
    var selectedFeedStockIndex = -1
    
    override func setupView() {
        super.setupView()
        txtCrudeName.delegate = self
        txtFeedStock.delegate = self
        txtCrudeName.inputView = getPicker(tag: 0)
        txtFeedStock.inputView = getPicker(tag: 1)
    }
    
    @IBAction func onBtnClear() {
        clearDefultText()
        txtCrudeName.text = ""
        txtFeedStock.text = ""
        
    }
    
    func checkEmptyText() -> Bool {
        if checkdefaultEmpty() && txtFeedStock.text?.trim().length == 0 && txtCrudeName.text?.trim().length == 0 {
            return true
        }
        return false
    }
    
    func clearPickerData() {
        self.crudeValue.removeAll()
        self.feedStockValue.removeAll()
    }
    
    func getCrudeName() -> String {
        return txtCrudeName.text == "" || self.selectedCrudeNameIndex == -1 ? "" : self.crudeValue[self.selectedCrudeNameIndex].Value
    }
    
    func getFeedStock() -> String {
        return txtFeedStock.text == "" || self.selectedFeedStockIndex == -1 ? "" : self.feedStockValue[self.selectedFeedStockIndex].Value
    }
    
    
    //Picker
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return crudeValue.count
        case 1:
            return feedStockValue.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return crudeValue[row].Text
        case 1:
            return feedStockValue[row].Text
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch  pickerView.tag {
        case 0:
            if crudeValue.count > 0 {
                txtCrudeName.text = crudeValue[row].Text
                selectedCrudeNameIndex = row
            }
        case 1:
            if feedStockValue.count > 0 {
                txtFeedStock.text = feedStockValue[row].Text
                selectedFeedStockIndex = row
                /*
                if txtFeedStock.text?.lowercased() != "crude" {
                    txtCrudeName.isHidden = true
                    txtCrudeName.text = ""
                    hdrCrudeName.isHidden = true
                    selectedCrudeNameIndex = -1
                } else {
                    txtCrudeName.isHidden = false
                    hdrCrudeName.isHidden = false
                }*/
            }
        default:
           break
        }
    }
    //textfield
    override func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        super.textFieldDidEndEditing(textField, reason: reason)
        
        if textField == txtCrudeName && textField.text == "" {
            if crudeValue.count > 0 {
                textField.text = crudeValue[0].Text
                selectedCrudeNameIndex = 0
            }
        }
        if textField == txtFeedStock && textField.text == "" {
            if feedStockValue.count > 0 {
                txtFeedStock.text = feedStockValue[0].Text
            }
        }
    }
}
