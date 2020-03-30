//
//  NewPafCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 5/9/2561 BE.
//  Copyright © 2561 PTT ICT Solutions. All rights reserved.

import Foundation
import UIKit

class NewPafCell: BaseDataCell {
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSystem: UILabel!
    @IBOutlet weak var conTableView: NSLayoutConstraint!
    @IBOutlet weak var btnCollection: UICollectionView!
    @IBOutlet weak var vwLine : UIView!
    
    private var awardHeader = [String]()
    private var awardData = [[String]]()
    private var awardHeight = [CGFloat]()
    private var serviceType: String = ""
    private var keyCell : Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        mainTableView.register(UINib.init(nibName: "ListDataCell", bundle: nil), forCellReuseIdentifier: "cell")
        mainTableView.register(UINib.init(nibName: "ListDataCell2", bundle: nil), forCellReuseIdentifier: "cell2")
        mainTableView.register(UINib.init(nibName: "PafSlideCell", bundle: nil), forCellReuseIdentifier: "slidecell")
        btnCollection.register(UINib.init(nibName: "CrudeButtonCell", bundle: nil), forCellWithReuseIdentifier: "btncell")
    }
    
    func setCell(Type: String, Data: [String: Any]) -> CGFloat {
        log.info("dataaa ======>>>> \(Data)")
        addDashLine(layer: vwLine.layer)
        serviceType = Type
        type = Data["doc_type"] as? String ?? ""
        transaction_id = Data["doc_trans_id"] as? String ?? ""
        req_txn_id = Data["doc_req_id"] as? String ?? ""
        system = Data["system"] as? String ?? ""
        lblDate.text = Data["doc_date"] as? String ?? ""
        lblSystem.text = Data["system_type"] as? String ?? ""
        value.removeAll()
        header.removeAll()
        
        let tmpArrAdvanceLoading = Data["advance_loading_request_data"] as? [[String: Any]] ?? []
        let tmpArrContractData = Data["contract_data"] as? [[String: Any]] ?? []
        
        if  tmpArrAdvanceLoading.count > 0 {
            for item in tmpArrAdvanceLoading where item["alr_status"] as? String != "APPROVED" {
                keyCell = 4
                appendValue(hd: "Reference No. :", val: item["alr_row_no"] as? String ?? "-", noValueHide: false)
                appendValue(hd: "Advance For :", val: Data["doc_no"] as? String ?? "-", noValueHide: false)
                appendValue(hd: "Status :", val: "WAITING ADVANCE LOADING", noValueHide: false)
                     
                appendValue(hd: "Transaction For :", val: Data["doc_for"] as? String ?? "", noValueHide: false)
                appendValue(hd: "blank", val: "", noValueHide: false)
                appendValue(hd: "Advance Loading Request Reason :", val: item["alr_request_reason"] as? String ?? "", noValueHide: false)
                appendValue(hd: "Brief :", val: self.getBriefText(def: Data["brief"] as? String ?? "-") , noValueHide: false)
                appendValue(hd: "Requested By :", val: Data["created_by"] as? String ?? "", noValueHide: false)
            }
            for item in tmpArrAdvanceLoading where item["alr_status"] as? String == "APPROVED" {
                keyCell = 5
                for item in tmpArrContractData{
                   appendValue(hd: "Reference No. :", val: item["caf_contract_no"] as? String ?? "-", noValueHide: false)
                   appendValue(hd: "contact For :", val: Data["doc_no"] as? String ?? "", noValueHide: false)
                   appendValue(hd: "Status :", val: "WAITING FINAL CONTRACT", noValueHide: false)
                   appendValue(hd: "Transaction For :", val: Data["doc_for"] as? String ?? "", noValueHide: false)
                   appendValue(hd: "Customer :", val: item["caf_customer"] as? String ?? "", noValueHide: false)
                    
                   appendValue(hd: "blank", val: "", noValueHide: false)
                  
                   appendValue(hd: "Final Contract Documents :", val: item["caf_final_documents"] as? String ?? "-", noValueHide: false)
                   appendValue(hd: "Brief :", val: self.getBriefText(def: Data["brief"] as? String ?? "-") , noValueHide: false)
                   appendValue(hd: "Requested By :", val: Data["created_by"] as? String ?? "", noValueHide: false)
                }
                
            }
            
        }else {
              keyCell = 3
              appendValue(hd: "Reference No. :", val: Data["doc_no"] as? String ?? "-", noValueHide: false)
              appendValue(hd: "Status :", val: Data["doc_status"] as? String ?? "", noValueHide: false)
                   
              appendValue(hd: "Transaction For :", val: Data["doc_for"] as? String ?? "", noValueHide: false)
              appendValue(hd: "blank", val: "", noValueHide: false)
              appendValue(hd: "Brief :", val: self.getBriefText(def: Data["brief"] as? String ?? "-") , noValueHide: false)
              appendValue(hd: "Requested By :", val: Data["created_by"] as? String ?? "", noValueHide: false)
        }


        makeCellHeight()
        let awardData = Data["awaeded"] as? [[String: Any]] ?? []
        conTableView.constant = processAwardData(Datas: awardData)
        mainTableView.reloadData()
        return conTableView.constant + GlobalVar.sharedInstance.detailViewGap
    }
    
    private func processAwardData(Datas: [[String: Any]]) -> CGFloat {
        let headers = getAwardHeader(Datas: Datas)
        let datas = getAwardDatas(Datas: Datas)
        var checkers = [Bool]()
        for i in 0...(headers.count - 1) {
            var checker = false
            for item in datas where item[i] != "-" && item[i] != "" {
                checker = true
            }
            checkers.append(checker)
        }
        awardHeader = screenArrHeader(Data: headers, Checker: checkers)
        awardData = screenArrData(Data: datas, Checker: checkers)
        awardHeight = getAwardArrHeight()
        cellHeight[keyCell] = getAwardDataHeight()

        return getTableHeight()
    }
    
    private func screenArrData(Data: [[String]], Checker: [Bool]) -> [[String]] {
        if Data.count == 0 {
            return []
        }
        var temp = [[String]]()
        for i in 0...(Data.count - 1) {
            temp.append(screenArrHeader(Data: Data[i], Checker: Checker))
        }
        return temp
    }

    private func screenArrHeader(Data: [String], Checker: [Bool]) -> [String] {
        if Data.count == 0 || Data.count != Checker.count {
            return []
        }
        var temp = [String]()
        for i in 0...(Data.count - 1) where Checker[i] {
            temp.append(Data[i])
        }
        return temp
    }
    
    private func appendValue(hd: String, val: String, noValueHide: Bool) {
        if noValueHide && (val.trim() == "" || val.trim() == "-"){
            return
        }
        value.append(val)
        header.append(hd)
    }
    
    private func makeCellHeight() {
        cellHeight.removeAll()
        for i in 0...header.count - 1 {
            if value.count > i {
                cellHeight.append(calcHeight(lblHead: header[i], lblVal: value[i]))
            } else {
                cellHeight.append(calcHeight(lblHead: header[i], lblVal: "-"))
            }
        }
    }
    
    private func getTableHeight() -> CGFloat {
        var tmp: CGFloat = 0
        for i in 0...cellHeight.count - 1 {
            tmp += cellHeight[i]
        }
        return tmp
    }
    
    private func getAwardDataHeight() -> CGFloat {
        
        var h: CGFloat = 0
        let tmpArr = awardHeight
        for item in tmpArr {
            h += item
        }
        h += 40
        return h
    }
    
    private func getAwardArrHeight() -> [CGFloat] {
        return getComparedArrHeight(Arr1: getArrHeaderHeight(Datas: awardHeader), Arr2: getArrDataHeight(Datas: awardData))
    }
    
    private func getArrDataHeight(Datas: [[String]]) -> [CGFloat] {
        if Datas.count == 0 {
            return []
        }
        var res = [CGFloat]()
        var checker = 0
        for i in 0...(Datas.count - 1) {
            if Datas[i].count > checker {
                checker = i
            }
        }
        for _ in Datas[checker] {
            res.append(0)
        }
        for item in Datas {
            var tmpArr = [CGFloat]()
            for item2 in item {
                tmpArr.append(calcHeight(lblHead: "", lblVal: item2))
            }
            res = getComparedArrHeight(Arr1: res, Arr2: tmpArr)
        }
        return res
    }
    
    private func getComparedArrHeight(Arr1: [CGFloat],Arr2: [CGFloat]) -> [CGFloat] {
        var tmpArr = [CGFloat]()
        if Arr1.count == 0 || Arr2.count == 0 {
            return tmpArr
        }
        if Arr1.count != Arr2.count {
            return tmpArr
        }
        for i in
            0...(Arr1.count - 1) {
            if Arr1[i] < Arr2[i] {
                tmpArr.append(Arr2[i])
            } else {
                tmpArr.append(Arr1[i])
            }
        }
        return tmpArr
    }
    
    private func getArrHeaderHeight(Datas: [String]) -> [CGFloat] {
        var res = [CGFloat]()
        for item in Datas {
            res.append(calcHeight(lblHead: item, lblVal: ""))
        }
        return res
    }
    
    private func getAwardHeader(Datas: [[String: Any]]) -> [String] {
        switch serviceType.lowercased() {
        case "sale_bitumen":
            return ["Customer :", "Product Name :", "Quantity :", "Incoterm :", "Selling Price :", "Argus Price :", "HSFO Price :", "Simplan Price :", "Benefit vs Argus Price :", "Benefit vs HSFO Price :", "Benefit vs Simplan Price :", "Contract Period :", "Loading Period :", "Pricing Period :", "Discharging Period :"]
        case "sale_lpg":
            return ["Customer :","Product Name :","Quantity :","Incoterm :","Selling Price :", "Export Surcharge :", "Net Export Price :", "RFO Firing Price :", "NG Firing Price :", "Benefit vs RFO Firing Price :", "Benefit vs NG Firing Price :", "Contract Period :", "Loading Period :", "Pricing Period :", "Discharging Period :"]
        case "sale":
            return ["Customer :",
                    "Product Name :",
                    "Quantity :",
                    "Incoterm :",
                    "Selling Price :",
                    "Freight :",
                    "Final Price :",
                    "Market Price :",
                    "Latest LP Plan Price :",
                    "Benchmark Price :",
                    "Break Even Price :",
                    "Benefit vs Market Price :",
                    "Benefit vs LP Plan Price :",
                    "Benefit vs Benchmark Price :",
                    "Benefit vs Break Even Price :",
                    "Contract Period :",
                    "Loading Period :",
                    "Pricing Period :",
                    "Discharging Period :"]
        case "sale_updateprice":
            var maxHeader = 0
            for item in Datas {
                if (item["awarded_up_tier"] as! [[String: Any]]).count > maxHeader {
                    maxHeader = (item["awarded_up_tier"] as! [[String: Any]]).count
                }
            }
            var arrHdr1 = ["Customer :", "Product Name :", "Incoterm :"]
            if maxHeader > 0 {
                for i in 0...(maxHeader - 1) {
                    arrHdr1.append("Quantity Tier \(i + 1) :")
                    arrHdr1.append("Price Tier \(i + 1) :")
                }
            }
            arrHdr1 +=  ["Contract Period :", "Loading Period :", "Pricing Period :", "Discharging Period :"]
            return arrHdr1
        case "purchase":
            return ["Supplier :", "Product Name :", "Quantity :", "Incoterm :", "Purchasing Price :", "Freight :", "Final Price :", "Market Price :", "Latest LP Plan Price :", "Benchmark Price :", "Break Even Price :", "Benefit vs Market Price :", "Benefit vs LP Plan Price :", "Benefit vs Benchmark Price :", "Benefit vs Break Even Price :", "Contract Period :", "Loading Period :", "Pricing Period :", "Discharging Period :"]
        default:
            return []
        }
    }
    private func getAwardDatas(Datas: [[String: Any]]) -> [[String]] {
        var arrDatas = [[String]]()
        for item in Datas {
            var arrObjData = [String]()
            switch serviceType.lowercased() {
            case "sale_bitumen":
                arrObjData.append(item["awarded_customer"] as? String ?? "")
                arrObjData.append(item["awarded_product"] as? String ?? "")
                arrObjData.append(item["awarded_quantity"] as? String ?? "")
                arrObjData.append(item["awarded_incoterm"] as? String ?? "")
                arrObjData.append(item["awarded_selling_price"] as? String ?? "")
                arrObjData.append(item["awarded_argus_price"] as? String ?? "")
                arrObjData.append(item["awarded_hsfo_price"] as? String ?? "")
                arrObjData.append(item["awarded_simplan_price"] as? String ?? "")
                arrObjData.append(item["awarded_benefit_argus"] as? String ?? "")
                arrObjData.append(item["awarded_benefit_hsfo"] as? String ?? "")
                arrObjData.append(item["awarded_benefit_simplan"] as? String ?? "")
                arrObjData.append(item["awarded_contract_prd"] as? String ?? "")
                arrObjData.append(item["awarded_loading_prd"] as? String ?? "")
                arrObjData.append(item["awarded_pricing_prd"] as? String ?? "")
                arrObjData.append(item["awarded_discharging_prd"] as? String ?? "")
            case "sale_lpg":
                arrObjData.append(item["awarded_customer"] as? String ?? "")
                arrObjData.append(item["awarded_product"] as? String ?? "")
                arrObjData.append(item["awarded_quantity"] as? String ?? "")
                arrObjData.append(item["awarded_incoterm"] as? String ?? "")
                arrObjData.append(item["awarded_selling_price"] as? String ?? "")
                arrObjData.append(item["awarded_export_surcharge_price"] as? String ?? "")
                arrObjData.append(item["awarded_net_export_price"] as? String ?? "")
                arrObjData.append(item["awarded_rfo_price"] as? String ?? "")
                arrObjData.append(item["awarded_ng_price"] as? String ?? "")
                arrObjData.append(item["awarded_benefit_rfo"] as? String ?? "")
                arrObjData.append(item["awarded_benefit_ng"] as? String ?? "")
                arrObjData.append(item["awarded_contract_prd"] as? String ?? "")
                arrObjData.append(item["awarded_loading_prd"] as? String ?? "")
                arrObjData.append(item["awarded_pricing_prd"] as? String ?? "")
                arrObjData.append(item["awarded_discharging_prd"] as? String ?? "")
            case "sale":
                arrObjData.append(item["awarded_customer"] as? String ?? "")
                arrObjData.append(item["awarded_product"] as? String ?? "")
                arrObjData.append(item["awarded_quantity"] as? String ?? "")
                arrObjData.append(item["awarded_incoterm"] as? String ?? "")
                arrObjData.append(item["awarded_selling_price"] as? String ?? "")
                arrObjData.append(item["awarded_freight"] as? String ?? "")
                arrObjData.append(item["awarded_final_price"] as? String ?? "")
                arrObjData.append(item["awarded_market_price"] as? String ?? "")
                arrObjData.append(item["awarded_lp_price"] as? String ?? "")
                arrObjData.append(item["awarded_benchmark_price"] as? String ?? "")
                arrObjData.append(item["awarded_break_even_price"] as? String ?? "")
                arrObjData.append(item["awarded_benefit_market"] as? String ?? "")
                arrObjData.append(item["awarded_benefit_lp"] as? String ?? "")
                arrObjData.append(item["awarded_benefit_benchmark"] as? String ?? "")
                arrObjData.append(item["awarded_benefit_break_even"] as? String ?? "")
                arrObjData.append(item["awarded_contract_prd"] as? String ?? "")
                arrObjData.append(item["awarded_loading_prd"] as? String ?? "")
                arrObjData.append(item["awarded_pricing_prd"] as? String ?? "")
                arrObjData.append(item["awarded_discharging_prd"] as? String ?? "")
            case "sale_updateprice":
                arrObjData.append(item["awarded_customer"] as? String ?? "")
                arrObjData.append(item["awarded_product"] as? String ?? "")
                arrObjData.append(item["awarded_incoterm"] as? String ?? "")
                //"awarded_up_tier"
                let awardedadd = (getAwardHeader(Datas: Datas).count - 7) / 2
                let tempArr = item["awarded_up_tier"] as? [[String: Any]] ?? []
                if awardedadd > 0 {
                    for i in 0...(awardedadd - 1) {
                        if i >= tempArr.count {
                            arrObjData.append("-")
                            arrObjData.append("-")
                        } else {
                            arrObjData.append(tempArr[i]["awarded_tier_quantity"] as? String ?? "-")
                            arrObjData.append(tempArr[i]["awarded_tier_price"] as? String ?? "- ")
                        }
                    }
                }
                arrObjData.append(item["awarded_contract_prd"] as? String ?? "")
                arrObjData.append(item["awarded_loading_prd"] as? String ?? "")
                arrObjData.append(item["awarded_pricing_prd"] as? String ?? "")
                arrObjData.append(item["awarded_discharging_prd"] as? String ?? "")
            case "purchase":
                arrObjData.append(item["awarded_supplier"] as? String ?? "")
                arrObjData.append(item["awarded_product"] as? String ?? "")
                arrObjData.append(item["awarded_quantity"] as? String ?? "")
                arrObjData.append(item["awarded_incoterm"] as? String ?? "")
                arrObjData.append(item["awarded_purchasing_price"] as? String ?? "")
                arrObjData.append(item["awarded_freight"] as? String ?? "")
                arrObjData.append(item["awarded_final_price"] as? String ?? "")
                arrObjData.append(item["awarded_market_price"] as? String ?? "")
                arrObjData.append(item["awarded_lp_price"] as? String ?? "")
                arrObjData.append(item["awarded_benchmark_price"] as? String ?? "")
                arrObjData.append(item["awarded_break_even_price"] as? String ?? "")
                arrObjData.append(item["awarded_benefit_market"] as? String ?? "")
                arrObjData.append(item["awarded_benefit_lp"] as? String ?? "")
                arrObjData.append(item["awarded_benefit_benchmark"] as? String ?? "")
                arrObjData.append(item["awarded_benefit_break_even"] as? String ?? "")
                arrObjData.append(item["awarded_contract_prd"] as? String ?? "")
                arrObjData.append(item["awarded_loading_prd"] as? String ?? "")
                arrObjData.append(item["awarded_pricing_prd"] as? String ?? "")
                arrObjData.append(item["awarded_discharging_prd"] as? String ?? "")
            default:
                break
            }
            arrDatas.append(arrObjData)
        }
        return arrDatas
    }
}

extension NewPafCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if header.count != value.count {
            return 0
        }
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == keyCell { // Table Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "slidecell") as! PafSlideCell
            cell.setCell(Type: serviceType, Headers: awardHeader, Datas: awardData, CellHeight: awardHeight)
            return cell
        }
        if header[indexPath.row].lowercased().contains("brief") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! ListDataCell2
            cell.delegate = self
            cell.btnEdit.isHidden = false
            cell.setupView(header: header[indexPath.row], value: value[indexPath.row], bold: false, arrButton: btnData)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListDataCell
        cell.delegate = self
        cell.btnEdit.isHidden = true
        if indexPath.row == 0 {
            cell.setupView(header: header[indexPath.row], value: value[indexPath.row], bold: true)
        } else {
            cell.setupView(header: header[indexPath.row], value: value[indexPath.row], bold: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight[indexPath.row]
    }
}
 
 
 
/*
class NewPafCell: BaseDataCell  {
    @IBOutlet weak var btnCollection: UICollectionView!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    
    @IBOutlet weak var cellScrollView: UIScrollView!
    @IBOutlet weak var lblFormID: UILabel!
    @IBOutlet weak var lblBitumenGrade: UILabel!
    @IBOutlet weak var lblRequestedBy: UILabel!
    
    var listData = [[String: Any]]()
    
    @IBOutlet weak var lblBitumenCounter: UILabel!
    @IBOutlet weak var cellHeaderTableView: UITableView!
    @IBOutlet weak var conHeaderTableView: NSLayoutConstraint!
    
    var txtHeader = [String]()
    var maxHeader = 0
    var txtValue = [[String]]()
    var cellHeight = [CGFloat]()
    var itemWidth: Int = 160
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        cellHeaderTableView.separatorStyle = .none
        cellHeaderTableView.bounces = false
        cellScrollView.isPagingEnabled = true
        btnCollection.register(UINib.init(nibName: "CrudeButtonCell", bundle: nil), forCellWithReuseIdentifier: "btncell")
        cellHeaderTableView.register(UINib.init(nibName: "NewPafHeaderCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func setCell(Type: String, Data: [String: Any]) -> CGFloat {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        dateFormatter.dateFormat = "MM"
        let dateFormatter2: DateFormatter = DateFormatter()
        dateFormatter2.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        dateFormatter2.dateFormat = "MMM"
        
        let date =  Data["doc_date"] as? String
        let dateArray = date?.split(separator: "/")
        self.lblDate.attributedText = NSAttributedString(string: dateArray![0], attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        self.lblMonth.text = dateFormatter2.string(from: dateFormatter.date(from: dateArray![1])!)
        
        let Header = getCellHeader(Type: Data["doc_type"] as? String ?? "")
        let Key = getCellHeaderKey(Type: Data["doc_type"] as? String ?? "")
        
        itemWidth = Int(floor(UIScreen.main.bounds.size.width - 185))
        for item in cellScrollView.subviews {
            item.removeFromSuperview()
        }
        cellScrollView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 0, height: 0), animated: false)
        
        type = (Data["doc_type"] as? String)!
        transaction_id = (Data["doc_trans_id"] as? String)!
        req_txn_id = (Data["doc_req_id"] as? String)!
        
        lblFormID.text = Data["doc_no"] as? String
        lblRequestedBy.text = Data["created_by"] as? String
        lblBitumenGrade.text =  Data["doc_for"] as? String
        conHeaderTableView.constant = 0
        
        if let arrTemp = Data["awaeded"] as? [[String: Any]] {
            var tmpHeader = Header
            listData = arrTemp
            if Type.lowercased() != "sale_updateprice" {
                if listData.count > 0 {
                    for i in 0...(Key.count - 1) {
                        if Key[i] != "awarded_contract_prd" && Key[i] != "awarded_loading_prd" && Key[i] != "awarded_pricing_prd" && Key[i] != "awarded_discharging_prd" {
                            if listData[0][Key[i]] as! String == "-" {
                                tmpHeader[i] = ""
                            }
                        }
                    }
                }
            }
            
            
            if listData.count > 0 {
                lblBitumenCounter.text = "\(1) / \(listData.count)"
            } else {
                lblBitumenCounter.text = "\(0) / \(listData.count)"
            }
            cellScrollView.contentSize = CGSize.init(width: itemWidth * listData.count, height: 0)
            
            //SubViewData
            txtHeader.removeAll()
            txtValue.removeAll()
            
            //init Max Data
            maxHeader = 0
            if Type.lowercased() == "sale_updateprice" {
                for item in listData {
                    if (item["awarded_up_tier"] as! [[String: Any]]).count > maxHeader {
                        maxHeader = (item["awarded_up_tier"] as! [[String: Any]]).count
                    }
                }
            }
            //init Height
            var heightCounter = Header.count
            if Type.lowercased() == "sale_updateprice" {
                heightCounter = Header.count - 1
                if maxHeader > 0 {
                    heightCounter = heightCounter + (maxHeader * 2)
                }
            }
            
            //init Header
            for i in 0...Header.count - 1 {
                if Type.lowercased() == "sale_updateprice" {
                    if tmpHeader[i] == "awarded_up_tier" {
                        if maxHeader > 0 {
                            for j in 0...(maxHeader - 1) {
                                txtHeader.append("Quantity Tier \(j + 1) :")
                                txtHeader.append("Price Tier \(j + 1) :")
                            }
                        }
                    } else {
                        txtHeader.append(tmpHeader[i])
                    }
                } else {
                    txtHeader.append(tmpHeader[i])
                }
            }
            
            //Default Header Height
            cellHeight.removeAll()
            for i in 0...(heightCounter - 1) {
                if  txtHeader[i] == "" {
                    cellHeight.append(0)
                } else {
                    cellHeight.append(36)
                }
            }
            //Adjust Height after add Header Name
            for i in 0...(txtHeader.count - 1) {
                //cellHeight[i] = Test(cellHeight[i], heightForViewWithString(txtHeader[i], UIFont.systemFont(ofSize: 15), 110) + 4)
                if txtHeader[i] != "" {
                    cellHeight[i] = Test(cellHeight[i], heightForViewWithString(txtHeader[i], 110, 0) + 4)
                }
            }
            
            //Create Data
            if listData.count > 0 {
                txtValue.removeAll()
                for i1 in 0...(listData.count - 1) {
                    //List Data Object
                    var tmpData = [String]()
                    if Key.count > 0 {
                        for i2 in 0...(Key.count - 1) {
                            if Key[i2] == "awarded_up_tier" {
                                for i3 in 0...(maxHeader - 1) {
                                    if i3 < (listData[i1][Key[i2]] as! [[String: Any]]).count {
                                        let tmp = listData[i1][Key[i2]] as! [[String: Any]]
                                        tmpData.append(tmp[i3]["awarded_tier_quantity"] as! String)
                                        tmpData.append(tmp[i3]["awarded_tier_price"] as! String)
                                    
                                    } else {
                                        tmpData.append("")
                                        tmpData.append("")
                                    }
                                }
                            } else {
                                if Type.lowercased() != "sale_updateprice" {
                                    if Key[i2] == "awarded_contract_prd" || Key[i2] == "awarded_loading_prd" || Key[i2] == "awarded_pricing_prd" || Key[i2] == "awarded_discharging_prd" {
                                        tmpData.append(listData[i1][Key[i2]] as! String)
                                        
                                    } else if listData[i1][Key[i2]] as! String == "-" {
                                        tmpData.append("")
                                    } else {
                                        tmpData.append(listData[i1][Key[i2]] as! String)
                                    }
                                } else {
                                    tmpData.append(listData[i1][Key[i2]] as! String)
                                }
                            }
                        }
                    }
                    txtValue.append(tmpData)
                }
            }
            //Add Scroll Subview
            var tempArrView = [NewPafDataView]()
            if txtValue.count > 0 {
                for i1 in 0...txtValue.count - 1 {
                    let tempView = NewPafDataView()
                    let tempViewHeight = tempView.setView(Type: Type, Data: txtValue[i1], Height: cellHeight, Width: CGFloat(itemWidth))
                    cellHeight = compareHeight(cellHeight, tempViewHeight)
                    tempArrView.append(tempView)
                }
            }
            //Apply Height for all view
            for item in tempArrView {
                item.setHeight(Height: cellHeight)
            }
            
            //get all View Height
            var tempHeight: CGFloat = 0
            for item in cellHeight {
                tempHeight += item
            }
            conHeaderTableView.constant = tempHeight
            
            //Add to Scroll
            if tempArrView.count > 0 {
                for i in 0...(tempArrView.count - 1) {
                    tempArrView[i].frame = CGRect.init(x: i * itemWidth, y: 0, width: itemWidth, height: Int(conHeaderTableView.constant))
                    self.cellScrollView.addSubview(tempArrView[i])
                }
            }
        }
        cellHeaderTableView.reloadData()
        
        self.imgArrow.image = UIImage.init(named: "Rectangle02")
        self.backgroundColor = UIColor(red: 237.0/255.0, green: 238.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        
        return 302 + conHeaderTableView.constant
    }
    
    private func compareHeight(_ Data1: [CGFloat], _ Data2: [CGFloat]) -> [CGFloat]{
        var temp = [CGFloat]()
        for i in 0...(Data1.count - 1) {
            if Data1[i] > Data2[i] {
                temp.append(Data1[i])
            } else {
                temp.append(Data2[i])
            }
        }
        return temp
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let temp: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width) + 1
        lblBitumenCounter.text = "\(temp) / \(listData.count)"
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let temp: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width) + 1
        lblBitumenCounter.text = "\(temp) / \(listData.count)"
    }
    @IBAction func onBtnScrollLeft(_ Sender: AnyObject) {
        let temp: Int = Int(cellScrollView.contentOffset.x / cellScrollView.frame.size.width)
        if temp > 0 {
            let temp2 = CGFloat(temp - 1) * cellScrollView.frame.size.width
            cellScrollView.setContentOffset(CGPoint.init(x: temp2, y: 0), animated: true)
        }
    }
    @IBAction func onBtnScrollRight(_ Sender: AnyObject) {
        let temp: Int = Int(cellScrollView.contentOffset.x / cellScrollView.frame.size.width)
        if temp < listData.count - 1 {
            let temp2 = CGFloat(temp + 1) * cellScrollView.frame.size.width
            cellScrollView.setContentOffset(CGPoint.init(x: temp2, y: 0), animated: true)
        }
    }
}

extension NewPafCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return txtHeader.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NewPafHeaderCell
        cell.backgroundView?.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.lblTitle.text = txtHeader[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight[indexPath.row]
    }
    
    private func getCellHeader(Type: String) -> [String] {
        switch Type.lowercased() {
        case "sale_bitumen":
            return ["Customer :", "Product Name :", "Quantity :", "Incoterm :", "Selling Price :", "Argus Price :", "HSFO Price :", "Simplan Price :", "Benefit vs Argus Price :", "Benefit vs HSFO Price :", "Benefit vs Simplan Price :", "Contract Period :", "Loading Period :", "Pricing Period :", "Discharging Period :"]
        case "sale_lpg":
            return ["Customer :",
                    "Product Name :",
                    "Quantity :",
                    "Incoterm :",
                    "Selling Price :",
                    "Export Surcharge :",
                    "Net Export Price :",
                    "RFO Firing Price :",
                    "NG Firing Price :",
                    "Benefit vs RFO Firing Price :",
                    "Benefit vs NG Firing Price :",
                    "Contract Period :",
                    "Loading Period :",
                    "Pricing Period :",
                    "Discharging Period :"]
        case "sale":
            return ["Customer :",
                    "Product Name :",
                    "Quantity :",
                    "Incoterm :",
                    "Selling Price :",
                    "Freight :",
                    "Final Price :",
                    "Market Price :",
                    "Latest LP Plan Price :",
                    "Benchmark Price :",
                    "Break Even Price :",
                    "Benefit vs Market Price :",
                    "Benefit vs LP Plan Price :",
                    "Benefit vs Benchmark Price :",
                    "Benefit vs Break Even Price :",
                    "Contract Period :",
                    "Loading Period :",
                    "Pricing Period :",
                    "Discharging Period :"]
        case "sale_updateprice":
            return ["Customer :", "Product Name :", "Incoterm :", "awarded_up_tier", "Contract Period :", "Loading Period :", "Pricing Period :", "Discharging Period :"]
        case "purchase":
            return ["Supplier :",
                    "Product Name :",
                    "Quantity :",
                    "Incoterm :",
                    "Purchasing Price :",
                    "Freight :",
                    "Final Price :",
                    "Market Price :",
                    "Latest LP Plan Price :",
                    "Benchmark Price :",
                    "Break Even Price :",
                    "Benefit vs Market Price :",
                    "Benefit vs LP Plan Price :",
                    "Benefit vs Benchmark Price :",
                    "Benefit vs Break Even Price :",
                    "Contract Period :",
                    "Loading Period :",
                    "Pricing Period :",
                    "Discharging Period :"]
        default:
            return []
        }
    }
    
    private func getCellHeaderKey(Type: String) -> [String] {
        switch Type.lowercased() {
        case "sale_bitumen":
            return ["awarded_customer", "awarded_product", "awarded_quantity", "awarded_incoterm", "awarded_selling_price", "awarded_argus_price", "awarded_hsfo_price", "awarded_simplan_price", "awarded_benefit_argus", "awarded_benefit_hsfo", "awarded_benefit_simplan", "awarded_contract_prd", "awarded_loading_prd", "awarded_pricing_prd", "awarded_discharging_prd"]
        case "sale_lpg":
            return ["awarded_customer",
                    "awarded_product",
                    "awarded_quantity",
                    "awarded_incoterm",
                    "awarded_selling_price",
                    "awarded_export_surcharge_price",
                    "awarded_net_export_price",
                    "awarded_rfo_price",
                    "awarded_ng_price",
                    "awarded_benefit_rfo",
                    "awarded_benefit_ng",
                    "awarded_contract_prd",
                    "awarded_loading_prd",
                    "awarded_pricing_prd",
                    "awarded_discharging_prd"]
        case "sale":
            return ["awarded_customer",
                    "awarded_product",
                    "awarded_quantity",
                    "awarded_incoterm",
                    "awarded_selling_price",
                    "awarded_freight",
                    "awarded_final_price",
                    "awarded_market_price",
                    "awarded_lp_price",
                    "awarded_benchmark_price",
                    "awarded_break_even_price",
                    "awarded_benefit_market",
                    "awarded_benefit_lp",
                    "awarded_benefit_benchmark",
                    "awarded_benefit_break_even",
                    "awarded_contract_prd",
                    "awarded_loading_prd",
                    "awarded_pricing_prd",
                    "awarded_discharging_prd"]
        case "sale_updateprice":
            return ["awarded_customer", "awarded_product","awarded_incoterm", "awarded_up_tier", "awarded_contract_prd", "awarded_loading_prd", "awarded_pricing_prd", "awarded_discharging_prd"]
        case "purchase":
            return ["awarded_supplier",
                    "awarded_product",
                    "awarded_quantity",
                    "awarded_incoterm",
                    "awarded_purchasing_price",
                    "awarded_freight",
                    "awarded_final_price",
                    "awarded_market_price",
                    "awarded_lp_price",
                    "awarded_benchmark_price",
                    "awarded_break_even_price",
                    "awarded_benefit_market",
                    "awarded_benefit_lp",
                    "awarded_benefit_benchmark",
                    "awarded_benefit_break_even",
                    "awarded_contract_prd",
                    "awarded_loading_prd",
                    "awarded_pricing_prd",
                    "awarded_discharging_prd"]
        default:
            return []
        }
    }
}
*/

