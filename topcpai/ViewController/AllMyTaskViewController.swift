//
//  AllMyTaskViewController.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 12/4/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import AEXML

protocol AllMyTaskViewDelegate: class {
    func onBtnMore(Data: [String: Any])
    func hideView()
    func setCounter(value: Int)
}

class AllMyTaskViewController: BaseViewController { // UIViewController {
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var Filter: MyTaskFilterView!
    @IBOutlet weak var FilterConstraint: NSLayoutConstraint!
    
    var progressHUD = MBProgressHUD()
    var openFromNoti = false
    var onFront = false
    var purchaseIDNoti = ""
    var notiRowSelect = 0
    
    var tabArr = [String]()
    
    var FullDataSource = [[String: Any]]()
    var FullFiltered = [[String: Any]]()
    var CellHeight = [CGFloat]()
    
    var searchText = ""
    
    weak var delegate: AllMyTaskViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        self.initFilter()
        self.mainTableView.separatorStyle = .none
        self.mainTableView.bounces = false
        mainTableView.register(UINib.init(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "datacell")
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func checkConnection(){
        if !APIManager.shareInstance.connectedToNetwork(){
            MyUtilities.showAckwithAction(title: "Sorry", message: "No Internet Connection", viewController: self, okAction: self.checkConnection)
        } else {
            self.loadData(system: System.All_My_Task, from_date: "", to_date: "")
        }
    }
    
    func loadData(system: String, from_date: String, to_date: String) {
        
        if APIManager.shareInstance.connectedToNetwork() {
            progressHUD.hide(animated: true)
            self.progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.progressHUD.detailsLabel.text = "Loading Transaction..."
            //Let default date for 3 month
            var toDay : Date = Date()
            var targetDate : Date = Date()
            var strDay = ""
            var strTargetDay = ""
            
            if (from_date != ""){
                targetDate = DataUtils.shared.getDateFromString(date: from_date)
            }else{
                targetDate = DataUtils.shared.getLast3MonthDate(date: toDay)
            }
            strTargetDay = DataUtils.shared.getStringFromDate(date: targetDate)
            if (to_date != ""){
                toDay = DataUtils.shared.getDateFromString(date: to_date)
            }
            strDay = DataUtils.shared.getStringFromDate(date: toDay)
            
            let tmpData = ["from_date": strTargetDay,
                           "to_date": strDay] as [String: Any]
            
            APIManager.shareInstance.listTransaction(system: system, data: tmpData , callback: {
                (success, xmlError, xmlData) in
                self.progressHUD.hide(animated: true)
                let dataDict = DataUtils.shared.getDataDictFromXMLDoc(system: system, xmlDoc: xmlData, all: true)
                self.doLoadDataSuccess(success: success, xmlError: xmlError, dataDict: dataDict)
            })
        } else {
            MyUtilities.showAckwithAction(title: "Sorry", message: "No Internet Connection", viewController: self, okAction: nil)
        }
    }
    func doLoadDataSuccess(success: Bool, xmlError: MyError, dataDict: [String : Any]) {
        self.progressHUD.hide(animated: true)
        if success {
            if (dataDict.count > 0) {
                self.FullDataSource.removeAll()
                self.FullFiltered.removeAll()
                
                var muArr = [[String: Any]]()
                for data in dataDict[System.All_My_Task] as! [[String: Any]] {
                    muArr.append(data)
                }
                muArr = DataUtils.shared.getSortedByDateData(inputArr: muArr)
                
                var fuArr = [[String : Any]]()
                fuArr = muArr.filter({ (text) -> Bool in
                    return DataUtils.shared.getFilterResult(data: text, text: self.searchText)
                })
                self.FullDataSource = muArr
                if self.Filter.checkEmptyText() {
                    self.FullFiltered = muArr
                } else {
                    self.FullFiltered = fuArr
                }
                var temph = [CGFloat]()
                for _ in self.FullDataSource {
                    temph.append(0)
                }
                self.CellHeight = temph
                delegate?.setCounter(value: self.FullDataSource.count)
                self.mainTableView.reloadData()
            } else {
                delegate?.hideView()
            }
        }else {
            MyUtilities.showErrorAlert(message: xmlError.message, viewController: self)
        }
    }
}

extension AllMyTaskViewController {  //Filter View
    func initFilter() {
        self.FilterConstraint.constant = Filter.l
        Filter.SearchActive = false
        Filter.searchBar.delegate = self
        Filter.btnFilter.addTarget(self, action: #selector(onFilterClicked), for: .touchUpInside)
    }
    
    @objc func onFilterClicked() {
        if self.FilterConstraint.constant == self.Filter.h {
            self.FilterConstraint.constant = self.Filter.l
        } else {
            self.FilterConstraint.constant = self.Filter.h
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

extension AllMyTaskViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        Filter.SearchActive = (searchBar.text != "") ? true : false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        Filter.SearchActive = (searchBar.text != "") ? true : false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Filter.SearchActive = (searchBar.text != "") ? true : false
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        Filter.SearchActive = (searchBar.text != "") ? true : false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Filter.SearchActive = (searchBar.text != "") ? true : false
        hideKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        Filter.SearchActive = (searchBar.text != "") ? true : false
        
        let x = self.FullFiltered.count - 1
        if x < 0 {
            return
        }
        var temp = [[String : Any]]()
        temp = (self.FullDataSource ).filter({ (text) -> Bool in
            return DataUtils.shared.getFilterResult(data: text, text: searchText)
        })
        temp = DataUtils.shared.getSortedByDateData(inputArr: temp)
        self.FullFiltered = temp
        self.mainTableView.reloadData()
    }
    
    func doSearch(System: String, statusArr: [String], Date1: String, Date2: String, txtCrudeName: String, txtFeedStock: String) {
        if Date1 != "" {
            if Date2 == "" {
                MyUtilities.showErrorAlert(message: "End date can't be empty", viewController: self)
                return
            }
        } else if Date2 != "" {
            if Date1 == "" {
                MyUtilities.showErrorAlert(message: "From date can't be empty", viewController: self)
                return
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let fromDate = Date1 == "" ? "" : Date1 + " 00:00:00"
        let toDate = Date2 == "" ? "" : Date2 + " 00:00:00"
        if fromDate != "" && toDate != "" {
            let startDate = dateFormatter.date(from: fromDate)!
            let endDate = dateFormatter.date(from: toDate)!
            if startDate <= endDate {
                //self.loadData(system: System, statusArr: self.statusArr, from_date: fromDate, to_date: toDate, crude_name: crudeName, feed_stock: feedStock)
            } else {
                MyUtilities.showErrorAlert(message: "Start date must be less than end date", viewController: self)
            }
        } else {
            //self.loadData(system: System, statusArr: self.statusArr, from_date: "", to_date: "", crude_name: crudeName, feed_stock: feedStock)
        }
    }
}

extension AllMyTaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.Filter.SearchActive {
            if self.FullFiltered.count > 0 {
                return self.FullFiltered.count
            }
            return 0
        } else {
            if self.FullDataSource.count > 0 {
                return self.FullDataSource.count
            }
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell") as! ListCell
        if self.Filter.SearchActive {
            CellHeight[indexPath.row] = cell.setView(Data: self.FullFiltered[indexPath.row])
        } else {
            CellHeight[indexPath.row] = cell.setView(Data: self.FullDataSource[indexPath.row])
        }
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if CellHeight[indexPath.row] == 0 {
            return 120
        }
        return CellHeight[indexPath.row]
    }
}

extension AllMyTaskViewController: ListCellDelegate {
    func onBtnMore(_ Sender: UIButton) {
        var data = [[String: Any]]()
        if self.Filter.SearchActive {
            data = self.FullFiltered
        } else {
            data = self.FullDataSource
        }
        delegate?.onBtnMore(Data: data[Sender.tag])
    }
}

class MyTaskFilterView: UIView {
    @IBOutlet var btnFilter: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    
    let h: CGFloat = 44//184
    let l: CGFloat = 44
    var SearchActive: Bool = false
    
    func checkEmptyText() -> Bool {
        if searchBar.text?.count == 0 {
            return true
        }
        return false
    }
}
