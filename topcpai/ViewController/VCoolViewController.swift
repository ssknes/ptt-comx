//
//  VCoolViewController.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/29/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//



import Foundation
import UIKit
import MBProgressHUD
import AEXML

protocol vcoolViewDelegate: class {
    func startEdit()
}

class VCoolViewController: BaseListViewController, vcoolViewDelegate {
    @IBOutlet var vcoolFilter: VCoolFilterView!
    @IBOutlet var mainCollectionViewCon: NSLayoutConstraint!
    @IBOutlet var mainTableView: UITableView!
    
    @IBOutlet weak var FilterConstraint: NSLayoutConstraint!
    
    var vcoolEditing: Bool = false
    var tempUserGroup: String = ""
    var tempStatus: String = ""
    
    func startEdit() {
        vcoolEditing = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDropdownList()
        self.initTabArray()
        self.initvcoolFilter()
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
            self.loadData(system: System.VCool, statusArr: self.statusArr, from_date: "", to_date: "", dis_from: "", dis_to: "", crude: "", country: "", supplier: "")
        }
    }
    
    func loadData(system: String, statusArr: [String], from_date: String, to_date: String,dis_from: String, dis_to: String, crude: String, country: String, supplier: String) {
        self.progressHUD.hide(animated: true)
        if APIManager.shareInstance.connectedToNetwork() {
            self.progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.progressHUD.detailsLabel.text = "Loading Transaction..."
            var index = [String]()
            for i in 0..<20 {
                switch i {
                case 9://10
                    index.append(crude)
                    break
                case 10://11
                    index.append(country)
                    break
                case 11://12
                    index.append(supplier)
                    break
                case 18://19
                    index.append(dis_from)
                    break
                case 19://20
                    index.append(dis_to)
                default:
                    index.append("")
                    break
                }
            }
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
                           "index": index,
                           "statusString": DataUtils.shared.getStatusString(statusArr)] as [String: Any]
            
            APIManager.shareInstance.listTransaction(system: system, data: tmpData, callback: {
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
                
                let count = self.statusArr.count - 1
                if statusArr.count == 0 {
                    self.mainCollectionView.reloadData()
                    self.mainTableView.reloadData()
                    return
                }
                for i in 0...count{
                    var muArr = [[String: Any]]()
                    let dataTestStrings = statusArr[i].split(separator: " ")
                    for data in dataDict[System.VCool] as! [[String : Any]] {
                        if dataTestStrings.count > 1 { //Waiting ??? Approved
                            let dataString =  (data["status"] as? String ?? "").split(separator: " ")
                            if dataTestStrings[0].lowercased() == dataString[0].lowercased() && dataTestStrings.last?.lowercased() == dataString.last?.lowercased() {
                                if (data["status"] as? String ?? "").contains(dataTestStrings[1]) {
                                    muArr.append(data)
                                }
                            }
                        } else {
                            if (data["status"] as? String ?? "") == (self.statusArr[i]){
                                muArr.append(data)
                            }
                        }
                    }
                    muArr = DataUtils.shared.getSortedByDateData(inputArr: muArr) as! [[String : String]]
                    
                    var fuArr = [[String : Any]]()
                    fuArr = muArr.filter({ (text) -> Bool in
                        DataUtils.shared.getFilterResult(data: text, text: searchText)
                    })
                    self.FullDataSource.append(muArr)
                    if self.vcoolFilter.checkEmptyText() {
                        self.FullFiltered.append(muArr)
                    } else {
                        self.FullFiltered.append(fuArr)
                    }
                }
                for i in 0...(tabArr.count - 1) {
                    var temp = [Bool]()
                    var temph = [CGFloat]()
                    var tempBtn = [[Button]]()
                    for _ in self.FullDataSource[i] {
                        temp.append(false)
                        temph.append(0)
                        tempBtn.append([Button]())
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
            self.notiRowSelect = self.FullDataSource[selectedTap].firstIndex(where: {$0["purchase_no"] as? String ?? "" == self.purchaseIDNoti}) ?? 0
            if self.FullDataSource[selectedTap].count > 0 {
                self.mainTableView.selectRow(at: IndexPath(row: self.notiRowSelect, section: 0), animated: true, scrollPosition: .middle)
                (self.mainTableView.cellForRow(at: IndexPath(row: self.notiRowSelect, section: 0)) as! ListCell).doSelect()
                //self.tableView(self.mainTableView, didSelectRowAt: IndexPath(row: self.notiRowSelect, section: 0))
            }
            self.openFromNoti = false
        }
    }
    func loadDropdownList() {
        if APIManager.shareInstance.connectedToNetwork() {
            self.dropdownProgressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.dropdownProgressHUD.detailsLabel.text = "loading dropdown list"
            vcoolFilter.clearPickerData()
            let batch = DispatchGroup()
            batch.enter()
            APIManager.shareInstance.getDropdownList(key: "VENDOR", system: "CPAI", type: "FEED") { (success, err, dataDict) in
                if success {
                    if dataDict[System.Dropdown] as? [[String: Any]] != nil{
                        let data: [[String: Any]] = dataDict[System.Dropdown] as! [[String: Any]]
                        if data.count > 0 {
                            let t = PickerObject()
                            t.setVal(data: ["text": "All", "value": ""])
                            self.vcoolFilter.supplierValue.append(t)
                        }
                        for source in data {
                            let tmp = PickerObject()
                            tmp.setVal(data: source)
                            self.vcoolFilter.supplierValue.append(tmp)
                        }
                    }
                }
                batch.leave()
            }
            batch.enter()
            APIManager.shareInstance.getDropdownList(key: "ORIGIN", system: "CPAI", type: "") { (success, err, dataDict) in
                if success {
                    if dataDict[System.Dropdown] as? [[String: Any]] != nil{
                        let data: [[String: Any]] = dataDict[System.Dropdown] as! [[String: Any]]
                        if data.count > 0 {
                            let t = PickerObject()
                            t.setVal(data: ["text": "All", "value": ""])
                            self.vcoolFilter.CountryValue.append(t)
                        }
                        for source in data {
                            let tmp = PickerObject()
                            tmp.setVal(data: source)
                            self.vcoolFilter.CountryValue.append(tmp)
                        }
                    }
                }
                batch.leave()
            }
            batch.enter()
            APIManager.shareInstance.getDropdownList(key: "COOL_MATERIALS", system: "CPAI", type: "") { (success, err, dataDict) in
                if success {
                    if dataDict[System.Dropdown] as? [[String: Any]] != nil{
                        let data: [[String: Any]] = dataDict[System.Dropdown] as! [[String: Any]]
                        if data.count > 0 {
                            let t = PickerObject()
                            t.setVal(data: ["text": "All", "value": ""])
                            self.vcoolFilter.CrudeValue.append(t)
                        }
                        
                        for source in data {
                            let tmp = PickerObject()
                            tmp.setVal(data: source)
                            self.vcoolFilter.CrudeValue.append(tmp)
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

extension VCoolViewController {
    func initTabArray(){
        tabArr.removeAll()
        statusArr.removeAll()
        self.CellHeight.removeAll()
        setStatusArr(systemType: System.VCool)
        
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
extension VCoolViewController  {  //Filter View
    
    func initvcoolFilter() {
        self.FilterConstraint.constant = vcoolFilter.l
        vcoolFilter.SearchActive = false
        vcoolFilter.setupView()
        vcoolFilter.filterDelegte = self
    }
}

extension VCoolViewController: FilterViewDelegate {
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
         if self.vcoolFilter.SearchActive{
             self.FilterConstraint.constant = self.vcoolFilter.h
         } else {
             self.FilterConstraint.constant = self.vcoolFilter.l
         }
         UIView.animate(withDuration: 0.5) {
             self.view.layoutIfNeeded()
         }
    }
    
    func onBtnSearch() {
        self.vcoolFilter.searchBar.text = ""
        self.doSearch(System: System.VCool,
                      statusArr: self.statusArr,
                      Date1: vcoolFilter.txtFromDate.text!,
                      Date2: vcoolFilter.txtToDate.text!,
                      txtSupplier: vcoolFilter.getSupplier(),
                      txtCountry: vcoolFilter.getCountry(),
                      txtCrude: vcoolFilter.getCrudeName())
    }
    
    func doSearch(System: String, statusArr: [String], Date1: String, Date2: String, txtSupplier: String,txtCountry: String, txtCrude: String) {
        
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
        let supplier = txtSupplier
        let country = txtCountry
        let crude = txtCrude
        if fromDate != "" && toDate != "" {
            let startDate = dateFormatter.date(from: fromDate)!
            let endDate = dateFormatter.date(from: toDate)!
            if startDate <= endDate {
                self.loadData(system: System, statusArr: statusArr, from_date: dateFormatter.string(from: startDate), to_date: dateFormatter.string(from: endDate), dis_from: "", dis_to: "", crude: crude, country: country, supplier: supplier)
                
            } else {
                MyUtilities.showErrorAlert(message: "Start date must be less than end date", viewController: self)
            }
        } else {
            self.loadData(system: System, statusArr: statusArr, from_date: "", to_date: "", dis_from: "", dis_to: "", crude: crude, country: country, supplier: supplier)
        }
    }
}

extension VCoolViewController:  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
        if vcoolFilter.SearchActive {
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

extension VCoolViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.vcoolFilter.SearchActive {
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
        if self.vcoolFilter.SearchActive {
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

extension VCoolViewController: ListCellDelegate {
    func onBtnMore(_ Sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailView") as! DetailViewController
        var data = [[String: Any]]()
        if self.vcoolFilter.SearchActive {
            data = self.FullFiltered[selectedTap]
        } else {
            data = self.FullDataSource[selectedTap]
        }
        vc.DataDict = data[Sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
