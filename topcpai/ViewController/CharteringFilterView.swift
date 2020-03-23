//
//  CharteringFilterView.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/25/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class CharteringFilterView: BaseFilterView {
    @IBOutlet var txtLaycanFrom: UITextField!
    @IBOutlet var txtLaycanTo: UITextField!
    @IBOutlet var txtVessel: UITextField!
    
    let h: CGFloat = 190

    
    var vesselValue = [PickerObject]()
    var selectedVesselIndex = -1
    
    override func setupView() {
        super.setupView()
        txtLaycanFrom.delegate = self
        txtLaycanFrom.inputView = getDatePicker(selector: #selector(datePickerValueChanged3(_:)))
        txtLaycanTo.delegate = self
        txtLaycanTo.inputView = getDatePicker(selector: #selector(datePickerValueChanged4(_:)))
        txtVessel.delegate = self
        txtVessel.inputView = getPicker(tag: 0)
    }
    
    func clearPickerData() {
        self.vesselValue.removeAll()
    }
    
    @objc func datePickerValueChanged3(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        txtLaycanFrom.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func datePickerValueChanged4(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        txtLaycanTo.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func onBtnClear() {
        clearDefultText()
        txtLaycanTo.text = ""
        txtLaycanFrom.text = ""
        txtVessel.text = ""
    }
    
    func checkEmptyText() -> Bool {
        if checkdefaultEmpty() && txtLaycanFrom.text?.trim().length == 0 && txtLaycanTo.text?.trim().length == 0 && txtVessel.text?.trim().length == 0{
            return true
        }
        return false
    }
    
    func getVessel() -> String {
        return txtVessel.text == "" || self.selectedVesselIndex == -1 ? "" : self.vesselValue[self.selectedVesselIndex].Value
    }
    
    //Picker
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vesselValue.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vesselValue[row].Text
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if vesselValue.count > 0 {
            txtVessel.text = vesselValue[row].Text
            selectedVesselIndex = row
        }
    }
    //textfield
    override func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        super.textFieldDidEndEditing(textField, reason: reason)
        
        if textField == txtLaycanFrom || textField == txtLaycanTo {
            if textField.text == "" {
                let dateFormatter = DateFormatter()
                dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
                dateFormatter.dateFormat = "dd/MM/yyyy"
                textField.text = dateFormatter.string(from: Date())
            }
        }
        
        if textField == txtVessel {
            if vesselValue.count > 0 {
                textField.text = vesselValue[0].Text
                selectedVesselIndex = 0
            }
        }
    }
}
