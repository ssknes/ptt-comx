//
//  newBunkerViewController.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/28/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//
import Foundation
import UIKit
import MBProgressHUD
import AEXML

class newBunkerViewController: BaseListViewController { // UIViewController {
    
    @IBOutlet var bunkerFilter: BunkerFilterView!
    @IBOutlet var mainCollectionViewCon: NSLayoutConstraint!
    @IBOutlet var mainTableView: UITableView!
    
    @IBOutlet weak var FilterConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTabArray()
        self.initBunkerFilter()
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
            self.loadData(system: System.Bunker, statusArr: self.statusArr, from_date: "", to_date: "", supplier: "", vessel: "", product: "")
        }
    }
    
    func loadData(system: String, statusArr: [String], from_date: String, to_date: String, supplier: String, vessel: String, product: String) {
        if APIManager.shareInstance.connectedToNetwork() {
            self.progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            self.progressHUD.detailsLabel.text = "Loading Transaction..."
            var index = [String]()
            for i in 0..<20 {
                switch i {
                case 4:
                    index.append(vessel)
                    break
                case 9:
                    index.append(product)
                    break
                case 11:
                    index.append(supplier)
                    break
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
            if (to_date != ""){
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
                    for data in dataDict[System.Bunker] as! [[String : Any]] {
                        if (data["status"] as? String ?? "") == self.statusArr[i]{
                            muArr.append(data)
                        }
                    }
                    muArr = DataUtils.shared.getSortedByDateData(inputArr: muArr)
                    
                    var fuArr = [[String : Any]]()
                    fuArr = muArr.filter({ (text) -> Bool in
                        return DataUtils.shared.getFilterResult(data: text, text: self.searchText)
                    })
                    self.FullDataSource.append(muArr)
                    if self.bunkerFilter.checkEmptyText() {
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
            bunkerFilter.clearPickerData()
            let batch = DispatchGroup()
            batch.enter()
            APIManager.shareInstance.getDropdownList(key: "VENDOR", system: "CPAI", type: "BUNSUPMT|BUNSUPCS") { (success, err, dataDict) in
                if success {
                    if dataDict[System.Dropdown] as? [[String: String]] != nil{
                        let data: [[String: String]] = dataDict[System.Dropdown] as! [[String: String]]
                        if data.count > 0 {
                            let t = PickerObject()
                            t.setVal(data: ["text": "All", "value": ""])
                            self.bunkerFilter.supplierValue.append(t)
                        }
                        for source in data {
                            let tmp = PickerObject()
                            tmp.setVal(data: source)
                            self.bunkerFilter.supplierValue.append(tmp)
                        }
                    }
                }
                batch.leave()
            }
            batch.enter()
            APIManager.shareInstance.getDropdownList(key: "VEHICLE", system: "CPAI", type: "CRUDE|PRODUCT") { (success, err, dataDict) in
                if success {
                    if dataDict[System.Dropdown] as? [[String: String]] != nil{
                        let data: [[String: String]] = dataDict[System.Dropdown] as! [[String: String]]
                        if data.count > 0 {
                            let t = PickerObject()
                            t.setVal(data: ["text": "All", "value": ""])
                            self.bunkerFilter.vesselValue.append(t)
                        }
                        for source in data {
                            let tmp = PickerObject()
                            tmp.setVal(data: source)
                            self.bunkerFilter.vesselValue.append(tmp)
                        }
                    }
                }
                batch.leave()
            }
            batch.enter()
            APIManager.shareInstance.getDropdownList(key: "PRODUCT_BUNKER", system: "CPAI", type: "") { (success, err, dataDict) in
                if success {
                    if dataDict[System.Dropdown] as? [[String: String]] != nil{
                        let data: [[String: String]] = dataDict[System.Dropdown] as! [[String: String]]
                        if data.count > 0 {
                            let t = PickerObject()
                            t.setVal(data: ["text": "All", "value": ""])
                            self.bunkerFilter.productValue.append(t)
                        }
                        for source in data {
                            let tmp = PickerObject()
                            tmp.setVal(data: source)
                            self.bunkerFilter.productValue.append(tmp)
                        }
                    }
                }
            }
            batch.leave()
            batch.notify(queue: .main) {
                self.dropdownProgressHUD.hide(animated: true)
            }

        } else {
            self.dropdownProgressHUD.hide(animated: true)
            MyUtilities.showAckwithAction(title: "Sorry", message: "No Internet Connection", viewController: self, okAction: nil)
        }
    }
}

extension newBunkerViewController {
    func initTabArray(){
        tabArr.removeAll()
        statusArr.removeAll()
        self.CellHeight.removeAll()
        setStatusArr(systemType: System.Bunker)
        
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

extension newBunkerViewController {  //Filter View

    func initBunkerFilter() {
        self.FilterConstraint.constant = bunkerFilter.l
        bunkerFilter.SearchActive = false
        bunkerFilter.setupView()
        bunkerFilter.filterDelegte = self
    }
}

extension newBunkerViewController: FilterViewDelegate {
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
        if self.bunkerFilter.SearchActive{
            self.FilterConstraint.constant = self.bunkerFilter.h
        } else {
            self.FilterConstraint.constant = self.bunkerFilter.l
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func onBtnSearch() {
        self.bunkerFilter.searchBar.text = ""
        self.doSearch(System: System.Bunker,
                      statusArr: self.statusArr,
                      Date1: bunkerFilter.txtFromDate.text!,
                      Date2: bunkerFilter.txtToDate.text!,
                      txtSupplier: bunkerFilter.getSupplier(),
                      txtVessel: bunkerFilter.getVessel(),
                      txtProduct: bunkerFilter.getProduct())
    }
    
    func doSearch(System: String, statusArr: [String], Date1: String, Date2: String, txtSupplier: String, txtVessel: String, txtProduct: String) {
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
        let vessel = txtVessel
        if fromDate != "" && toDate != "" {
            let startDate = dateFormatter.date(from: fromDate)!
            let endDate = dateFormatter.date(from: toDate)!
            if startDate <= endDate {
                self.loadData(system: System, statusArr: statusArr, from_date: fromDate, to_date: toDate, supplier: supplier, vessel: vessel, product: txtProduct)
            } else {
                MyUtilities.showErrorAlert(message: "Start date must be less than end date", viewController: self)
            }
        } else {
            self.loadData(system: System, statusArr: statusArr, from_date: "", to_date: "", supplier: supplier, vessel: vessel, product: txtProduct)
        }
    }
}

extension newBunkerViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
        if bunkerFilter.SearchActive {
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
        if collectionView == mainCollectionView {
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

extension newBunkerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.bunkerFilter.SearchActive {
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
        if self.bunkerFilter.SearchActive {
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

extension newBunkerViewController: ListCellDelegate {
    func onBtnMore(_ Sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "detailView") as! DetailViewController
        var data = [[String: Any]]()
        if self.bunkerFilter.SearchActive {
            data = self.FullFiltered[selectedTap]
        } else {
            data = self.FullDataSource[selectedTap]
        }
        vc.DataDict = data[Sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
