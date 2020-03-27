//
//  BaseListViewController.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 24/4/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import AEXML

class BaseListViewController : BaseViewController {
    @IBOutlet weak var mainCollectionView: UICollectionView!
    var progressHUD = MBProgressHUD()
    var dropdownProgressHUD = MBProgressHUD()
    var openFromNoti = false
    var onFront = false
    var purchaseIDNoti = ""
    var notiRowSelect = 0
    
    var tabArr = [String]()
    var statusArr = [String]()
    
    var FullDataSource = [[[String: Any]]]()
    var FullFiltered = [[[String: Any]]]()
    var CellHeight = [[CGFloat]]()
    
    var showFilter = false
    var selectedTap = 0
    var searchText = ""
    
    var pickerViewDataSource = [[String]]()
    var pickerView = UIPickerView()
    var currentTextField: UITextField?
    var pickerMode = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCollectionView.register(UINib.init(nibName: "StatusButtonCell", bundle: nil), forCellWithReuseIdentifier: "statuscell")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkConnection()
    }
    
    func reloadData() {
        
    }
    
    func doLoadDataSuccess(success: Bool, xmlError: MyError, dataDict: [String: Any]) {
        progressHUD.removeFromSuperview()
        //Do Any Thing
    }
    
    func doLoadDataSuccess(success: Bool, xmlError: MyError, xmlDoc: AEXMLDocument?) {
        progressHUD.removeFromSuperview()
        //Do Any Thing
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func shortMonthDateFormatter(dateStr: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.dateFormat = "dd-MMM-yyy"
            return dateFormatter.string(from: (date))
        }
        return dateStr
    }
    
    func checkConnection(){
        
    }
    
    func setStatusArr(systemType: String) {
        for data in (GlobalVar.sharedInstance.FrontData) where data.name.uppercased() == systemType.uppercased() {
            log.info("PPPPPPPPPPP ======>>>> \(data.status)")
            self.tabArr = data.tab.split(separator: "|")
            self.statusArr = data.status.split(separator: "|")
             log.info("QQQQQQQ ======>>>> \(self.statusArr)")
        }
    }
}

