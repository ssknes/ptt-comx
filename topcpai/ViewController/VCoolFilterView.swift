//
//  VCoolFilterView.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/29/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class VCoolFilterView: BaseFilterView {
    @IBOutlet var txtCrudeName: UITextField!
    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var txtSupplier: UITextField!
    
    let h: CGFloat = 225
    
    var selectedSupplierIndex = -1
    var selectedCountryIndex = -1
    var selectedCrudeIndex = -1
    var supplierValue = [PickerObject]()
    var CountryValue = [PickerObject]()
    var CrudeValue = [PickerObject]()
    
    override func setupView() {
        super.setupView()
        txtCrudeName.delegate = self
        txtCrudeName.inputView = getPicker(tag: 0)
        txtCountry.delegate = self
        txtCountry.inputView = getPicker(tag: 1)
        txtSupplier.delegate = self
        txtSupplier.inputView = getPicker(tag: 2)
    }
    
    @IBAction func onBtnClear() {
        clearDefultText()
        txtCrudeName.text = ""
        txtCountry.text = ""
        txtSupplier.text = ""
    }
    
    func checkEmptyText() -> Bool {
        if checkdefaultEmpty() && txtSupplier.text?.trim().length == 0 && txtCountry.text?.trim().length == 0 && txtCrudeName.text?.trim().length == 0 {
            return true
        }
        return false
    }
    
    func clearPickerData() {
        self.CrudeValue.removeAll()
        self.CountryValue.removeAll()
        self.supplierValue.removeAll()
    }
    
    func getCrudeName() -> String {
        return txtCrudeName.text == "" || self.selectedCrudeIndex == -1 ? "" : self.CrudeValue[self.selectedCrudeIndex].Value
    }
    
    func getCountry() -> String {
        return txtCountry.text == "" || self.selectedCountryIndex == -1 ? "" : self.CountryValue[self.selectedCountryIndex].Value
    }
    
    func getSupplier() -> String {
        return txtSupplier.text == "" || self.selectedSupplierIndex == -1 ? "" : self.supplierValue[self.selectedSupplierIndex].Value
    }
    
    //Picker
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return CrudeValue.count
        case 1:
            return CountryValue.count
        case 2:
            return supplierValue.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return CrudeValue[row].Text
        case 1:
            return CountryValue[row].Text
        case 2:
            return supplierValue[row].Text
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch  pickerView.tag {
        case 0:
            if CrudeValue.count > 0 {
                txtCrudeName.text = CrudeValue[row].Text
                selectedCrudeIndex = row
            }
        case 1:
            if CountryValue.count > 0 {
                txtCountry.text = CountryValue[row].Text
                selectedCountryIndex = row
            }
        case 2:
            if supplierValue.count > 0 {
                txtSupplier.text = supplierValue[row].Text
                selectedSupplierIndex = row
            }
        default:
           break
        }
    }
    //textfield
    override func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        super.textFieldDidEndEditing(textField, reason: reason)
        
        if textField == txtCrudeName && textField.text == "" {
            if CrudeValue.count > 0 {
                textField.text = CrudeValue[0].Text
                selectedCrudeIndex = 0
            }
        }
        if textField == txtCountry && textField.text == "" {
            if CountryValue.count > 0 {
                textField.text = CountryValue[0].Text
                selectedCountryIndex = 0
            }
        }
        if textField == txtSupplier && textField.text == "" {
            if supplierValue.count > 0 {
                textField.text = supplierValue[0].Text
                selectedSupplierIndex = 0 
            }
        }
    }
}
