//
//  HedgingDataCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 9/1/2561 BE.
//  Copyright © 2561 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class HedgingDataCell: BaseDataCell {
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSystem: UILabel!
    @IBOutlet weak var conTableView: NSLayoutConstraint!
    @IBOutlet weak var btnCollection: UICollectionView!
    @IBOutlet weak var vwLine : UIView!

    private var ticketType = ""
    private var dealType = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        mainTableView.register(UINib.init(nibName: "ListDataCell", bundle: nil), forCellReuseIdentifier: "cell")
        mainTableView.register(UINib.init(nibName: "ListDataCell2", bundle: nil), forCellReuseIdentifier: "cell2")
        btnCollection.register(UINib.init(nibName: "CrudeButtonCell", bundle: nil), forCellWithReuseIdentifier: "btncell")
    }
    
    private var reqTransactionId: String {
        let unixTimeStamp = Int(NSDate().timeIntervalSince1970)
        return "\(MyUtilities.randomInt(min: 0, max: 9999999))\(unixTimeStamp)"
    }
    
    func setCell(Data: [String: Any]) -> CGFloat {
        addDashLine(layer: vwLine.layer)
        type = Data["type"] as? String ?? ""
        transaction_id = Data["ticketid"] as! String
        req_txn_id = Data["req_transaction_id"]! as! String
        system = Data["system"] as? String ?? ""
        lblDate.text = Data["ticket_date"] as? String
        lblSystem.text = Data["system_type"] as? String ?? ""
        
        value.removeAll()
        header.removeAll()
        cellHeight.removeAll()
        
        ticketType = Data["ticket_type"] as? String ?? ""
        if (Data["ticket_deal_type_before"] as? String ?? "").lowercased() == "restructure" {
            dealType = Data["ticket_deal_type_before"] as? String ?? ""
        } else {
            dealType = Data["ticket_deal_type"] as? String ?? ""
        }
        
        if dealType.lowercased() == "arbitrage" {
            appendValue(hd: "Ticket No. :", val: Data["ticket_no"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Trader :", val: Data["trader"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Trade Date :", val: Data["ticket_deal_date"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Ticket Type :", val: Data["ticket_type"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Company :", val: Data["company"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Trading Book :", val: Data["trading_book"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Deal Type :", val: Data["ticket_deal_type"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Trade For :", val: Data["trade_for"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Counterparty :", val: Data["counter_party"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Underlying :", val: Data["underlying"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Tool :", val: Data["tool"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "MTM :", val: Data["mtm_value"] as? String ?? "-", noValueHide: true)
        } else if dealType.lowercased() == "restructure" {
            appendValue(hd: "Ticket No. :", val: Data["ticket_no"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Trader", val: Data["trader"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Trade Date :", val: Data["ticket_deal_date"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Ticket Type :", val: Data["ticket_type"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Company :", val: Data["company"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Trading Book :", val: Data["trading_book"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Restructure From :", val: " ", noValueHide: false)
            appendValue(hd: "Deal Type :", val: Data["ticket_deal_type_before"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Counterparty :", val: Data["counter_party_before"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Underlying :", val: Data["underlying_before"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Tool :", val: Data["tool_before"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Tenor :", val: Data["tenor_period_before"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Hedge Price :", val: Data["price_before"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Ticket Volume :", val: Data["ticket_volume_before"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Restructure To :", val: " ", noValueHide: false)
            appendValue(hd: "Deal Type :", val: Data["ticket_deal_type"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Counterparty :", val: Data["counter_party"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Underlying :", val: Data["underlying"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Tool :", val: Data["tool"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Tenor :", val: Data["tenor_period"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Hedge Price :", val: Data["price"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Ticket Volume :", val: Data["ticket_volume"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Restructure Amount :", val: Data["restructureAmount"] as? String ?? "-", noValueHide: true)
        } else if ticketType.lowercased() == "terminate" {
            appendValue(hd: "Ticket No. :", val: Data["ticket_no"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Trader :", val: Data["trader"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Terminate Date :", val: Data["ticket_deal_date"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Ticket Type :", val: Data["ticket_type"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Company :", val: Data["company"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Trading Book :", val: Data["trading_book"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Deal Type :", val: Data["ticket_deal_type"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Counterparty :", val: Data["counter_party"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Underlying :", val: Data["underlying"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Terminate Tenor :", val: Data["tenor_period"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Terminate Volume :", val: Data["ticket_volume"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Settlement Amount per Unit :", val: Data["settle_amount_perbbl"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Settlement Amount :", val: Data["settle_amount"] as? String ?? "-", noValueHide: true)
        } else {
            appendValue(hd: "Ticket No. :", val: Data["ticket_no"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Trader :", val: Data["trader"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Trade Date :", val: Data["ticket_deal_date"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Ticket Type :", val: Data["ticket_type"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Company :", val: Data["company"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Trading Book :", val: Data["trading_book"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Deal Type :", val: Data["ticket_deal_type"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Counterparty :", val: Data["counter_party"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Underlying :", val: Data["underlying"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Tool :", val: Data["tool"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Tenor :", val: Data["tenor_period"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Hedge Price :", val: Data["price"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Ticket Volume :", val: Data["ticket_volume"] as? String ?? "-", noValueHide: true)
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

extension HedgingDataCell: UITableViewDelegate,  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListDataCell
            cell.delegate = self
            cell.setupView(header: header[indexPath.row], value: value[indexPath.row], bold: true)
            cell.layoutIfNeeded()
            return cell
        } else {
            if header[indexPath.row].lowercased().contains("brief") {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! ListDataCell2
                cell.delegate = self
                cell.setupView(header: header[indexPath.row], value: value[indexPath.row], bold: false, arrButton: btnData)
                cell.layoutIfNeeded()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListDataCell
                cell.delegate = self
                cell.setupView(header: header[indexPath.row], value: "", bold: false)
                HedgingCellUtility.Shared.setText(Index: indexPath.row, Label: cell.lblValue, Value: value[indexPath.row], Type: ticketType, DealType: dealType)
                cell.layoutIfNeeded()
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight[indexPath.row]
    }
}


class HedgingCellUtility: CellUtils {
    static let Shared = HedgingCellUtility()
    
    func setText(Index: Int, Label: UILabel, Value: String, Type: String, DealType: String) {
        if Type.lowercased() == "terminate" {
            var Val = Value
            if Index == 12 {
                if Value.trim() == "" {
                    Val = "-"
                }
                Val = "\(Val) $"
            }
            if Index == 10 || Index == 11 || Index == 12{
                Label.text = ""
                Label.attributedText = changeNumberText(Text: Val, Color: UIColor.blue)
            } else {
                Label.text = Val
            }
            return
        }
        
        if DealType.lowercased() == "arbitrage" {
            if Index == 12 {
                Label.text = "\(Value)$"
                let tmp = Value.replacingOccurrences(of: ",", with: "")
                if let tmpNumber = NumberFormatter().number(from: tmp) {
                    if tmpNumber.doubleValue >= 0 {
                        Label.textColor = UIColor(red: 32 / 255, green: 179 / 255, blue: 57 / 255, alpha: 1)
                    } else {
                        Label.textColor = UIColor.red
                    }
                }
            } else {
                Label.text = Value
            }
            return
        }
        
        if DealType.lowercased() == "restructure" {
            if Index == 22 {
                Label.text = "\(Value)$"
                var tmp = Value.replacingOccurrences(of: ",", with: "")
                tmp = tmp.replacingOccurrences(of: "$", with: "")
                tmp = tmp.trimmingCharacters(in: .whitespacesAndNewlines)
                if let tmpNumber = NumberFormatter().number(from: tmp) {
                    if tmpNumber.doubleValue >= 0 {
                        Label.textColor = UIColor(red: 32 / 255, green: 179 / 255, blue: 57 / 255, alpha: 1)
                    } else {
                        Label.textColor = UIColor.red
                    }
                }
            } else {
                Label.text = Value
            }
            return
        }
        if Index == 11 || Index == 12 {
            Label.text = ""
            Label.attributedText = changeNumberText(Text: Value, Color: UIColor.blue)
        } else {
            Label.text = Value
        }
    }
    
    private func changeNumberText(Text: String, Color: UIColor) -> NSAttributedString {
        let resultStr = NSMutableAttributedString.init(string: Text)
        resultStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: GlobalVar.sharedInstance.getFontSize()), range: NSString.init(string: Text).range(of: Text))
        let arrRawString = Text.split(separator: " ")
        var arrTestString = [String]()
        for item in arrRawString {
            let arrRawString2 = item.split(separator: "/")
            for item2 in arrRawString2 {
                let tmpStr = item2.replacingOccurrences(of: ",", with: "")
                if let _ = NumberFormatter().number(from: tmpStr) {
                    arrTestString.append(item2)
    
                }
            }
        }
        var testText = Text
        if arrTestString.count > 0 {
            for i in 0...(arrTestString.count - 1) {
                let range = NSString.init(string: testText).range(of: arrTestString[i])
                resultStr.addAttribute(NSAttributedString.Key.foregroundColor, value: Color, range: range)
                var replaceText = ""
                for _ in 0...(range.length - 1) {
                    replaceText.append(" ")
                }
                testText = testText.replaceCharactersInRange(range: Range.init(range)!, withString: replaceText)
            }
        }
        return resultStr
    }
}
