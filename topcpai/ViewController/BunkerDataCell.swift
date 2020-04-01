//
//  BunkerDataCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/28/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//


import Foundation
import UIKit

class BunkerDataCell: BaseDataCell {
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
        log.info("dataaa ======>>>> \(Data)")
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
        
        if  tmpArrAdvanceLoading.count > 0 {
            system = System.Advance_loading
            for item in tmpArrAdvanceLoading {
                appendValue(hd: "Purchase No. :", val: item["alr_row_no"] as? String ?? "-", noValueHide: false)
                appendValue(hd: "Advance For :", val: Data["purchase_no"] as? String ?? "-", noValueHide: false)
                if(item["alr_status"] as? String == "WAITING APPROVE"){
                appendValue(hd: "Status :", val: "WAITING ADVANCE LOADING", noValueHide: false)
                }else{
                appendValue(hd: "Status :", val: item["alr_status"] as? String ?? "", noValueHide: false)
                }
                appendValue(hd: "Vessle :", val: "\(Data["vessel"] as? String ?? "") \(Data["trip_no"] as? String ?? "")", noValueHide: false)
                appendValue(hd: "Grade :", val: BunkerCellUtility.Share.getGrade(data: Data), noValueHide: false)
                appendValue(hd: "Supplier :", val: Data["supplier"] as? String ?? "", noValueHide: false)
                appendValue(hd: "Volume :", val: BunkerCellUtility.Share.getVolume(data: Data), noValueHide: false)
                if type == "VESSEL" {
                    appendValue(hd: "Final Price :", val: BunkerCellUtility.Share.joinUnitPrice(data: Data), noValueHide: false)
                    appendValue(hd: "Total Price :", val: BunkerCellUtility.Share.getTotalPrice(type: type, data: Data), noValueHide: false)
                } else {
                    appendValue(hd: "Final Price :", val: BunkerCellUtility.Share.getTotalPrice(type: type, data: Data), noValueHide: false)
                }
                     
                appendValue(hd: "Location :", val: Data["supplying_location"] as? String ?? "", noValueHide: false)
                appendValue(hd: "Delivery Date :", val: BunkerCellUtility.Share.getDeliverDate(data: Data), noValueHide: false)
                appendValue(hd: "Advance Loading Request Reason :", val: item["alr_request_reson"] as? String ?? "", noValueHide: false)
                appendValue(hd: "Brief :", val: self.getBriefText(def: Data["brief"] as? String ?? "-") , noValueHide: false)
                appendValue(hd: "Requested By :", val: Data["created_by"] as? String ?? "", noValueHide: false)
                makeCellHeight()
            }
    
        }else if tmpArrContractData.count > 0 {
              system = System.Final_contract
                for item in tmpArrContractData {
                    appendValue(hd: "Purchase No. :", val: item["caf_contract_no"] as? String ?? "-", noValueHide: false)
                    appendValue(hd: "Contract For :", val: Data["purchase_no"] as? String ?? "", noValueHide: false)
                    if(item["caf_status"] as? String == "WAITING APPROVE"){
                    appendValue(hd: "Status :", val: "WAITING FINAL CONTRACT", noValueHide: false)
                    }else {
                    appendValue(hd: "Status :", val: item["caf_status"] as? String ?? "", noValueHide: false)
                    }
                    appendValue(hd: "Vessle :", val: "\(Data["vessel"] as? String ?? "") \(Data["trip_no"] as? String ?? "")", noValueHide: false)
                    appendValue(hd: "Grade :", val: BunkerCellUtility.Share.getGrade(data: Data), noValueHide: false)
                    appendValue(hd: "Supplier :", val: Data["supplier"] as? String ?? "", noValueHide: false)
                    appendValue(hd: "Volume :", val: BunkerCellUtility.Share.getVolume(data: Data), noValueHide: false)
                    if type == "VESSEL" {
                        appendValue(hd: "Final Price :", val: BunkerCellUtility.Share.joinUnitPrice(data: Data), noValueHide: false)
                        appendValue(hd: "Total Price :", val: BunkerCellUtility.Share.getTotalPrice(type: type, data: Data), noValueHide: false)
                    } else {
                        appendValue(hd: "Final Price :", val: BunkerCellUtility.Share.getTotalPrice(type: type, data: Data), noValueHide: false)
                    }
                         
                    appendValue(hd: "Location :", val: Data["supplying_location"] as? String ?? "", noValueHide: false)
                    appendValue(hd: "Delivery Date :", val: BunkerCellUtility.Share.getDeliverDate(data: Data), noValueHide: false)
                    appendValue(hd: "Final Contract Documents :", val: item["caf_final_documents"] as? String ?? "-", noValueHide: false)
                    appendValue(hd: "Brief :", val: self.getBriefText(def: Data["brief"] as? String ?? "-") , noValueHide: false)
                    appendValue(hd: "Requested By :", val: Data["created_by"] as? String ?? "", noValueHide: false)
                    makeCellHeight()
                }
            }else {
              appendValue(hd: "Purchase No. :", val: Data["purchase_no"] as? String ?? "", noValueHide: false)
              appendValue(hd: "Status :", val: Data["status"] as? String ?? "", noValueHide: false)
              appendValue(hd: "Vessle :", val: "\(Data["vessel"] as? String ?? "") \(Data["trip_no"] as? String ?? "")", noValueHide: false)
              appendValue(hd: "Grade :", val: BunkerCellUtility.Share.getGrade(data: Data), noValueHide: false)
              appendValue(hd: "Supplier :", val: Data["supplier"] as? String ?? "", noValueHide: false)
              appendValue(hd: "Volume :", val: BunkerCellUtility.Share.getVolume(data: Data), noValueHide: false)
              if type == "VESSEL" {
                  appendValue(hd: "Final Price :", val: BunkerCellUtility.Share.joinUnitPrice(data: Data), noValueHide: false)
                  appendValue(hd: "Total Price :", val: BunkerCellUtility.Share.getTotalPrice(type: type, data: Data), noValueHide: false)
              } else {
                  appendValue(hd: "Final Price :", val: BunkerCellUtility.Share.getTotalPrice(type: type, data: Data), noValueHide: false)
              }
            
              appendValue(hd: "Location :", val: Data["supplying_location"] as? String ?? "", noValueHide: false)
              appendValue(hd: "Delivery Date :", val: BunkerCellUtility.Share.getDeliverDate(data: Data), noValueHide: false)
              
              appendValue(hd: "Brief :", val: self.getBriefText(def: Data["brief"] as? String ?? "-") , noValueHide: false)
              appendValue(hd: "Requested By :", val: Data["create_by"] as? String ?? "", noValueHide: false)
              makeCellHeight()
        }
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

extension BunkerDataCell: UITableViewDelegate, UITableViewDataSource {
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

class BunkerCellUtility: CellUtils {
    static let Share = BunkerCellUtility()
    
    func getTotalPrice(type: String, data: [String: Any]) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 4
        
        let totalPrice = Float(Encryptor.decryptWithRSA(cipherText: data["final_price"] as? String ?? ""))
        if totalPrice != nil {
            if type == "CRUDE" {
                return numberFormatter.string(from: NSNumber(value: totalPrice!))! + " \(data["currency_symbol"]!)/MT"
            } else {
                return numberFormatter.string(from: NSNumber(value: totalPrice!))! + " \(data["currency_symbol"]!)"
            }
        } else if String(describing: totalPrice) != "" {
            let tmpStr = data["final_price"] as? String ?? ""
            if tmpStr.count > 0 {
                if type == "CRUDE" {
                    return tmpStr + " \(data["currency_symbol"]!)/MT"
                } else {
                    return tmpStr + " \(data["currency_symbol"]!)"
                }
            } else {
                return String(describing: totalPrice) + " \(data["currency_symbol"]!)"
            }
        }
        return "-"
    }
    
    func joinUnitPrice(data: [String: Any]) -> String {
        let unitPriceStr = data["unit_price_value"] as? String ?? "-"
        //let currencyStr = data["currency_symbol"] as? String ?? "-"
        let unitPriceArray = unitPriceStr.split(separator: "|").dropLast()
        var arrTmp = [String]()
        for item in unitPriceArray {
            arrTmp.append("\(item)/MT")
        }
        let joinedUnitPrice = arrTmp.joined(separator: " and ")
        return joinedUnitPrice
    }
    
    func getGrade(data: [String: Any]) -> String {
        let products = data["products"] as? String ?? ""
        let newproduct =  products.split(separator: "|").dropLast()
        var tmpLbl = ""
        if newproduct.count > 0 {
            for i in 0...newproduct.count - 1 {
                if i == 0 {
                    tmpLbl = newproduct[i]
                } else {
                    tmpLbl = tmpLbl + " and " + (newproduct[i])
                }
            }
        } else {
            tmpLbl = "-"
        }
        return tmpLbl
    }
    
    func getVolume(data: [String: Any]) -> String {
        let volumns = data["volumes"] as? String ?? ""
        let newvolumn = volumns.split(separator: "|").dropLast()
        var tmpLblVol = ""
        if  newvolumn.count > 0 {
            for i in 0...newvolumn.count - 1 {
                if i == 0 {
                    tmpLblVol = newvolumn[i] + " MT"
                } else {
                    tmpLblVol = tmpLblVol + "and " + newvolumn[i] + " MT"
                }
            }
        }
        return tmpLblVol
    }
    
    func getDeliverDate(data: [String: Any]) -> String {
        let deliveryDateFrom: String = shortMonthDateFormatter(dateStr: data["delivery_date_from"] as? String ?? "")
        let deliveryDateTo: String = shortMonthDateFormatter(dateStr: data["delivery_date_to"] as? String ?? "")
        let txtDelivary = deliveryDateFrom + " to " + deliveryDateTo
        return txtDelivary
    }
}
/*
 import Foundation
 import UIKit
 
 class BunkerDataCell: BaseDataCell {
 @IBOutlet weak var btnCollection: UICollectionView!
 @IBOutlet weak var imgArrow: UIImageView!
 @IBOutlet weak var lblDate: UILabel!
 @IBOutlet weak var lblMonth: UILabel!
 
 @IBOutlet weak var lblPurchaseNo: UILabel!
 @IBOutlet weak var lblVessel: UILabel!
 @IBOutlet weak var lblGrade: UILabel!
 @IBOutlet weak var lblSupplier: UILabel!
 @IBOutlet weak var lblVolumn: UILabel!
 @IBOutlet weak var lblHeaderFinalPrice: UILabel!
 @IBOutlet weak var lblFinalPrice: UILabel!
 @IBOutlet weak var lblTotalPriceHeader: UILabel!
 @IBOutlet weak var lblTotalPrice: UILabel!
 @IBOutlet weak var lblLocation: UILabel!
 @IBOutlet weak var lblDeliveryDate: UILabel!
 @IBOutlet weak var lblRequesterBy: UILabel!
 
 var searchActive: Bool = false
 
 override func awakeFromNib() {
 super.awakeFromNib()
 selectionStyle = .none
 btnCollection.register(UINib.init(nibName: "CrudeButtonCell", bundle: nil), forCellWithReuseIdentifier: "btncell")
 }
 func setCell(data: [String: String], isExpand: Bool) -> CGFloat {
 let dateFormatter: DateFormatter = DateFormatter()
 dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
 let months = dateFormatter.shortMonthSymbols
 
 type = data["type"]!
 transaction_id = data["transaction_id"]!
 req_txn_id = data["req_transaction_id"]!
 system = data["system"] ?? ""
 let numberFormatter = NumberFormatter()
 numberFormatter.numberStyle = NumberFormatter.Style.decimal
 numberFormatter.minimumFractionDigits = 0
 numberFormatter.maximumFractionDigits = 4
 
 let date: String =  data["date_purchase"]!
 let dateArray = date.split(separator: "/")
 lblDate.attributedText = NSAttributedString(string: dateArray[0], attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
 lblMonth.text = months?[Int(dateArray[1])! - 1]
 
 lblPurchaseNo.text = data["purchase_no"]
 lblVessel.text = "\(data["vessel"]!) \(data["trip_no"]!)"
 lblSupplier.text = data["supplier"]
 
 let deliveryDateFrom: String = shortMonthDateFormatter(dateStr: data["delivery_date_from"]!)
 let deliveryDateTo: String = shortMonthDateFormatter(dateStr: data["delivery_date_to"]!)
 lblDeliveryDate.text = deliveryDateFrom + " to " + deliveryDateTo
 let products = data["products"]
 let newproduct =  products?.split(separator: "|")
 for i in 0..<(newproduct?.count)! - 1 {
 if i == 0 {
 lblGrade.text = newproduct?[i]
 } else {
 lblGrade.text = lblGrade.text! + " and " + (newproduct?[i])!
 }
 }
 let volumns = data["volumes"]
 let newvolumn = volumns?.split(separator: "|")
 for i in 0..<(newvolumn?.count)! - 1 {
 if i == 0 {
 lblVolumn.text = (newvolumn?[i])! + " MT"
 } else {
 lblVolumn.text = lblVolumn.text! + "and " + (newvolumn?[i])! + " MT"
 }
 }
 lblLocation.text = data["supplying_location"]
 lblRequesterBy.text = data["create_by"]
 lblFinalPrice.text = self.joinUnitPrice(unitPriceStr: data["unit_price_value"]!, currencyStr: data["currency_symbol"]!)
 
 let totalPrice = Float(Encryptor.decryptWithRSA(cipherText: data["final_price"]!))
 lblTotalPrice.text = "-"
 if totalPrice != nil {
 if type == "CRUDE" {
 lblTotalPrice.text = numberFormatter.string(from: NSNumber(value: totalPrice!))! + " \(data["currency_symbol"]!)/MT"
 } else {
 lblTotalPrice.text = numberFormatter.string(from: NSNumber(value: totalPrice!))! + " \(data["currency_symbol"]!)"
 }
 } else if String(describing: totalPrice) != "" {
 let tmpStr = data["final_price"]!
 if tmpStr.length > 0 {
 if type == "CRUDE" {
 lblTotalPrice.text = tmpStr + " \(data["currency_symbol"]!)/MT"
 } else {
 lblTotalPrice.text = tmpStr + " \(data["currency_symbol"]!)"
 }
 } else {
 lblTotalPrice.text = String(describing: totalPrice) + " \(data["currency_symbol"]!)"
 }
 }
 
 if !searchActive {
 if type == "VESSEL" {
 lblTotalPriceHeader.text = "Total Price :"
 lblHeaderFinalPrice.text = "Final Price :"
 } else {
 lblTotalPriceHeader.text = "Final Price :"
 lblHeaderFinalPrice.text = ""
 lblFinalPrice.text = ""
 }
 }
 layoutIfNeeded()
 if isExpand {
 self.lblFinalPrice.isHidden = false
 self.lblHeaderFinalPrice.isHidden = false
 self.backgroundColor = UIColor(red: 237.0/255.0, green: 238.0/255.0, blue: 239.0/255.0, alpha: 1.0)
 self.imgArrow.image = UIImage.init(named: "Rectangle02")
 return btnCollection.frame.origin.y + 70
 } else {
 self.lblFinalPrice.isHidden = true
 self.lblHeaderFinalPrice.isHidden = true
 self.backgroundColor = UIColor.white
 self.imgArrow.image = UIImage.init(named: "Rectangle01")
 return lblVolumn.frame.origin.y + lblVolumn.frame.size.height + 9
 }
 }
 
 func joinUnitPrice(unitPriceStr: String, currencyStr: String) -> String{
 let unitPriceArray = unitPriceStr.split(separator: "|").dropLast()
 var arrTmp = [String]()
 for item in unitPriceArray {
 arrTmp.append("\(item)/MT")
 }
 let joinedUnitPrice = arrTmp.joined(separator: " and ")
 return joinedUnitPrice
 }
 }
 */
