//
//  BaseFilterView.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 22/10/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

protocol FilterViewDelegate: class {
    func hideKeyboard()
    func searchBarDidChange(_ searchText: String)
    func onBtnFilter()
    func onBtnSearch()
}

class PickerObject: NSObject {
    var Text: String = ""
    var Value: String = ""
    
    func setVal(data: [String: Any]) {
        self.Text = data["text"] as? String ?? ""
        self.Value = data["value"] as? String ?? ""
    }
}

class BaseFilterView: UIView {
    @IBOutlet var txtFromDate: UITextField!
    @IBOutlet var txtToDate: UITextField!
    @IBOutlet var btnSearch: UIButton!
    @IBOutlet var btnClear: UIButton!
    @IBOutlet var btnFilter: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    
    var SearchActive: Bool = false
    var filterDelegte: FilterViewDelegate?
    
    let l: CGFloat = 46
    
    func setupView() {
        txtFromDate.delegate = self
        txtToDate.delegate = self
        searchBar.delegate = self
        txtFromDate.inputView = getDatePicker(selector: #selector(datePickerValueChanged(_:)))
        txtToDate.inputView = getDatePicker(selector: #selector(datePickerValueChanged2(_:)))
    }
    
    func getDatePicker(selector: Selector) -> UIDatePicker{
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.addTarget(self, action: selector, for: .valueChanged)
        return datePickerView
    }
    
    func getDatePicker(type: UIDatePicker.Mode, selector: Selector) -> UIDatePicker{
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = type
        datePickerView.addTarget(self, action: selector, for: .valueChanged)
        return datePickerView
    }
    
    func getPicker(tag: Int) -> UIPickerView {
        let picker = UIPickerView()
        picker.delegate = self
        picker.tag = tag
        return picker
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        txtFromDate.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func datePickerValueChanged2(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        txtToDate.text = dateFormatter.string(from: sender.date)
    }
    
    func clearDefultText() {
        txtToDate.text = ""
        txtFromDate.text = ""
        searchBar.text = ""
    }
    
    func checkdefaultEmpty() -> Bool {
        if  txtToDate.text?.trim().length == 0 && txtFromDate.text?.trim().length == 0 && searchBar.text?.trim().count == 0 {
            return true
        }
        return false
    }
    
    @IBAction func onbtnFilter(_ sender: UIButton) {
        self.SearchActive = !self.SearchActive
        filterDelegte?.onBtnFilter()
    }
    @IBAction func onBtnSearch(_ sender: UIButton) {
        filterDelegte?.onBtnSearch()
    }
}

extension BaseFilterView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        filterDelegte?.hideKeyboard()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == txtToDate || textField == txtFromDate {
            if textField.text == "" {
                let dateFormatter = DateFormatter()
                dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
                dateFormatter.dateFormat = "dd/MM/yyyy"
                textField.text = dateFormatter.string(from: Date())
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}

extension BaseFilterView: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
extension BaseFilterView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        SearchActive = searchBar.text != "" ? true: false
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        SearchActive = searchBar.text != "" ? true: false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        SearchActive = searchBar.text != "" ? true: false
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        SearchActive = searchBar.text != "" ? true: false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SearchActive = searchBar.text != "" ? true: false
        filterDelegte?.hideKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        SearchActive = searchBar.text != "" ? true: false
        filterDelegte?.searchBarDidChange(searchText)
    }
}
