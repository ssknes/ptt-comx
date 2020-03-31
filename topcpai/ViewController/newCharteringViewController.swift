//
//  newCharteringViewController.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/25/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//
import Foundation
import UIKit
import MBProgressHUD
import AEXML

class newCharteringViewController: BaseListViewController { // UIViewController {
    
    @IBOutlet var vFilter: CharteringFilterView!
    @IBOutlet var mainCollectionViewCon: NSLayoutConstraint!
    @IBOutlet var mainTableView: UITableView!
    
    @IBOutlet weak var FilterConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTabArray()
        self.initCharteringFilter()
        self.loadDropdownList()
        self.mainTableView.separatorStyle = .none
        self.mainTableView.bounces = false
        mainTableView.register(UINib.init(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "datacell")
    }
    
    override func reloadData() {
        self.mainTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func checkConnection(){
        if !APIManager.shareInstance.connectedToNetwork(){
            MyUtilities.showAckwithAction(title: "Sorry", message: "No Internet Connection", viewController: self, okAction: self.checkConnection)
        } else {
            self.loadData(System: System.Chartering, statusArr: self.statusArr, from_date: "", to_date: "", from_laycan: "", to_laycan: "", vessel: "")
        }
    }
    
    func loadData(System: String, statusArr: [String], from_date: String, to_date: String, from_laycan: String, to_laycan: String, vessel: String) {
        if APIManager.shareInstance.connectedToNetwork() {
            self.progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.progressHUD.detailsLabel.text = "Loading Transaction..."
            var index = [String]()
            for i in 0..<20 {
                switch i {
                case 4:
                    index.append(vessel)
                case 18:
                    index.append(from_laycan)
                case 19:
                    index.append(to_laycan)
                default:
                    index.append("")
                }
            }
            //New
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
                           "to_date": strDay,
                           "index": index,
                           "statusString": DataUtils.shared.getStatusString(statusArr)] as [String: Any]
            
            APIManager.shareInstance.listTransaction(system: System, data: tmpData, callback: {
                (success, xmlError, xmlData) in
                self.progressHUD.hide(animated: true)
                let dataDict = DataUtils.shared.getDataDictFromXMLDoc(system: System, xmlDoc: xmlData, all: false)
                self.doLoadDataSuccess(success: success, xmlError: xmlError, dataDict: dataDict)
            })
        } else {
            MyUtilities.showAckwithAction(title: "Sorry", message: "No Internet Connection", viewController: self, okAction: nil)
        }
    }
    override func doLoadDataSuccess(success: Bool, xmlError: MyError, dataDict: [String : Any]) {
        if success {
            if (dataDict.count > 0) {
                self.FullDataSource.removeAll()
                self.FullFiltered.removeAll()
                
                let count = self.statusArr.count - 1
                if statusArr.count == 0 {
                    self.mainCollectionView.reloadData()
                    self.mainTableView.reloadData()
                    return
                }
                for i in 0...count {
                    var muArr = [[String: Any]]()
                    for data in dataDict[System.Chartering] as! [[String : Any]] {
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
                        return DataUtils.shared.getFilterResult(data: text, text: self.searchText)
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
                        temph.append(0)
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
            self.notiRowSelect = self.FullDataSource[selectedTap].firstIndex(where: {$0["purchase_no"] as! String == self.purchaseIDNoti}) ?? 0
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
            APIManager.shareInstance.getDropdownList(key: "VEHICLE", system: "CPAI", type: "CHIVESCS|CHOVESCS|CHIVESMT|CHOVESMT") { (success, err, dataDict) in
                if success {
                    if let data: [[String: String]] = dataDict[System.Dropdown] as? [[String: String]]{
                        if data.count > 0 {
                            let t = PickerObject()
                            t.setVal(data: ["text": "All", "value": ""])
                            self.vFilter.vesselValue.append(t)
                        }
                        for source in data {
                            let tmp = PickerObject()
                            tmp.setVal(data: source)
                            self.vFilter.vesselValue.append(tmp)
                        }
                    }
                }
                self.dropdownProgressHUD.hide(animated: true)
            }
        } else {
            self.dropdownProgressHUD.hide(animated: true)
            MyUtilities.showAckwithAction(title: "Sorry", message: "No Internet Connection", viewController: self, okAction: nil)
        }
    }
}

extension newCharteringViewController {
    func initTabArray(){
        tabArr.removeAll()
        statusArr.removeAll()
        self.CellHeight.removeAll()
        setStatusArr(systemType: System.Chartering)
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

extension newCharteringViewController { //Filter View
    func initCharteringFilter() {
        self.FilterConstraint.constant = vFilter.l
        vFilter.SearchActive = false
        vFilter.setupView()
        vFilter.filterDelegte = self
    }
}

extension newCharteringViewController: FilterViewDelegate {
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
            temp = DataUtils.shared.getSortedByDateData(inputArr: temp) as! [[String : String]]
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
        self.doSearch(System: System.Chartering,
                      statusArr: self.statusArr,
                      Date1: vFilter.txtFromDate.text!,
                      Date2: vFilter.txtToDate.text!,
                      Date3: vFilter.txtLaycanFrom.text!,
                      Date4: vFilter.txtLaycanTo.text!,
                      txtVessel: vFilter.getVessel())
    }
    
    func doSearch(System: String, statusArr: [String], Date1: String, Date2: String, Date3: String, Date4: String, txtVessel: String) {
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
        if Date3 != "" {
            if Date4 == "" {
                MyUtilities.showErrorAlert(message: "Laycan End date can't be empty", viewController: self)
                return
            }
        } else if Date4 != "" {
            if Date3 == "" {
                MyUtilities.showErrorAlert(message: "Laycan From date can't be empty", viewController: self)
                return
            }
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let fromDate = Date1 == "" ? "" : Date1 + " 00:00:00"
        let toDate = Date2 == "" ? "" : Date2 + " 00:00:00"
        let fromLaycan = Date3 == "" ? "" : Date3 + " 00:00:00"
        let toLaycan = Date4 == "" ? "" : Date4 + " 00:00:00"
        let vessel = txtVessel
        if fromDate != "" && toDate != "" {
            let startDate = dateFormatter.date(from: fromDate)!
            let endDate = dateFormatter.date(from: toDate)!
            if startDate > endDate {
                MyUtilities.showErrorAlert(message: "Start date must be less than end date", viewController: self)
                return
            }
        }
        if fromLaycan != "" && toLaycan != "" {
            let startLaycan = dateFormatter.date(from: fromLaycan)!
            let endLaycan = dateFormatter.date(from: toLaycan)!
            if startLaycan > endLaycan {
                MyUtilities.showErrorAlert(message: "Start laycan must be less than end laycan", viewController: self)
                return
            }
        }
        self.loadData(System: System, statusArr: statusArr, from_date: fromDate, to_date: toDate, from_laycan: fromLaycan, to_laycan: toLaycan, vessel: vessel)
    }
}

extension newCharteringViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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


extension newCharteringViewController: UITableViewDelegate, UITableViewDataSource {
    
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
extension newCharteringViewController: ListCellDelegate {
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
