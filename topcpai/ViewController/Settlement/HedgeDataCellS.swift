//
//  HedgeDataCellS.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 9/1/2561 BE.
//  Copyright © 2561 PTT ICT Solutions. All rights reserved.
//

import Foundation
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
    }
    
    func setCell(data : [String: Any]){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        
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
        resultStr.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15), range: NSString.init(string: Text).range(of: Text))
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
                        resultStr.addAttribute(NSAttributedStringKey.foregroundColor, value: Color2, range: range)
                    } else {
                        resultStr.addAttribute(NSAttributedStringKey.foregroundColor, value: Color, range: range)
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
