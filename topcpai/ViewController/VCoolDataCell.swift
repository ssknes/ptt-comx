//
//  VCoolDataCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/29/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class VCoolDataCell: BaseDataCell {
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSystem: UILabel!
    @IBOutlet weak var conTableView: NSLayoutConstraint!
    @IBOutlet weak var btnCollection: UICollectionView!
    @IBOutlet weak var vwLine : UIView!
    @IBOutlet weak var btnShowPopup: UIButton!

    var txtResultSummary: String = ""
    var popupText: String = ""
    var showPopup: Bool = false
    var agreeValue: String = ""
    var purchaseValue: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        mainTableView.register(UINib.init(nibName: "ListDataCell", bundle: nil), forCellReuseIdentifier: "cell")
        mainTableView.register(UINib.init(nibName: "ListDataCell2", bundle: nil), forCellReuseIdentifier: "cell2")
        btnCollection.register(UINib.init(nibName: "CrudeButtonCell", bundle: nil), forCellWithReuseIdentifier: "btncell")
        mainTableView.register(UINib.init(nibName: "VCoolResultCell", bundle: nil), forCellReuseIdentifier: "popupcell")
        mainTableView.register(UINib.init(nibName: "VCoolAgreeCell", bundle: nil), forCellReuseIdentifier: "agreecell")
        mainTableView.register(UINib.init(nibName: "VCoolPurchaseCell", bundle: nil), forCellReuseIdentifier: "purchasecell")
        
        mainTableView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(test(_:))))
    }
    @objc func test(_ sender: Any) {
        self.endEditing(true)
    }
    
    @IBAction func onBtnShowPopup(_ sender: UIButton) {
        showPopup = !showPopup
        mainTableView.reloadData()
    }
    
    func setCell(Data: [String: Any], isExpand: Bool) -> CGFloat {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 4
        
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
        
        status = Data["status"] as? String ?? ""
        userGroup = (Data["user_group"] as? String ?? "").uppercased()
        
        appendValue(hd: "Purchase No. :", val: Data["purchase_no"] as? String ?? "", noValueHide: false)
        appendValue(hd: "Crude Name :", val: Data["product_name"] as? String ?? "", noValueHide: false)
        appendValue(hd: "Quantity :", val: "\(Data["quantity_kbbl_max"] as? String ?? "")  KBBL", noValueHide: false)
        if userGroup == "CMVP" || userGroup == "SCVP" || userGroup == "EVPC" || userGroup == "CMCS_SH" || userGroup == "SCEP_SH" {
            appendValue(hd: "Incoterm :", val: Data["incoterm"] as? String ?? "", noValueHide: false)
        }

        if userGroup == "EVPC" {
            appendValue(hd: "Final Purchasing Price :", val: Data["formula_p"] as? String ?? "", noValueHide: false)
        } else if (userGroup == "CMVP" || userGroup == "CMCS_SH") {
            if status.uppercased() != "WAITING CMVP APPROVE" {
                appendValue(hd: "Final Purchasing Price :", val: Data["formula_p"] as? String ?? "", noValueHide: false)
            } else {
                appendValue(hd: "Proposed Price :", val: Data["formula_p"] as? String ?? "", noValueHide: false)
            }
        } else if userGroup == "SCEP_SH" || userGroup == "SCVP" {
            appendValue(hd: "Proposed Price :", val: Data["formula_p"] as? String ?? "", noValueHide: false)
        }
        
        if userGroup == "CMVP" || userGroup == "SCVP" || userGroup == "EVPC" || userGroup == "CMCS_SH" || userGroup == "SCEP_SH" {
            let tmpNum = Float(Data["premium_maximum"] as? String ?? "")
            var tmpStr: String = ""
            if tmpNum != nil {
                let numb = NSNumber(value: tmpNum!)
                tmpStr = numberFormatter.string(from: numb) ?? "-"
            } else {
                tmpStr = "-"
            }
            appendValue(hd: "LP Max Purchasing Price :", val: "\(Data["benchmark_price"] as? String ?? "")\(tmpStr) \(Data["incoterm"] as? String ?? "") $/bbl", noValueHide: false)
        }
        
        appendValue(hd: "Loading period :", val: Data["loading_period"] as? String ?? "", noValueHide: false)
        appendValue(hd: "Discharging period :", val: Data["discharging_period"] as? String ?? "", noValueHide: false)
        
        if userGroup == "CMVP" || userGroup == "EVPC" || userGroup == "CMCS_SH" {
            appendValue(hd: "Requested By :", val: Data["requested_name"] as? String ?? "", noValueHide: false)
        }
        // agree view
        
        if userGroup == "SCSC_SH" {
            appendValue(hd: "agree_cell", val: "" , noValueHide: false) //Agree View
            agreeValue = (Data["scsc_agree_flag"] as? String ?? "").lowercased()
            if agreeValue == "disagree" {
                appendValue(hd: "Revise discharging period :", val: Data["revise_dischange_period"] as? String ?? "", noValueHide: false)
            }
        }
        //Purchase view
        if (userGroup == "CMCS_SH" || userGroup == "CMVP" || userGroup == "EVPC") && status != "WAITING CMVP APPROVE" {
            appendValue(hd: "purchase_cell", val: "", noValueHide: false)
            if status == "WAITING APPROVE SUMMARY" || status == "APPROVED" || status == "TERMINATED" {
                purchaseValue = Data["purchase_result"] as? String ?? ""
            }
        }
        
        popupText = Data["lp_result"] as? String ?? ""
        
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

extension VCoolDataCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showPopup {
            return 1
        }
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showPopup {
            self.btnShowPopup.setAttributedTitle(NSAttributedString(string: "<<< Back",attributes: [:]), for: .normal)
            let cell = tableView.dequeueReusableCell(withIdentifier: "popupcell") as! VCoolResultCell
            cell.setView(Text: popupText)
            return cell
        } else {
            self.btnShowPopup.setAttributedTitle(NSAttributedString(string: "LP Result Summary >>>",attributes: [:]), for: .normal)
            if header[indexPath.row] == "agree_cell" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "agreecell") as! VCoolAgreeCell
                cell.setView(Value: agreeValue)
                return cell
            }
            if header[indexPath.row] == "purchase_cell" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "purchasecell") as! VCoolPurchaseCell
                cell.setView(status: status, text: purchaseValue)
                cell.delegate = self
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if showPopup {
            var tmp: CGFloat = 0
            for item in cellHeight {
                tmp += item
            }
            return tmp
        }
        return cellHeight[indexPath.row]
    }
}

extension VCoolDataCell: VCoolPurchaseCellDelegate {
    func onChangePurchaseValue(value: String) {
        purchaseValue = value
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CrudeButtonCell
        if userGroup == "CMCS_SH" || userGroup == "CMVP" {
            let purchase_result = ["purchase_result": purchaseValue]
            let json :[String: Any] = ["crude_info": purchase_result]
            cell.onButtonClick(json, brief: self.txtBrief)
        } else {
            cell.onButtonClick([:], brief: self.txtBrief)
        }
    }
}
