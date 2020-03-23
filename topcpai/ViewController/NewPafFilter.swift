//
//  NewPafFilter.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 6/9/2561 BE.
//  Copyright © 2561 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class NewPafFilterView: BaseFilterView {
    @IBOutlet weak var txtProduct: UITextField!
    
    let h: CGFloat = 180
    
    
    var productValue = [PickerObject]()
    var selectedProductIndex = -1
    
    override func setupView() {
        super.setupView()
        txtProduct.delegate = self
        txtProduct.inputView = getPicker(tag: 0)
    }
    
    @IBAction func onBtnClear() {
        super.clearDefultText()
        txtProduct.text = ""
    }
    func checkEmptyText() -> Bool {
        if checkdefaultEmpty() && txtProduct.text?.trim().length == 0 {
            return true
        }
        return false
    }
    
    func clearPickerData() {
        productValue.removeAll()
    }
    
    func getProduct() -> String {
        return txtProduct.text == "" || self.selectedProductIndex == -1 ? "" : self.productValue[self.selectedProductIndex].Value
    }
    
    //Picker
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return productValue.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return productValue[row].Text
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch  pickerView.tag {
        case 0:
            if productValue.count > 0 {
                txtProduct.text = productValue[row].Text
                selectedProductIndex = row
            }
        default:
           break
        }
    }
    //textfield
    override func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        super.textFieldDidEndEditing(textField, reason: reason)
        
        if textField == txtProduct && textField.text == "" {
            if productValue.count > 0 {
                textField.text = productValue[0].Text
                selectedProductIndex = 0
            }
        }
    }
}
