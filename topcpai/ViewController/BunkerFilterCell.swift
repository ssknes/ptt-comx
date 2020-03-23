//
//  BunkerFilterCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/28/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class BunkerFilterView: BaseFilterView {
    @IBOutlet var txtSupplier: UITextField!
    @IBOutlet var txtVessel: UITextField!
    @IBOutlet var txtProduct: UITextField!
    
    let h: CGFloat = 225
    
    var selectedSupplierIndex = -1
    var selectedVesselIndex = -1
    var selectedProductIndex = -1
    
    var supplierValue = [PickerObject]()
    var vesselValue = [PickerObject]()
    var productValue = [PickerObject]()
    
    
    override func setupView() {
        super.setupView()
        txtSupplier.delegate = self
        txtVessel.delegate = self
        txtProduct.delegate = self
        txtSupplier.inputView = getPicker(tag: 0)
        txtVessel.inputView = getPicker(tag: 1)
        txtProduct.inputView = getPicker(tag: 2)
    }

    @IBAction func onBtnClear() {
        clearDefultText()
        txtVessel.text = ""
        txtSupplier.text = ""
        txtProduct.text = ""
    }
    
    func checkEmptyText() -> Bool {
        if checkdefaultEmpty() && txtVessel.text?.trim().length == 0 && txtProduct.text?.trim().length == 0 && txtSupplier.text?.trim().length == 0 {
            return true
        }
        return false
    }
    
    func clearPickerData() {
        self.vesselValue.removeAll()
        self.supplierValue.removeAll()
        self.productValue.removeAll()
    }
    func getVessel() -> String {
        return txtVessel.text == "" || self.selectedVesselIndex == -1 ? "" : self.vesselValue[self.selectedVesselIndex].Value
    }
    func getSupplier() -> String {
        return txtSupplier.text == "" || self.selectedSupplierIndex == -1 ? "" : self.supplierValue[self.selectedSupplierIndex].Value
    }
    func getProduct() -> String  {
        return txtProduct.text == "" || self.selectedProductIndex == -1 ? "" : self.productValue[self.selectedProductIndex].Value
    }
    
    //Picker
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return supplierValue.count
        case 1:
            return vesselValue.count
        case 2:
            return productValue.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return supplierValue[row].Text
        case 1:
            return vesselValue[row].Text
        case 2:
            return productValue[row].Text
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch  pickerView.tag {
        case 0:
            if supplierValue.count > 0 {
                txtSupplier.text = supplierValue[row].Text
                selectedSupplierIndex = row
            }
        case 1:
            if vesselValue.count > 0 {
                txtVessel.text = vesselValue[row].Text
                selectedVesselIndex = row
            }
        case 2:
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
        
        if textField == txtSupplier && textField.text == "" {
            if supplierValue.count > 0 {
                textField.text = supplierValue[0].Text
                selectedSupplierIndex = 0
            }
        }
        if textField == txtVessel && textField.text == "" {
            if vesselValue.count > 0 {
                txtVessel.text = vesselValue[0].Text
            }
        }
        if textField == txtProduct && textField.text == "" {
            if productValue.count > 0 {
                txtProduct.text = productValue[0].Text
            }
        }
    }
}
