//
//  HedgeDataCellS.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 9/1/2561 BE.
//  Copyright © 2561 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class HedgeDataCellS: BaseDataCell {
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSystem: UILabel!
    @IBOutlet weak var conTableView: NSLayoutConstraint!
    @IBOutlet weak var btnCollection: UICollectionView!
    @IBOutlet weak var vwLine : UIView!
    
    private var frameType: String = ""
    
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
        transaction_id = Data["transaction_id"] as! String
        req_txn_id = Data["req_transaction_id"]! as! String
        system = Data["system"] as? String ?? ""
        lblDate.text = Data["created_date"] as? String
        lblSystem.text = Data["system_type"] as? String ?? ""
        
        value.removeAll()
        header.removeAll()
        cellHeight.removeAll()
        
        frameType = Data["frame_type"] as? String ?? ""
        if frameType.lowercased() == "terminate" {
            appendValue(hd: "Settlement No.:", val: Data["purchase_no"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Company :", val: Data["company"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Settlement Period :", val: Data["settlement_period"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Type :", val: Data["frame_type"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Counterparty :", val: Data["counter_party"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Payment Date :", val: Data["payment_date"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Total Volume :", val: "\(Data["total_volume_bbl"] as? String ?? "-") BBL \(Data["total_volume_ton"] as? String ?? "-") MT", noValueHide: true)
            appendValue(hd: "Net Gain/Loss (USD) :", val: "\(Data["settlement_amount"] as? String ?? "-") $", noValueHide: true)
        } else if frameType.lowercased() == "restructure" {
            appendValue(hd: "Memo Date :", val: Data["created_date"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Document No. :", val: Data["purchase_no"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Company :", val: Data["company"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Settlement Period", val: Data["settlemnet_period"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Type", val: Data["frame_type"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Counterparty :", val: Data["counter_party"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Payment Date :", val: Data["payment_date"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Total Volume :", val: "\(Data["total_volume_bbl"] as? String ?? "-") BBL \(Data["total_volume_ton"] as? String ?? "-") MT", noValueHide: true)
            appendValue(hd: "Net Gain/Loss(USD) :", val: "\(Data["settlement_amount"] as? String ?? "-") $", noValueHide: true)
        } else {
            appendValue(hd: "Settlement No.:", val: Data["purchase_no"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Company :", val: Data["company"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Settlement Period :", val: Data["settlement_period"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Type :", val: Data["frame_type"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Payment Date :", val: Data["payment_date"] as? String ?? "-", noValueHide: true)
            appendValue(hd: "Total Volume :", val: "\(Data["total_volume_bbl"] as? String ?? "-") BBL \(Data["total_volume_ton"] as? String ?? "-") MT", noValueHide: true)
            appendValue(hd: "Net Gain/Loss (USD) :", val: "\(Data["settlement_amount"] as? String ?? "-") $", noValueHide: true)
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

extension HedgeDataCellS: UITableViewDelegate, UITableViewDataSource {
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
                HedgeCellSUtility.Shared.setText(Index: indexPath.row, Label: cell.lblValue, Value: value[indexPath.row], FrameType: frameType)
                cell.layoutIfNeeded()
                return cell
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight[indexPath.row]
    }
}
class HedgeCellSUtility: CellUtils {
    static let Shared = HedgeCellSUtility()
    
    func setText(Index: Int, Label: UILabel, Value: String, FrameType: String) {
        
        if FrameType.lowercased() == "terminate" {
            if Index == 6 {
                Label.attributedText = changeNumberText(Text: Value, Color: UIColor.blue, Color2: UIColor.blue)
            } else if Index == 7 {
                Label.attributedText = changeNumberText(Text: Value, Color: UIColor.red, Color2: UIColor.init(red: 94 / 255, green: 182 / 255, blue: 106 / 255, alpha: 1))
            } else {
                Label.text = Value
            }
        } else if FrameType.lowercased() == "restructure" {
            Label.text = Value
            if Index == 8 {
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
            }
            if Index == 7 {
                Label.text = ""
                Label.attributedText = changeNumberText(Text: Value, Color: UIColor.blue, Color2: UIColor.blue)
            }
        } else {
            if Index == 5 {
                Label.attributedText = changeNumberText(Text: Value, Color: UIColor.blue, Color2: UIColor.blue)
            } else if Index == 6 {
                Label.attributedText = changeNumberText(Text: Value, Color: UIColor.red, Color2: UIColor.init(red: 94 / 255, green: 182 / 255, blue: 106 / 255, alpha: 1))
            } else {
                Label.text = Value
            }
        }
    }
    
    private func changeNumberText(Text: String, Color: UIColor, Color2: UIColor) -> NSAttributedString {
        let resultStr = NSMutableAttributedString.init(string: Text)
        resultStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: GlobalVar.sharedInstance.getFontSize()), range: NSString.init(string: Text).range(of: Text))
        let arrRawString = Text.split(separator: " ")
        var arrTestString = [String]()
        for item in arrRawString {
            let tmpStr = item.replacingOccurrences(of: ",", with: "")
            if let _ = NumberFormatter().number(from: tmpStr) {
                arrTestString.append(item)
            }
        }
        
        var testText = Text
        if arrTestString.count > 0 {
            for i in 0...(arrTestString.count - 1) {
                let range = NSString.init(string: testText).range(of: arrTestString[i])
                let tmpStr = arrTestString[i].replacingOccurrences(of: ",", with: "")
                if let num = NumberFormatter().number(from: tmpStr) {
                    if CGFloat(truncating: num) >= 0 {
                        resultStr.addAttribute(NSAttributedString.Key.foregroundColor, value: Color2, range: range)
                    } else {
                        resultStr.addAttribute(NSAttributedString.Key.foregroundColor, value: Color, range: range)
                    }
                }
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

/*
class HedgingDataCellS: BaseDataCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    
    @IBOutlet var lblHeaders: [UILabel]!
    @IBOutlet var lblValues: [UILabel]!
    
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var btnCollection: UICollectionView!
    
    private var Headers = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        btnCollection.register(UINib.init(nibName: "CrudeButtonCell", bundle: nil), forCellWithReuseIdentifier: "btncell")
    }
    
    func setCell(data : [String: Any]){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        dateFormatter.dateFormat = "MM"
        let dateFormatter2: DateFormatter = DateFormatter()
        dateFormatter2.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        dateFormatter2.dateFormat = "MMM"
        
        self.imgArrow.image = UIImage.init(named: "Rectangle02")
        self.backgroundColor = UIColor(red: 237.0/255.0, green: 238.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        
        let date =  data["created_date"] as? String
        let dateArray = date?.split(separator: "/")
        self.lblDate.attributedText = NSAttributedString(string: dateArray![0], attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        self.lblMonth.text = dateFormatter2.string(from: dateFormatter.date(from: dateArray![1])!)
        
        type = data["type"]! as! String
        transaction_id = data["transaction_id"]! as! String
        req_txn_id = data["req_transaction_id"]! as! String
        
        let frameType = data["frame_type"] as? String ?? ""
        self.Headers = getSettHeader(Type: frameType)
        for i in 0...(self.Headers.count - 1) {
            setText(Tag: i, Header: self.Headers[i], Value: self.getValueString(Type: frameType, Tag: i, Data: data), Type: frameType)
        }
    }
    
    func getViewHeight() -> CGFloat {
        var height: CGFloat = 0
        for i in 0...(lblHeaders.count - 1) {
            height += Test(heightForView(lblValues[i], 0) + 5, heightForView(lblHeaders[i], 0) + 5)
        }
        return height + 90
    }
    
    private func getValueString(Type: String, Tag: Int, Data:[String: Any] ) -> String {
        if Type.lowercased() == "terminate" {
            if Tag == 6 {
                return "\(Data["total_volume_bbl"] as? String ?? "-") BBL \(Data["total_volume_ton"] as? String ?? "-") MT"
            }
            if Tag == 7 {
                return "\(Data["settlement_amount"] as? String ?? "-") $"
            }
        } else if Type.lowercased() == "restructure" {
            if Tag == 7 {
                return "\(Data["total_volume_bbl"] as? String ?? "-") BBL \(Data["total_volume_ton"] as? String ?? "-") MT"
            }
            if Tag == 8 {
                return "\(Data["settlement_amount"] as? String ?? "-") $"
            }
        } else {
            if Tag == 5 {
                return "\(Data["total_volume_bbl"] as? String ?? "-") BBL \(Data["total_volume_ton"] as? String ?? "-") MT"
            }
            if Tag == 6 {
                return "\(Data["settlement_amount"] as? String ?? "-") $"
            }
        }
        return Data[self.getSettKey(Type: Type, Line: Tag)] as? String ?? "-"
    }

    private func setText(Tag: Int, Header: String, Value: String, Type: String) {
        var tmpValue = Value
        if Header == "" {
            tmpValue = ""
        }
        for item in lblHeaders where item.tag == Tag {
            item.text = Header
        }
        for item in lblValues where item.tag == Tag {
            item.text = ""
            if Type.lowercased() == "terminate" {
                if Tag == 6 {
                    item.attributedText = changeNumberText(Text: tmpValue, Color: UIColor.blue, Color2: UIColor.blue)
                } else if Tag == 7 {
                    item.attributedText = changeNumberText(Text: tmpValue, Color: UIColor.red, Color2: UIColor.init(red: 94 / 255, green: 182 / 255, blue: 106 / 255, alpha: 1))
                } else {
                    item.text = tmpValue
                }
            } else if Type.lowercased() == "restructure" {
                item.text = tmpValue
                if Tag == 8 {
                    item.text = tmpValue
                    var tmp = Value.replacingOccurrences(of: ",", with: "")
                    tmp = tmp.replacingOccurrences(of: "$", with: "")
                    tmp = tmp.trimmingCharacters(in: .whitespacesAndNewlines)
                    if let tmpNumber = NumberFormatter().number(from: tmp) {
                        if tmpNumber.doubleValue >= 0 {
                            item.textColor = UIColor(red: 32 / 255, green: 179 / 255, blue: 57 / 255, alpha: 1)
                        } else {
                            item.textColor = UIColor.red
                        }
                    }
                }
                if Tag == 7 {
                    item.text = ""
                    item.attributedText = changeNumberText(Text: tmpValue, Color: UIColor.blue, Color2: UIColor.blue)
                }
            } else {
                if Tag == 5 {
                    item.attributedText = changeNumberText(Text: tmpValue, Color: UIColor.blue, Color2: UIColor.blue)
                } else if Tag == 6 {
                    item.attributedText = changeNumberText(Text: tmpValue, Color: UIColor.red, Color2: UIColor.init(red: 94 / 255, green: 182 / 255, blue: 106 / 255, alpha: 1))
                } else {
                    item.text = tmpValue
                }
            }
        }
    }
    
    private func changeNumberText(Text: String, Color: UIColor, Color2: UIColor) -> NSAttributedString {
        let resultStr = NSMutableAttributedString.init(string: Text)
        resultStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15), range: NSString.init(string: Text).range(of: Text))
        let arrRawString = Text.split(separator: " ")
        var arrTestString = [String]()
        for item in arrRawString {
            let tmpStr = item.replacingOccurrences(of: ",", with: "")
            if let _ = NumberFormatter().number(from: tmpStr) {
                arrTestString.append(item)
            }
        }
        
        var testText = Text
        if arrTestString.count > 0 {
            for i in 0...(arrTestString.count - 1) {
                let range = NSString.init(string: testText).range(of: arrTestString[i])
                let tmpStr = arrTestString[i].replacingOccurrences(of: ",", with: "")
                if let num = NumberFormatter().number(from: tmpStr) {
                    if CGFloat(truncating: num) >= 0 {
                        resultStr.addAttribute(NSAttributedString.Key.foregroundColor, value: Color2, range: range)
                    } else {
                        resultStr.addAttribute(NSAttributedString.Key.foregroundColor, value: Color, range: range)
                    }
                }
                var replaceText = ""
                for _ in 0...(range.length - 1) {
                    replaceText.append(" ")
                }
                testText = testText.replaceCharactersInRange(range: Range.init(range)!, withString: replaceText)
            }
        }
        return resultStr
    }
    
    private func getSettHeader(Type: String) -> [String] {
        switch Type.lowercased(){
        case "terminate":
            return ["Settlement No.:", "Company :", "Settlement Period :", "Type :", "Counterparty :", "Payment Date :", "Total Volume :", "Net Gain/Loss (USD) :", ""]
        case "restructure":
            return ["Memo Date :", "Document No. :", "Company :", "Settlement Period", "Type", "Counterparty :", "Payment Date :", "Total Volume :", "Net Gain/Loss(USD) :"]
        default:
            return ["Settlement No.:", "Company :", "Settlement Period :", "Type :", "Payment Date :", "Total Volume :", "Net Gain/Loss (USD) :", "", ""]
        }
    }
    private func getSettKey(Type: String, Line: Int) -> String {
        var key = [String]()
        switch Type.lowercased(){
        case "terminate":
            key = ["purchase_no", "company", "settlement_period","frame_type", "counter_party", "payment_date", "", "", ""]
        case "restructure":
            key = ["created_date", "purchase_no", "company", "settlemnet_period", "frame_type", "counter_party", "payment_date", "", "settlement_amount"]
        default:
            key = ["purchase_no", "company", "settlement_period","frame_type", "payment_date", "", "", "", ""]
        }
        return key[Line]
    }
}
*/
