//
//  CrudeSaleReoptCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/7/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class CrudeSaleReoptCell: BaseDataCell {
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSystem: UILabel!
    @IBOutlet weak var conTableView: NSLayoutConstraint!
    @IBOutlet weak var btnCollection: UICollectionView!
    @IBOutlet weak var vwLine : UIView!
    
//    private var posAwarded: Int = 9
//    private var posReopt: Int = 10
    
    //advance
    private var posAwarded: Int = 10
    private var posReopt: Int = 11
    
    
    //final
//    private var posAwarded: Int = 9
//       private var posReopt: Int = 10
    
    private let awardedHeader = ["", "Crude name :", "Customer :", "Quantity :", "Incoterm :", "Price :", "Market price :", "Pricing month :", "Benefit vs purchased price :", "Contract period :", "Loading period :", "Discharging period :"]
    private var arrAwardedData = [[String]]()
    private var arrAwardedHeight = [CGFloat]()
    
    private let reoptHeader = ["", "Crude name :", "Supplier :", "Quantity :", "Incoterm :", "Price :", "Market price :", "LP max price :", "Benefit vs LP max pice :", "Loading period :", "Discharging period :"]
    private var arrReoptData = [[String]]()
    private var arrReoptHeight = [CGFloat]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        mainTableView.register(UINib.init(nibName: "ListDataCell", bundle: nil), forCellReuseIdentifier: "cell")
        mainTableView.register(UINib.init(nibName: "ListDataCell2", bundle: nil), forCellReuseIdentifier: "cell2")
        mainTableView.register(UINib.init(nibName: "ListDataHeaderCell", bundle: nil), forCellReuseIdentifier: "cellhead")
        mainTableView.register(UINib.init(nibName: "CrudeOSlideCell", bundle: nil), forCellReuseIdentifier: "slidecell")
        btnCollection.register(UINib.init(nibName: "CrudeButtonCell", bundle: nil), forCellWithReuseIdentifier: "btncell")
    }
    
    func setCell(Data: [String: Any]) -> CGFloat {
        addDashLine(layer: vwLine.layer)
        status = Data["status"] as! String
        type = Data["type"] as? String ?? ""
        transaction_id = Data["transaction_id"] as? String ?? ""
        req_txn_id = Data["req_transaction_id"] as? String ?? ""
        system = Data["system"] as? String ?? ""
        lblDate.text = Data["date_purchase"] as? String ?? ""
        lblSystem.text = Data["system_type"] as? String ?? ""
        
        value.removeAll()
        header.removeAll()
        cellHeight.removeAll()
        
        let tmpArrAdvanceLoading = Data["advance_loading_request_data"] as? [[String: Any]] ?? []
        let tmpArrContractData = Data["contract_data"] as? [[String: Any]] ?? []
        if tmpArrAdvanceLoading.count > 0{
            for item in tmpArrAdvanceLoading {
             appendValue(hd: "Sale&Re-Optimization No. :", val: item["alr_row_no"] as? String ?? "", noValueHide: false)
            }
        }else if tmpArrContractData.count > 0 {
            for item in tmpArrContractData {
             appendValue(hd: "Sale&Re-Optimization No. :", val: item["caf_contract_no"] as? String ?? "", noValueHide: false)
            }
        }else {
           appendValue(hd: "Sale&Re-Optimization No. :", val: Data["doc_no"] as? String ?? "", noValueHide: false)
        }
        if tmpArrAdvanceLoading.count > 0 {
            for item in tmpArrAdvanceLoading {
                appendValue(hd: "Advance For :", val: Data["purchase_no"] as? String ?? "-", noValueHide: false)
             if(item["alr_status"] as? String == "WAITING APPROVE"){
                appendValue(hd: "Status :", val: "WAITING ADVANCE LOADING", noValueHide: false)
            }else{
                appendValue(hd: "Status :", val: item["alr_status"] as? String ?? "", noValueHide: false)
            }
          }
        }else if tmpArrContractData.count > 0 {
            for item in tmpArrContractData {
                appendValue(hd: "Contact For :", val: Data["purchase_no"] as? String ?? "", noValueHide: false)
               if(item["caf_status"] as? String == "WAITING APPROVE"){
                appendValue(hd: "Status :", val: "WAITING FINAL CONTRACT", noValueHide: false)
               }else {
                appendValue(hd: "Status :", val: item["caf_status"] as? String ?? "", noValueHide: false)
                }
            }
        }else{
            appendValue(hd: "Status :", val: Data["status"] as? String ?? "", noValueHide: false)
        }
        appendValue(hd: "Sale&Re-Optimization No. :", val: Data["doc_no"] as? String ?? "-", noValueHide: false)
        appendValue(hd: "Advance For :", val: Data["doc_no"] as? String ?? "-", noValueHide: false)
        appendValue(hd: "Status :", val: Data["doc_no"] as? String ?? "-", noValueHide: false)
        appendValue(hd: "Purchased from", val: "", noValueHide: false)
        let tmp1 = Data["list_cdph"] as? [[String: Any]] ?? []
        appendValue(hd: "Crude Name :", val: tmp1[0]["cdph_crude"] as? String ?? "-", noValueHide: false)
        appendValue(hd: "Supplier :", val: tmp1[0]["cdph_supplier"] as? String ?? "-", noValueHide: false)
        appendValue(hd: "Quantity :", val: tmp1[0]["cdph_quantity"] as? String ?? "-", noValueHide: false)
        appendValue(hd: "Incoterm :", val: tmp1[0]["cdph_incoterm"] as? String ?? "-", noValueHide: false)
        appendValue(hd: "Price :", val: tmp1[0]["cdph_price"] as? String ?? "-", noValueHide: false)
        appendValue(hd: "Pricing Month :", val: tmp1[0]["cdph_pricing_prd"] as? String ?? "-", noValueHide: false)
        appendValue(hd: "Slide1", val: "", noValueHide: false)
        appendValue(hd: "Slide2", val: "", noValueHide: false)
        appendValue(hd: "\(Data["deal_benefit_title"] as? String ?? "-") :", val: Data["deal_benefit"] as? String ?? "-", noValueHide: true)
        appendValue(hd: "\(Data["remaining_benefit_title"] as? String ?? "-") :", val: Data["remaining_benefit"] as? String ?? "-", noValueHide: true)
        appendValue(hd: "Total benefit at TOP :", val: Data["total_benefit"] as? String ?? "-", noValueHide: false)
        if tmpArrAdvanceLoading.count > 0{
            for item in tmpArrAdvanceLoading {
              appendValue(hd: "Advance Loading Request Reason :", val: item["alr_request_reson"] as? String ?? "", noValueHide: false)
            }
        }else if tmpArrContractData.count > 0 {
            for item in tmpArrContractData {
              appendValue(hd: "Final Contract Documents :", val: item["caf_final_documents"] as? String ?? "", noValueHide: false)
            }
        }
        appendValue(hd: "Brief :", val:  self.getBriefText(def: Data["brief"] as? String ?? "-"), noValueHide: false)
        appendValue(hd: "Requested By :", val: Data["created_by"] as? String ?? "-", noValueHide: false)
        
        //final
//        appendValue(hd: "Sale&Re-Optimization No. :", val: Data["doc_no"] as? String ?? "-", noValueHide: false)
//        appendValue(hd: "Contract For :", val: Data["doc_no"] as? String ?? "-", noValueHide: false)
//        appendValue(hd: "Status :", val: Data["doc_no"] as? String ?? "-", noValueHide: false)
//        appendValue(hd: "Purchased from", val: "", noValueHide: false)
//        let tmp2 = Data["list_cdph"] as? [[String: Any]] ?? []
//        appendValue(hd: "Crude Name :", val: tmp2[0]["cdph_crude"] as? String ?? "-", noValueHide: false)
//        appendValue(hd: "Supplier :", val: tmp2[0]["cdph_supplier"] as? String ?? "-", noValueHide: false)
//        appendValue(hd: "Quantity :", val: tmp2[0]["cdph_quantity"] as? String ?? "-", noValueHide: false)
//        appendValue(hd: "Incoterm :", val: tmp2[0]["cdph_incoterm"] as? String ?? "-", noValueHide: false)
//        appendValue(hd: "Price :", val: tmp2[0]["cdph_price"] as? String ?? "-", noValueHide: false)
//        appendValue(hd: "Pricing Month :", val: tmp2[0]["cdph_pricing_prd"] as? String ?? "-", noValueHide: false)
//        appendValue(hd: "Slide1", val: "", noValueHide: false)
//        appendValue(hd: "Slide2", val: "", noValueHide: false)
//        appendValue(hd: "\(Data["deal_benefit_title"] as? String ?? "-") :", val: Data["deal_benefit"] as? String ?? "-", noValueHide: true)
//        appendValue(hd: "\(Data["remaining_benefit_title"] as? String ?? "-") :", val: Data["remaining_benefit"] as? String ?? "-", noValueHide: true)
//        appendValue(hd: "Total benefit at TOP :", val: Data["total_benefit"] as? String ?? "-", noValueHide: false)
//        appendValue(hd: "Final Contract Documents :", val: Data["doc_no"] as? String ?? "", noValueHide: false)
//        appendValue(hd: "Brief :", val:  self.getBriefText(def: Data["brief"] as? String ?? "-"), noValueHide: false)
//        appendValue(hd: "Requested By :", val: Data["created_by"] as? String ?? "-", noValueHide: false)
        
        
        
        makeCellHeight()
        
        arrAwardedData = getAwardData(Datas: Data["list_awarded"] as? [[String: Any]] ?? [])
        arrAwardedHeight = getArrHeight(Header: awardedHeader, Datas: arrAwardedData)
        cellHeight[posAwarded] = getDataHeight(Data: arrAwardedHeight)
        
        arrReoptData = getReoptData(Datas: Data["list_reopt"] as? [[String: Any]] ?? [])
        arrReoptHeight = getArrHeight(Header: reoptHeader, Datas: arrReoptData)
        cellHeight[posReopt] = getDataHeight(Data: arrReoptHeight)
        
        conTableView.constant = getTableHeight()
        mainTableView.reloadData()
        return conTableView.constant + GlobalVar.sharedInstance.detailViewGap
    }
    
    private func getAwardData(Datas: [[String: Any]]) -> [[String]] {
        var arrDatas = [[String]]()
        for item in Datas {
            var arrObjData = [String]()
            arrObjData.append(item["awarded_title"] as? String ?? "-")
            arrObjData.append(item["awarded_crude"] as? String ?? "-")
            arrObjData.append(item["awarded_customer"] as? String ?? "-")
            arrObjData.append(item["awarded_quantity"] as? String ?? "-")
            arrObjData.append(item["awarded_incoterm"] as? String ?? "-")
            arrObjData.append(item["awarded_price"] as? String ?? "-")
            arrObjData.append(item["awarded_market_price"] as? String ?? "-")
            arrObjData.append(item["awarded_pricing_prd"] as? String ?? "-")
            arrObjData.append(item["awarded_benefit_purchasing"] as? String ?? "-")
            arrObjData.append(item["awarded_contract_prd"] as? String ?? "-")
            arrObjData.append(item["awarded_loading_prd"] as? String ?? "-")
            arrObjData.append(item["awarded_discharging_prd"] as? String ?? "-")
            arrDatas.append(arrObjData)
        }
        return arrDatas
    }
    
    private func getReoptData(Datas: [[String: Any]]) -> [[String]] {
        var arrDatas = [[String]]()
        for item in Datas {
            var arrObjData = [String]()
            arrObjData.append(item["reopt_title"] as? String ?? "-")
            arrObjData.append(item["reopt_crude"] as? String ?? "-")
            arrObjData.append(item["reopt_supplier"] as? String ?? "-")
            arrObjData.append(item["reopt_quantity"] as? String ?? "-")
            arrObjData.append(item["reopt_incoterm"] as? String ?? "-")
            arrObjData.append(item["reopt_price"] as? String ?? "-")
            arrObjData.append(item["reopt_market_price"] as? String ?? "-")
            arrObjData.append(item["reopt_lpmax_price"] as? String ?? "-")
            arrObjData.append(item["reopt_benefit_purchasing"] as? String ?? "-")
            arrObjData.append(item["reopt_loading_prd"] as? String ?? "-")
            arrObjData.append(item["reopt_discharging_prd"] as? String ?? "-")
            arrDatas.append(arrObjData)
        }
        return arrDatas
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
                cellHeight.append(calcHeight(lblHead: header[i], lblVal: ""))
            }
        }
    }
    
    private func getTableHeight() -> CGFloat {
        var tmp: CGFloat = 0
        for i in 0...cellHeight.count - 1 where i != posAwarded && i != posReopt {
            tmp += cellHeight[i]
        }
        tmp += getDataHeight(Data: arrAwardedHeight)
        tmp += getDataHeight(Data: arrReoptHeight)
        return tmp
    }
    
    private func getArrHeight(Header: [String], Datas: [[String]]) -> [CGFloat] {
        return getComparedArrHeight(Arr1: getArrHeaderHeight(Datas: Header), Arr2: getArrDataHeight(Datas: Datas), ShowBlank: false)
    }
    
    private func getDataHeight(Data: [CGFloat]) -> CGFloat {
        var h: CGFloat = 0
        for item in Data {
            h += item
        }
        if Data.count == 0 {
            return h
        }
        h += 40
        return h
    }
    
    private func getComparedArrHeight(Arr1: [CGFloat],Arr2: [CGFloat], ShowBlank: Bool) -> [CGFloat] {
        var tmpArr = [CGFloat]()
        if Arr1.count == 0 || Arr2.count == 0 && !ShowBlank  {
            return tmpArr
        }
        if Arr1.count != Arr2.count {
            return tmpArr
        }
        for i in 0...(Arr1.count - 1) {
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
            res = getComparedArrHeight(Arr1: res, Arr2: tmpArr, ShowBlank: false)
        }
        return res
    }
}

extension CrudeSaleReoptCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if header.count != value.count {
            return 0
        }
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if header[indexPath.row] == "Slide1" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "slidecell") as! CrudeOSlideCell
            cell.setCell(Headers: awardedHeader, Datas: arrAwardedData, CellHeight: arrAwardedHeight)
            return cell
        }
        
        if header[indexPath.row] == "Slide2" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "slidecell") as! CrudeOSlideCell
            cell.setCell(Headers: reoptHeader, Datas: arrReoptData, CellHeight: arrReoptHeight)
            return cell
        }
        if header[indexPath.row].lowercased().contains("brief") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! ListDataCell2
            cell.delegate = self
            cell.setupView(header: header[indexPath.row], value: value[indexPath.row], bold: false, arrButton: btnData)
            return cell
        } else if header[indexPath.row].lowercased().contains("purchased from") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellhead") as! ListDataHeaderCell
            cell.setupView(header: header[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListDataCell
            cell.delegate = self
            if indexPath.row == 0 || header[indexPath.row].contains("Total benefit") {
                cell.setupView(header: header[indexPath.row], value: value[indexPath.row], bold: true)
            } else {
                cell.setupView(header: header[indexPath.row], value: value[indexPath.row], bold: false)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight[indexPath.row]
    }
}

