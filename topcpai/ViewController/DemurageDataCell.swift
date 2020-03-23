//
//  DemurageDataCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 7/12/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class DemurageDataCell: BaseDataCell {
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
    
    func setCell(Data : [String: Any]) -> CGFloat {
        addDashLine(layer: vwLine.layer)
        type = Data["type"] as? String ?? ""
        transaction_id = Data["transaction_id"] as? String ?? ""
        req_txn_id = Data["req_transaction_id"] as? String ?? ""
        system = Data["system"] as? String ?? ""
        lblDate.text = DemurrageCellUtilitiy.Share.getCreateDateString(Data: Data)
        lblSystem.text = Data["system_type"] as? String ?? ""
        
        value.removeAll()
        header.removeAll()
        cellHeight.removeAll()
        appendValue(hd: "Reference No.:", val: Data["purchase_no"] as? String ?? "", noValueHide: true)
        appendValue(hd: "Transaction between :", val: Data["for_company"] as? String ?? "", noValueHide: true)
        appendValue(hd: "CounterParty :", val: Data["counterparty"] as? String ?? "", noValueHide: true)
        appendValue(hd: "Demurrage type :", val: Data["demurrage_type"] as? String ?? "", noValueHide: true)
        appendValue(hd: "Vessel Name :", val: Data["vessel_name"] as? String ?? "", noValueHide: true)
        appendValue(hd: "- Crude/ Product :", val: Data["product_crude"] as? String ?? "", noValueHide: true)
        appendValue(hd: "- Type of transaction :", val: Data["type_of_transaction"] as? String ?? "", noValueHide: true)
        appendValue(hd: "- Incoterm :", val: Data["incoterm"] as? String ?? "", noValueHide: true)
        appendValue(hd: "Agreed Loading Lycan :", val: Data["agreed_loading_laycan"] as? String ?? "", noValueHide: true)
        appendValue(hd: "Agreed Discharging Laycan :", val: Data["agreed_discharging_laycan"] as? String ?? "", noValueHide: true)
        appendValue(hd: "Agreed Laycan :", val: Data["agreed_laycan"] as? String ?? "", noValueHide: true)
        appendValue(hd: "Contract laytime :", val: Data["contract_laytime"] as? String ?? "", noValueHide: true)
        appendValue(hd: "Actual net laytime :", val: Data["actual_net_laytime"] as? String ?? "", noValueHide: true)
        appendValue(hd: "Time on demurrage :", val: Data["time_on_demurrage"] as? String ?? "", noValueHide: true)
        appendValue(hd: "Demurrage paid settled :", val: Data["demurrage_paid_settled"] as? String ?? "", noValueHide: true)
        appendValue(hd: "Demurrage received settled :", val: Data["demurrage_received_settled"] as? String  ?? "", noValueHide: true)
        appendValue(hd: "Brief :", val: self.getBriefText(def: Data["brief"] as? String ?? "-") , noValueHide: false)
        appendValue(hd: "Requested By :", val: Data["created_by"] as? String ?? "", noValueHide: true)
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
extension DemurageDataCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

class DemurrageCellUtilitiy: CellUtils {
    static let Share = DemurrageCellUtilitiy()
    func getCreateDateString(Data: [String: Any]) -> String {
        let df = DateFormatter()
        df.calendar = Calendar.init(identifier: .gregorian)
        df.dateFormat = "dd-MM-yyyy hh:mm"
        let df2 = DateFormatter()
        df2.calendar = Calendar.init(identifier: .gregorian)
        df2.dateFormat = "dd/MM/yyyy"
        if let temp = df.date(from: Data["created_date"] as? String ?? "") {
            return df2.string(from: temp)
        }
        return "-"
    }
}
