//
//  CharteringDataCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/25/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class CellUtils: NSObject {
    func shortMonthDateFormatter(dateStr: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        dateFormatter.locale = Locale.init(identifier: "EN_US")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.dateFormat = "dd-MMM-yyy"
            return dateFormatter.string(from: (date))
        }
        return dateStr
    }
}

class CharteringCellUtils: CellUtils {
    static let Shared = CharteringCellUtils()
    
    func getBrokerName(data: [String: Any]) -> String {
        var tempBroker = data["broker_name"] as? String ?? ""
        if tempBroker.count == 0 || tempBroker == "-" {
            tempBroker = data["broker_id"] as? String ?? ""
        }
        return tempBroker
    }
    
    func getLaycan(data: [String: Any]) -> String {
        return "\(shortMonthDateFormatter(dateStr: data["laycan_from"] as? String ?? "")) to \(shortMonthDateFormatter(dateStr: data["laycan_to"] as? String ?? ""))"
    }
    
    func getFreight(data: [String: Any]) -> String {
        return "\(getCurrencyText(data["est_freight"] as? String ?? "")) \(data["unit_price_value"] as? String ?? "")"
    }
    
    private func getCurrencyText(_ inp: String) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.currencyGroupingSeparator = ","
        nf.maximumFractionDigits = 4
        nf.minimumFractionDigits = 4
        nf.currencySymbol = ""
        let txt = nf.number(from: inp)
        if txt != nil {
            return nf.string(from: txt!)!
        }
        return ""
    }
}

class CharteringDataCell: BaseDataCell {
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSystem: UILabel!
    @IBOutlet weak var conTableView: NSLayoutConstraint!
    @IBOutlet weak var btnCollection: UICollectionView!
    @IBOutlet weak var vwLine : UIView!
    
    var dataFinalPrice = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        //tableViewFinalPrice.bounces = false
        //tableViewFinalPrice.register(UINib.init(nibName: "CharteringFinalPriceCell", bundle: nil), forCellReuseIdentifier: "cell")
        mainTableView.register(UINib.init(nibName: "ListDataCell", bundle: nil), forCellReuseIdentifier: "cell")
        mainTableView.register(UINib.init(nibName: "ListDataCell2", bundle: nil), forCellReuseIdentifier: "cell2")
        btnCollection.register(UINib.init(nibName: "CrudeButtonCell", bundle: nil), forCellWithReuseIdentifier: "btncell")
    }
    
    func setCell(Data: [String: Any], isExpand: Bool) -> CGFloat {
        log.info("dataaa222 ======>>>> \(Data)")
        addDashLine(layer: vwLine.layer)
        type = Data["type"] as? String ?? ""
        transaction_id = Data["transaction_id"] as? String ?? ""
        req_txn_id = Data["req_transaction_id"] as? String ?? ""
        system = Data["system"] as? String ?? ""
        lblDate.text = Data["date_purchase"] as? String ?? ""
        lblSystem.text = Data["system_type"] as? String ?? ""
        
        value.removeAll()
        header.removeAll()
        cellHeight.removeAll()
        
        let funcID = Data["function_id"] as? String ?? ""
        let tmpArrAdvanceLoading = Data["advance_loading_request_data"] as? [[String: Any]] ?? []
        let tmpArrContractData = Data["contract_data"] as? [[String: Any]] ?? []
        
        if funcID == "25" {
            if tmpArrAdvanceLoading.count > 0{
                for item in tmpArrAdvanceLoading {
                 appendValue(hd: "Document No. :", val: item["alr_row_no"] as? String ?? "", noValueHide: false)
                }
            }else if tmpArrContractData.count > 0 {
                for item in tmpArrContractData {
                 appendValue(hd: "Document No. :", val: item["caf_contract_no"] as? String ?? "", noValueHide: false)
                }
            }else {
               appendValue(hd: "Document No. :", val: Data["purchase_no"] as? String ?? "", noValueHide: false)
            }
        } else {
            if tmpArrAdvanceLoading.count > 0{
                for item in tmpArrAdvanceLoading {
                  appendValue(hd: "Purchase No. :", val: item["alr_row_no"] as? String ?? "", noValueHide: false)
                }
            }else if tmpArrContractData.count > 0 {
                for item in tmpArrContractData {
                  appendValue(hd: "Purchase No. :", val: item["caf_contract_no"] as? String ?? "", noValueHide: false)
                }
            }else {
              appendValue(hd: "Purchase No. :", val: Data["purchase_no"] as? String ?? "", noValueHide: false)
            }
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
        
        
        appendValue(hd: "Vessel Name. :", val: Data["vessel"] as? String ?? "", noValueHide: false)
        
        if funcID != "7" {
            appendValue(hd: "Owner :", val: Data["owner"] as? String ?? "", noValueHide: false)
        }
        if funcID == "25" {
            appendValue(hd: "Charterer :", val: Data["charterer_name"] as? String ?? "", noValueHide: false)
        }
        if funcID != "7" {
            appendValue(hd: "Broker :", val: Data["cust_name"] as? String ?? "", noValueHide: false)
        } else {
            appendValue(hd: "Charterer :", val: Data["cust_name"] as? String ?? "", noValueHide: false)
        }
        if  funcID == "25" {
            appendValue(hd: "Laycan :", val: CharteringCellUtils.Shared.getLaycan(data: Data), noValueHide: false)
        } else {
            appendValue(hd: "Vessel Laycan :", val: CharteringCellUtils.Shared.getLaycan(data: Data), noValueHide: false)
        }
        
        if funcID == "25" {
            let strLoadPort: String = Data["load_port"] as? String ?? ""
            let tempLoadPort = strLoadPort.split(separator: "|").dropLast()
            if tempLoadPort.count > 0 {
                if tempLoadPort.count == 1 {
                    appendValue(hd: "Loading Port :", val: tempLoadPort[0], noValueHide: false)
                } else {
                    for i in 0...(tempLoadPort.count - 1) {
                        appendValue(hd: "Loading Port \(i + 1) :", val: tempLoadPort[i], noValueHide: false)
                    }
                }
            }
            
            let strDischarge: String = Data["discharge_port"] as? String ?? ""
            let tempDischarge = strDischarge.split(separator: "|").dropLast()
            if tempDischarge.count > 0 {
                if tempDischarge.count == 1 {
                    appendValue(hd: "Discharging Port :", val: tempLoadPort[0], noValueHide: false)
                } else {
                    for i in 0...(tempDischarge.count - 1) {
                        appendValue(hd: "Discharging Port \(i + 1) :", val: tempLoadPort[i], noValueHide: false)
                    }
                }
            }
        }
        //final price
        let strFinalPrice = Encryptor.decryptWithRSA(cipherText: Data["final_price"] as? String ?? "")
        if strFinalPrice != "|" {
            let str: String = strFinalPrice
            let temp = str.split(separator: "|").dropLast()
            for item in temp {
                let arrText: [String] = item.split(separator: ":")
                if arrText.count > 1 {
                    appendValue(hd: "\(arrText[0]) :", val: arrText[1], noValueHide: false)
                }
            }
        }
        //
        if funcID != "25" {
            appendValue(hd: "War Risk/Arm Guard :", val: Data["exten_cost"] as? String ?? "", noValueHide: false)
            appendValue(hd: "Est. Freight (USD/BBL) :", val: Data["est_freight"] as? String ?? "", noValueHide: false)
            if tmpArrAdvanceLoading.count > 0{
                for item in tmpArrAdvanceLoading {
                  appendValue(hd: "Advance Loading Request Reason :", val: item["alr_request_reson"] as? String ?? "", noValueHide: false)
                }
            }else if tmpArrContractData.count > 0 {
                for item in tmpArrContractData {
                  appendValue(hd: "Final Contract Documents :", val: item["caf_final_documents"] as? String ?? "", noValueHide: false)
                }
            }
            appendValue(hd: "Brief :", val: self.getBriefText(def: Data["brief"] as? String ?? "-") , noValueHide: false)
            appendValue(hd: "Requesed By :", val: Data["create_by"] as? String ?? "", noValueHide: false)
        } else {
            if tmpArrAdvanceLoading.count > 0{
                for item in tmpArrAdvanceLoading {
                  appendValue(hd: "Advance Loading Request Reason :", val: item["alr_request_reson"] as? String ?? "", noValueHide: false)
                }
            }else if tmpArrContractData.count > 0 {
                for item in tmpArrContractData {
                  appendValue(hd: "Final Contract Documents :", val: item["caf_final_documents"] as? String ?? "", noValueHide: false)
                }
            }
            appendValue(hd: "Brief :", val: self.getBriefText(def: Data["brief"] as? String ?? "-") , noValueHide: false)
        }
        makeCellHeight()
        conTableView.constant = getTableHeight()
        mainTableView.reloadData()
        return getTableHeight() + GlobalVar.sharedInstance.detailViewGap
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
        for item in cellHeight {
            tmp += item
        }
        return tmp
    }
}


extension CharteringDataCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if header[indexPath.row].lowercased().contains("brief") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! ListDataCell2
            cell.delegate = self
            cell.setupView(header: header[indexPath.row], value: value[indexPath.row], bold: false, arrButton: btnData)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListDataCell
        cell.delegate = self
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
