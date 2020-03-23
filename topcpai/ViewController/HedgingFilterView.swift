//
//  HedgingFilterView.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 9/1/2561 BE.
//  Copyright © 2561 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class HedgingFilterView: BaseFilterView {
    @IBOutlet var lblTicketType: UILabel!
    @IBOutlet var txtTicketType: UITextField!
    
    let h: CGFloat = 180
    
    var selectedTypeIndex = -1
    var typeValue = [PickerObject]()
    
    func setText(Type: String) {
        if Type == System.Hedge_sett {
            lblTicketType.text = "Type"
        } else {
            lblTicketType.text = "Ticket Type"
        }
    }
    
    override func setupView() {
        super.setupView()
        txtTicketType.inputView = getPicker(tag: 0)
    }
    
    func getticketType() -> String {
        if txtTicketType.text == "ALL" {
            return ""
        }
        return txtTicketType.text ?? ""
    }
    
    
    @IBAction func onBtnClear() {
        clearDefultText()
        txtTicketType.text = ""
    }
    
    func checkEmptyText() -> Bool {
        if checkdefaultEmpty() && txtTicketType.text?.trim().count == 0 {
            return true
        }
        return false
    }
    
    func clearPickerData() {
        typeValue.removeAll()
    }
    
    //Picker
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return typeValue.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return typeValue[row].Text
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch  pickerView.tag {
        case 0:
            if typeValue.count > 0 {
                txtTicketType.text = typeValue[row].Text
                selectedTypeIndex = row
            }
        default:
           break
        }
    }
    //textfield
    override func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        super.textFieldDidEndEditing(textField, reason: reason)
        
        if textField == txtTicketType && textField.text == "" {
            if typeValue.count > 0 {
                textField.text = typeValue[0].Text
                selectedTypeIndex = 0
            }
        }
    }
}
