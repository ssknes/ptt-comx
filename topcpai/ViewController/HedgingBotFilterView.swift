//
//  HedgingBotFilterView.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 13/1/2563 BE.
//  Copyright © 2563 PTT ICT Solutions. All rights reserved.
//


import UIKit

class HedgingBotFilterView: BaseFilterView {
    @IBOutlet var txtTradingBook: UITextField!
    
    let h: CGFloat = 180
    
    var selectedTypeIndex = -1
    var selecterPeriodQuaterIndex = -1
    var selectedPeriodYearIndex = -1
    var typeValue = [PickerObject]()
    var periodQuaterValue = ["ALL", "Q1", "Q2", "Q3", "Q4"]
    var periodYearValue: [String] {
        var years = [String]()
        years.append("ALL")
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        let formattedDate = format.string(from: Date())
        for i in (Int(formattedDate)!-70..<Int(formattedDate)!+1).reversed() {
            years.append("\(i)")
        }
        return years
    }
    
    override func setupView() {
        txtFromDate.delegate = self
        txtToDate.delegate = self
        searchBar.delegate = self
        txtTradingBook.inputView = getPicker(tag: 0)
        txtFromDate.inputView = getPicker(tag: 1)
        txtToDate.inputView = getPicker(tag: 2)
        txtTradingBook.delegate = self
    }
    
    func getTradingBook() -> String {
        if txtTradingBook.text == "ALL" {
            return ""
        }
        return txtTradingBook.text ?? ""
    }
    func getQuator() -> String {
        if txtFromDate.text == "ALL" {
            return ""
        }
        return txtFromDate.text ?? ""
    }
    func getYear() -> String {
        if txtToDate.text == "ALL" {
            return ""
        }
        return txtToDate.text ?? ""
    }
    
    
    @IBAction func onBtnClear() {
        clearDefultText()
        txtTradingBook.text = ""
    }
    
    func checkEmptyText() -> Bool {
        if checkdefaultEmpty() && txtTradingBook.text?.trim().count == 0 {
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
        case 1:
            return periodQuaterValue.count
        case 2:
            return periodYearValue.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return typeValue[row].Text
        case 1:
            return periodQuaterValue[row]
        case 2:
            return periodYearValue[row]
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch  pickerView.tag {
        case 0:
            if typeValue.count > 0 {
                txtTradingBook.text = typeValue[row].Text
                selectedTypeIndex = row
            }
        case 1:
            txtFromDate.text = periodQuaterValue[row]
            selecterPeriodQuaterIndex = row
        case 2:
            txtToDate.text = periodYearValue[row]
            selectedPeriodYearIndex = row
        default:
           break
        }
    }
    //textfield
    override func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        super.textFieldDidEndEditing(textField, reason: reason)
        
        if textField == txtTradingBook && textField.text == "" {
            if typeValue.count > 0 {
                textField.text = typeValue[0].Text
                selectedTypeIndex = 0
            }
        }
        if textField == txtFromDate && textField.text == "" {
            txtFromDate.text = periodQuaterValue[0]
            selecterPeriodQuaterIndex = 0
        }
        if textField == txtToDate && textField.text == "" {
            txtToDate.text = periodYearValue[0]
            selectedPeriodYearIndex = 0
        }
    }
}
