//
//  CharterOutCMMTCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 9/25/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class CharterOutCMMTCell: BaseDataCell {
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
    
    func setCell(Data: [String: Any], isExpand: Bool) -> CGFloat {
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
        
        appendValue(hd: "Document No. :", val: Data["purchase_no"] as? String ?? "", noValueHide: false)
        appendValue(hd: "Vessel Name :", val: Data["vessel"] as? String ?? "", noValueHide: false)
        appendValue(hd: "Charterer :", val: Data["cust_name"] as? String ?? "", noValueHide: false)
        appendValue(hd: "Broker :", val: CharteringCellUtils.Shared.getBrokerName(data: Data), noValueHide: false)
        appendValue(hd: "Laycan :", val: CharteringCellUtils.Shared.getLaycan(data: Data), noValueHide: false)
    
        let strLoadPort: String = Data["load_port"] as? String ?? ""
        let tempLoadPort = strLoadPort.split(separator: "|").dropLast()
        if tempLoadPort.count == 1 {
            appendValue(hd: "Loading Port :", val: tempLoadPort[0], noValueHide: false)
        } else {
            for i in 0...(tempLoadPort.count - 1) {
                appendValue(hd: "Loading Port \(i + 1) :", val: tempLoadPort[i], noValueHide: false)
            }
        }
        
        let strDischarge: String = Data["discharge_port"] as? String ?? ""
        let tempDischarge = strDischarge.split(separator: "|").dropLast()
        if tempDischarge.count == 1 {
            appendValue(hd: "Discharging Port :", val: tempLoadPort[0], noValueHide: false)
        } else {
            for i in 0...(tempDischarge.count - 1) {
                appendValue(hd: "Discharging Port \(i + 1) :", val: tempLoadPort[i], noValueHide: false)
            }
        }
        appendValue(hd: "Freight :", val: CharteringCellUtils.Shared.getFreight(data: Data), noValueHide: false)
        appendValue(hd: "Result :", val: " ", noValueHide: false)
        appendValue(hd: "\u{2022} No Charter out (Total TC Expense)", val: "= \(getCurrencyText(Data["no_total_ex"] as? String ?? "")) USD", noValueHide: false)
        appendValue(hd: "\u{2022} Charter out", val: "= \(getCurrencyText(Data["total_ex"] as? String ?? "")) USD", noValueHide: false)
        appendValue(hd: "\u{2022} Total \(Data["result_flag"] as? String ?? "")", val: "= \(getCurrencyText(Data["net_benefit"] as? String ?? "")) USD", noValueHide: false)
        appendValue(hd: "Brief :", val: self.getBriefText(def: Data["brief"] as? String ?? "-") , noValueHide: false)
        makeCellHeight()
        conTableView.constant = getTableHeight()
        mainTableView.reloadData()
        return getTableHeight() + GlobalVar.sharedInstance.detailViewGap
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

extension CharterOutCMMTCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if header[indexPath.row].lowercased().contains("brief") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! ListDataCell2
            cell.delegate = self
            cell.setupView(header: header[indexPath.row], value: value[indexPath.row], bold: false, arrButton: self.btnData)
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
