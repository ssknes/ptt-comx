//
//  BaseDetailViewController.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/25/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import AEXML

class BaseDetailViewController : BaseViewController {
    var coverView: UIView!
    var progressHUD = MBProgressHUD()
    var dropdownProgressHUD = MBProgressHUD()
    var openFromNoti = false
    var onFront = false
    var purchaseIDNoti = ""
    var notiRowSelect = 0
    
    var tabArr = [String]()
    var statusArr = [String]()
    
    var FullDataSource = [[[String: String]]]()
    var FullFiltered = [[[String: String]]]()
    var isExpand = [[Bool]]()
    var isExpandHeight = [[CGFloat]]()
    var tempButtonArray = [[[Button]]]()
    
    var showFilter = false
    var selectedTap = 0
    var searchText = ""
    
    var pickerViewDataSource = [[String]]()
    var pickerView = UIPickerView()
    var currentTextField: UITextField?
    var pickerMode = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coverView = UIView.init(frame: UIApplication.shared.keyWindow!.frame)
        self.coverView.backgroundColor = UIColor.clear
        //self.automaticallyAdjustsScrollViewInsets = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkConnection()
    }
    
    func showProgressHud(_ text: String) {
        self.view.addSubview(self.coverView)
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
    /*
    func reloadBadge() {
        NotificationCenter.default.post(name: Notification.Name("DetailReloadBadge"), object:nil)
    }*/
    
    func printPDF(_ sender: AnyObject) {
        progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.detailsLabel.text = "Loading File" //ProgressHUD (text: "Loading File...")
        let button: ActionButton = sender as! ActionButton
        APIManager.shareInstance.getPDF(functionID: functionIds.print_pdf, transaction_id: button.transaction_id) { (success, xmlError, dataDict) in
            self.progressHUD.hide(animated: true)
            if success {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "pdf") as! PDFViewController
                vc.url = dataDict["pdf_path"] as! String
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                MyUtilities.showErrorAlert(message: xmlError.message, viewController: self)
            }
        }
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
}
