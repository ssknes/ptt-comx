//
//  CrudeDateCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/23/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class CrudeDataCell: BaseDataCell {
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSystem: UILabel!
    @IBOutlet weak var conTableView: NSLayoutConstraint!
    @IBOutlet weak var btnCollection: UICollectionView!
    @IBOutlet weak var vwLine : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        mainTableView.register(UINib.init(nibName: "ListDataCell", bundle: nil), forCellReuseIdentifier: "cell")
        mainTableView.register(UINib.init(nibName: "ListDataCell2", bundle: nil), forCellReuseIdentifier: "cell2")
        btnCollection.register(UINib.init(nibName: "CrudeButtonCell", bundle: nil), forCellWithReuseIdentifier: "btncell")
    }
    
    func setCell(Data: [String: Any]) -> CGFloat {
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
        
        let tmpArrAdvanceLoading = Data["advance_loading_request_data"] as? [[String: Any]] ?? []
        let tmpArrContractData = Data["contract_data"] as? [[String: Any]] ?? []
        
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
                appendValue(hd: "Contract For :", val: Data["purchase_no"] as? String ?? "", noValueHide: false)
               if(item["caf_status"] as? String == "WAITING APPROVE"){
                appendValue(hd: "Status :", val: "WAITING FINAL CONTRACT", noValueHide: false)
               }else {
                appendValue(hd: "Status :", val: item["caf_status"] as? String ?? "", noValueHide: false)
                }
            }
        }else{
            appendValue(hd: "Status :", val: Data["status"] as? String ?? "", noValueHide: false)
        }
        appendValue(hd: "Crude Name :", val: Data["product_name"] as? String ?? "", noValueHide: false)
        appendValue(hd: "Supplier :", val: Data["supplier_name"] as? String ?? "", noValueHide: false)
        appendValue(hd: "Quantity :", val: Data["volumes"] as? String ?? "", noValueHide: false)
        appendValue(hd: "Incoterm :", val: Data["incoterm"] as? String ?? "", noValueHide: false)
        appendValue(hd: "Purchasing price :", val: Data["purchase_p"] as? String ?? "", noValueHide: false)
        appendValue(hd: "Market price :", val: Data["market_p"] as? String ?? "", noValueHide: false)
        appendValue(hd: "LP max price :", val: Data["lp_p"] as? String ?? "", noValueHide: false)
        appendValue(hd: "Benefit vs Market Price :", val: Data["ben_m"] as? String ?? "", noValueHide: false)
        appendValue(hd: "Benefit vs max price :", val: Data["margin"] as? String ?? "", noValueHide: false)
        appendValue(hd: "Loading period :", val: Data["loading_period"] as? String ?? "", noValueHide: false)
        appendValue(hd: "Discharging period :", val: Data["discharging_period"] as? String ?? "", noValueHide: false)
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
        appendValue(hd: "Requested By :", val: Data["create_by"] as? String ?? "", noValueHide: false)
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
                cellHeight.append(calcHeight(lblHead: header[i], lblVal: ""))
            }
        }
    }
    
    func getTableHeight() -> CGFloat {
        var tmp: CGFloat = 0
        for item in cellHeight {
            tmp += item
        }
        return tmp
    }
}

extension CrudeDataCell: UITableViewDelegate, UITableViewDataSource {
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

