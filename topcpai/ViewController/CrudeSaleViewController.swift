//
//  CrudeSaleViewController.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 25/6/2561 BE.
//  Copyright © 2561 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class CrudeSaleViewController: BaseListViewController {
    @IBOutlet var vFilter: CrudeFilterView!
    @IBOutlet var mainCollectionViewCon: NSLayoutConstraint!
    @IBOutlet var mainTableView: UITableView!
    
    @IBOutlet weak var FilterConstraint: NSLayoutConstraint!
    
    var tempUserGroup: String = ""
    var tempStatus: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDropdownList()
        self.initTabArray()
        self.initCrudeFilter()
        self.mainTableView.separatorStyle = .none
        self.mainTableView.bounces = false
        
        mainTableView.register(UINib.init(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "datacell")
    }
    
    override func reloadData() {
        self.mainTableView.reloadData()
    }
    
    override func checkConnection(){
        if !APIManager.shareInstance.connectedToNetwork(){
            MyUtilities.showAckwithAction(title: "Sorry", message: "No Internet Connection", viewController: self, okAction: self.checkConnection)
        } else {
            self.loadData(system: System.Crude_O, statusArr: self.statusArr, from_date: "", to_date: "", crude: "", feedstock: "")
        }
    }
    
    func loadData(system: String, statusArr: [String], from_date: String, to_date: String, crude: String, feedstock: String) {
        self.progressHUD.hide(animated: true)
        if APIManager.shareInstance.connectedToNetwork() {
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
            
            if (to_date != "") {
                toDay = DataUtils.shared.getDateFromString(date: to_date)
            }
            strDay = DataUtils.shared.getStringFromDate(date: toDay)
            
            let tmpData = ["from_date": strTargetDay,
                           "to_date": strDay,
                           "index_7": feedstock,
                           "search_material": crude,
                           "statusString": DataUtils.shared.getStatusString(statusArr)] as [String: Any]
            
            APIManager.shareInstance.listTransaction(system: system, data: tmpData , callback: {
                (success, xmlError, xmlData) in
                self.progressHUD.hide(animated: true)
                let dataDict = DataUtils.shared.getDataDictFromXMLDoc(system: system, xmlDoc: xmlData, all: false)
                self.doLoadDataSuccess(success: success, xmlError: xmlError, dataDict: dataDict)
            })
        }else {
            MyUtilities.showAckwithAction(title: "Sorry", message: "No Internet Connection", viewController: self, okAction: nil)
        }
    }
    
    override func doLoadDataSuccess(success: Bool, xmlError: MyError, dataDict: [String : Any]) {
        
        if success {
            if (dataDict.count > 0) {
                self.FullDataSource.removeAll()
                self.FullFiltered.removeAll()
                
                if self.statusArr.count == 0 {
                    self.mainCollectionView.reloadData()
                    self.mainTableView.reloadData()
                    return
                }
                
                let count = self.statusArr.count - 1
                if statusArr.count == 0 {
                    self.mainCollectionView.reloadData()
                    self.mainTableView.reloadData()
                    return
                }
                for i in 0...count{
                    var muArr = [[String: Any]]()
                    for data in dataDict[System.Crude_O] as! [[String : Any]] {
//                        if data["status"] as! String == (self.statusArr[i]){
//                            muArr.append(data)
//                        }
                     if i == 0{
                      if (data["status"] as? String ?? "") == self.statusArr[0] {
                          muArr.append(data)
                      }
                      if (data["status"] as? String ?? "") == self.statusArr[1] {
                         let tmpAdvanceLoading = data["advance_loading_request_data"] as? [[String: Any]] ?? []
                         let tmpContractData = data["contract_data"] as? [[String: Any]] ?? []
                          if(tmpAdvanceLoading.count > 0){
                              for item in tmpAdvanceLoading where item["alr_status"] as? String == self.statusArr[0] {
                                  let result = DataUtils.shared.getResultDataAdvanceLoading(data:data)
                                 muArr.append(result)
                              }
                          }
                          if(tmpContractData.count > 0){
                              for item in tmpContractData where item["caf_status"] as? String == self.statusArr[0] {
                                  let result = DataUtils.shared.getResultDataContracData(data:data)
                                  muArr.append(result)
                              }
                          }
                      }}
                      
                       if i == 1{
                          if (data["status"] as? String ?? "") == self.statusArr[1] {
                              let result = DataUtils.shared.getResultDataApprovalForm(data:data)
                                  muArr.append(result)
                          }
                       }
                      
                      if i == 2{
                         if (data["status"] as? String ?? "") == self.statusArr[1] {
                            let tmpAdvanceLoading = data["advance_loading_request_data"] as? [[String: Any]] ?? []
                             if(tmpAdvanceLoading.count > 0){
                                 for item in tmpAdvanceLoading where item["alr_status"] as? String == self.statusArr[1] {
                                     let ttt = DataUtils.shared.getResultDataAdvanceLoading(data:data)
                                     muArr.append(ttt)
                                 }
                             }
                      }
                      
                      if i == 3{
                         if (data["status"] as? String ?? "") == self.statusArr[1] {
                            let tmpContractData = data["contract_data"] as? [[String: Any]] ?? []
                              if(tmpContractData.count > 0){
                                 for item in tmpContractData where item["caf_status"] as? String == self.statusArr[1] {
                                     let ttt = DataUtils.shared.getResultDataContracData(data:data)
                                     muArr.append(ttt)
                                 }
                             }}}
                          }
                      
                      if i == 4{
                         if (data["status"] as? String ?? "") == self.statusArr[4] {
                              muArr.append(data)
                         }
                      }
                    }
            
                    muArr = DataUtils.shared.getSortedByDateData(inputArr: muArr)
                    var fuArr = [[String : Any]]()
                    fuArr = muArr.filter({ (text) -> Bool in
                        return DataUtils.shared.getFilterResult(data: text, text: searchText)
                    })
                    self.FullDataSource.append(muArr)
                    if self.vFilter.checkEmptyText() {
                        self.FullFiltered.append(muArr)
                    } else {
                        self.FullFiltered.append(fuArr)
                    }
                }
                for i in 0...(tabArr.count - 1) {
                    var temph = [CGFloat]()
                    for _ in self.FullDataSource[i] {
                        temph.append(1)
                    }
                    self.CellHeight[i] = temph
                }
                self.mainCollectionView.reloadData()
                self.mainTableView.reloadData()
            }
        }else {
            self.progressHUD.hide(animated: true)
            MyUtilities.showErrorAlert(message: xmlError.message, viewController: self)
        }
        
        if self.openFromNoti{
            self.notiRowSelect = self.FullDataSource[selectedTap].firstIndex(where: {($0["purchase_no"] as! String) == self.purchaseIDNoti}) ?? 0
            if self.FullDataSource[selectedTap].count > 0 {
                self.mainTableView.selectRow(at: IndexPath(row: self.notiRowSelect, section: 0), animated: true, scrollPosition: .middle)
                (self.mainTableView.cellForRow(at: IndexPath(row: self.notiRowSelect, section: 0)) as! ListCell).doSelect()
                //self.tableView(self.mainTableView, didSelectRowAt: IndexPath(row: self.notiRowSelect, section: 0))
            }
            self.openFromNoti = false
        }
    }
    func loadDropdownList() {
        if APIManager.shareInstance.connectedToNetwork(){
            self.dropdownProgressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.dropdownProgressHUD.detailsLabel.text = "loading dropdown list"
            vFilter.clearPickerData()
            let batch = DispatchGroup()
            batch.enter()
            APIManager.shareInstance.getDropdownList(key: "MATERIALS", system: System.Crude_O, type: "") { (success, err, dataDict) in
                if success {
                    if let data: [[String: String]] = dataDict[System.Dropdown] as? [[String: String]]{
                        if data.count > 0 {
                            let t = PickerObject()
                            t.setVal(data: ["text": "All", "value": ""])
                            self.vFilter.crudeValue.append(t)
                        }
                        for source in data {
                            let tmp = PickerObject()
                            tmp.setVal(data: source)
                            self.vFilter.crudeValue.append(tmp)
                        }
                    }
                }
                batch.leave()
            }
            batch.enter()
            APIManager.shareInstance.getFeedDropdownList(key: "JSON_CRUDE_PURCHASE"){
                (success, err, dataDict) in
                if success{
                    if let data: [[String: String]] = dataDict[System.Dropdown] as? [[String: String]]{
                        if data.count > 0 {
                            let t = PickerObject()
                            t.setVal(data: ["text": "All", "value": ""])
                            self.vFilter.feedStockValue.append(t)
                        }
                        for source in data {
                            let tmp = PickerObject()
                            tmp.setVal(data: source)
                            self.vFilter.feedStockValue.append(tmp)
                        }
                    }
                }
                batch.leave()
            }
            batch.notify(queue: .main) {
                self.dropdownProgressHUD.hide(animated: true)
            }
        } else {
            self.dropdownProgressHUD.hide(animated: true)
            MyUtilities.showAckwithAction(title: "Sorry", message: "No Internet Connection", viewController: self, okAction: nil)
        }
    }
}

extension CrudeSaleViewController {
    func initTabArray(){
        tabArr.removeAll()
        statusArr.removeAll()
        self.CellHeight.removeAll()
        
        setStatusArr(systemType: System.Crude_O)
        
        for _ in self.tabArr {
            self.CellHeight.append([])
        }
        if tabArr.count % 4 == 0 {
            self.mainCollectionViewCon.constant = CGFloat(45 + (45 * (tabArr.count / 4)) - 45)
        } else {
            self.mainCollectionViewCon.constant = CGFloat(45 + (45 * (tabArr.count / 4)))
        }
    }
}

extension CrudeSaleViewController  {  //Filter View
    
    func initCrudeFilter() {
        self.FilterConstraint.constant = vFilter.l
        vFilter.SearchActive = false
        vFilter.setupView()
        vFilter.filterDelegte = self
    }
}

extension CrudeSaleViewController: FilterViewDelegate {
    func searchBarDidChange(_ searchText: String) {
        self.searchText = searchText
        
        let x = self.FullFiltered.count - 1
        if x < 0 {
            return
        }
        for i in 0...x{
            var temp = [[String : Any]]()
            temp = (self.FullDataSource[i] ).filter({ (text) -> Bool in
                return DataUtils.shared.getFilterResult(data: text, text: searchText)
            })
            temp = DataUtils.shared.getSortedByDateData(inputArr: temp)
            self.FullFiltered[i] = temp
        }
        
        self.mainCollectionView.reloadData()
        self.mainTableView.reloadData()
    }
    
    func onBtnFilter() {
        if self.vFilter.SearchActive{
            self.FilterConstraint.constant = self.vFilter.h
        } else {
            self.FilterConstraint.constant = self.vFilter.l
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func onBtnSearch() {
        self.vFilter.searchBar.text = ""
        self.doSearch(System: System.Crude_O,
                      statusArr: self.statusArr,
                      Date1: vFilter.txtFromDate.text!,
                      Date2: vFilter.txtToDate.text!,
                      txtCrudeName: vFilter.getCrudeName(),
                      txtFeedStock: vFilter.getFeedStock())
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
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var fromDate = Date1 == "" ? "" : Date1
        var toDate = Date2 == "" ? "" : Date2
        let crudeName = txtCrudeName
        let feedStock = txtFeedStock
        if fromDate != "" && toDate != "" {
            let startDate = dateFormatter.date(from: fromDate)!
            let endDate = dateFormatter.date(from: toDate)!
            if startDate <= endDate {
                let dateFormatter2 = DateFormatter()
                dateFormatter2.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
                dateFormatter2.dateFormat = "dd-MMM-yyyy"
                fromDate = dateFormatter2.string(from: startDate)
                toDate = dateFormatter2.string(from: endDate)
                self.loadData(system: System, statusArr: statusArr, from_date: "", to_date: "", crude: crudeName, feedstock: feedStock)
                
            } else {
                MyUtilities.showErrorAlert(message: "Start date must be less than end date", viewController: self)
            }
        } else {
            self.loadData(system: System, statusArr: statusArr, from_date: "", to_date: "", crude: "", feedstock: "")
        }
    }
}

extension CrudeSaleViewController:  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        doSelectTap(Selected: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "statuscell", for: indexPath) as! StatusButtonCell
        
        if indexPath.item == selectedTap {
            cell.setSelect(input: true)
        }else{
            cell.setSelect(input: false)
        }
        cell.lblStatus.text = tabArr[indexPath.item]
        
        var temp = [String]()
        if vFilter.SearchActive {
            if FullFiltered.count > 0 {
                for i in 0...(FullFiltered.count - 1) {
                    temp.append(String(FullFiltered[i].count))
                }
            }
        } else {
            if FullDataSource.count > 0 {
                for i in 0...(FullDataSource.count - 1) {
                    temp.append(String(FullDataSource[i].count))
                }
            }
        }
        if temp.count > indexPath.item {
            cell.lblCounter.text = temp[indexPath.item]
        } else {
            cell.lblCounter.text = "0"
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.tabArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.mainCollectionView {
            let temp = collectionView.numberOfItems(inSection: 0) % 4
            switch temp{
            case 1:
                if collectionView.numberOfItems(inSection: 0) - indexPath.row == 1{
                    return CGSize(width: CGFloat(collectionView.frame.size.width / 1) - 1, height: CGFloat(45))
                }else{
                    return CGSize(width: CGFloat(collectionView.frame.size.width / 4) - 1, height: CGFloat(45))
                }
            case 2:
                if collectionView.numberOfItems(inSection: 0) - indexPath.row == 1 ||
                    collectionView.numberOfItems(inSection: 0) - indexPath.row == 2{
                    return CGSize(width: CGFloat(collectionView.frame.size.width / 2) - 1, height: CGFloat(45))
                }else{
                    return CGSize(width: CGFloat(collectionView.frame.size.width / 4) - 1, height: CGFloat(45))
                }
            case 3:
                if collectionView.numberOfItems(inSection: 0) - indexPath.row == 1 ||
                    collectionView.numberOfItems(inSection: 0) - indexPath.row == 2 ||
                    collectionView.numberOfItems(inSection: 0) - indexPath.row == 3 {
                    return CGSize(width: CGFloat(collectionView.frame.size.width / 3) - 1, height: CGFloat(45))
                }else{
                    return CGSize(width: CGFloat(collectionView.frame.size.width / 4) - 1, height: CGFloat(45))
                }
                
            default:
                return CGSize(width: CGFloat(collectionView.frame.size.width / 4) - 1, height: CGFloat(45))
            }
        }
        return CGSize.init(width: collectionView.frame.size.width / 4, height: collectionView.frame.size.height)
    }
}

extension CrudeSaleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.vFilter.SearchActive {
            if self.FullFiltered.count > 0 {
                return self.FullFiltered[selectedTap].count
            }
            return 0
        } else {
            if self.FullDataSource.count > 0 {
                return self.FullDataSource[selectedTap].count
            }
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell") as! ListCell
        if self.vFilter.SearchActive {
            CellHeight[selectedTap][indexPath.row] = cell.setView(Data: self.FullFiltered[selectedTap][indexPath.row])
        } else {
            CellHeight[selectedTap][indexPath.row] = cell.setView(Data: self.FullDataSource[selectedTap][indexPath.row])
        }
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func doSelectTap(Selected : Int) {
        self.selectedTap = Selected
        self.mainTableView.reloadData()
        self.mainCollectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if CellHeight[selectedTap].count == 0 {
            return 120
        }
        if indexPath.row > CellHeight[selectedTap].count {
            return 120
        }
        if CellHeight[selectedTap][indexPath.row] == 0 {
            return 120
        }
        return CellHeight[selectedTap][indexPath.row]
    }
}

extension CrudeSaleViewController: ListCellDelegate {
    func onBtnMore(_ Sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailView") as! DetailViewController
        var data = [[String: Any]]()
        if self.vFilter.SearchActive {
            data = self.FullFiltered[selectedTap]
        } else {
            data = self.FullDataSource[selectedTap]
        }
        vc.DataDict = data[Sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
