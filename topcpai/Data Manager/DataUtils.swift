//
//  DataUtils.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 3/4/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import AEXML

class DataUtils {
    static let shared = DataUtils()
    
    func getSortedByDateData(inputArr: [[String: Any]]) -> [[String: Any]] {
        var tmpArr = inputArr
        tmpArr.sort(by: { (s1: [String: Any], s2: [String: Any]) -> Bool in
            let s1_date = getSortDate(s1)
            let s2_date = getSortDate(s2)
            if s1_date != s2_date {
                return s2_date < s1_date
            } else {
                return getSortPurchaseNo(s2) < getSortPurchaseNo(s1)
            }
        })
        return tmpArr
    }
    
   func SysName(_ Name: String) -> String {
        if Name.lowercased() == "product_sale" || Name.lowercased() == "product_purchase" {
            return System.Product
        }
        return Name
    }
    
    private func getSortDate(_ data: [String: Any]) -> Date {
        let system = data["system"] as? String ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        switch system {
        case System.Crude_O:
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.date(from: data["date_purchase"] as? String ?? "")!
        case System.Hedge_tckt:
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.date(from: data["ticket_date"] as? String ?? "")!
        case System.Hedge_Bot:
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.date(from: data["bot_created_date"] as? String ?? "")!
        case System.Hedge_sett:
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.date(from: data["created_date"] as? String ?? "")!
        case System.Demurrage:
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
            return dateFormatter.date(from: data["created_date"] as? String ?? "")!
        case System.Product:
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.date(from: data["doc_date"] as? String ?? "")!
        case System.VCool:
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let arrString = (data["date_purchase"] as? String ?? "").split(separator: " ")
            return dateFormatter.date(from: arrString[0]) ?? Date()
        case System.Crude:
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.date(from: data["date_purchase"] as? String ?? "")!
        case System.Bunker:
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.date(from: data["date_purchase"] as? String ?? "")!
        case System.Chartering:
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.date(from: data["date_purchase"] as? String ?? "")!
        default:
            if (data["doc_date"] as? String) != nil {
                dateFormatter.dateFormat = "dd/MM/yyyy"
                return dateFormatter.date(from: data["doc_date"] as? String ?? "")!
            }
            dateFormatter.dateFormat = "dd/MM/yyyy"
            if let rDate = dateFormatter.date(from: data["date_purchase"] as? String ?? "") {
                return rDate
            }
            return Date()
        }
    }
    
    private func getSortPurchaseNo(_ data: [String: Any]) -> String {
        let system = data["system"] as? String ?? ""
        switch system {
        case System.Crude_O:
            return data["doc_no"] as? String ?? ""
        case System.Hedge_tckt:
            return data["ticket_no"] as? String ?? ""
        case System.Hedge_sett:
            return data["purchase_no"] as? String ?? ""
        case System.Hedge_Bot:
            return data["purchase_no"] as? String ?? ""
        case System.Demurrage:
            return data["purchase_no"] as? String ?? ""
        case System.Product:
            return data["doc_no"] as? String ?? ""
        case System.VCool:
            return data["purchase_no"] as? String ?? ""
        case System.Crude:
            return data["purchase_no"] as? String ?? ""
        case System.Bunker:
            return data["purchase_no"] as? String ?? ""
        case System.Chartering:
            return data["purchase_no"] as? String ?? ""
        default:
            if data["doc_no"] as? String != nil {
                return data["doc_no"] as? String ?? ""
            }
            return data["purchase_no"] as? String ?? ""
        }
    }
    
    private func getPropertiesFromDict(data: [String: Any]) -> [String] {
        let sys = data["system"] as? String ?? ""
        switch sys {
        case System.Crude:
            return Crude().propertyNames()
        case System.Chartering:
            return ["date_purchase", "purchase_no", "vessel", "cust_name", "owner", "laycan_from", "laycan_to", "final_price", "exten_cost", "est_freight", "create_by", "broker_name","broker_id", "charterer_name"]
        case System.Bunker:
            return Bunker().propertyNames()
        case System.Crude_O:
            return Crude_O().propertyNames()
        case System.Hedge_sett:
            return HedgeSett().propertyNames()
        case System.Hedge_tckt:
            return HedgeTckt().propertyNames()
        case System.Hedge_Bot:
            return HedgeBot().propertyNames()
        case System.Demurrage:
            return Demurrage().propertyNames()
        case System.Product:
            return Product().propertyNames()
        default:
            return Product().propertyNames()
        }
    }
    
    private func getFilterResultFromArrString(objProperties: [String], data:[String: Any], text: String) -> Bool {
        if text == "" {
            return true
        }
        for key in objProperties {
            if let value = data[key] as? String {
                //crude & chartering & bunker
                if key == "laycan_from" || key == "laycan_to" || key == "deliver_date_from" || key == "deliver_date_to" {
                    let newValue = shortMonthDateFormatter(dateStr: data[key]! as! String)
                    if newValue.lowercased().contains(text.lowercased()) {
                        return true
                    }
                }
                //Product subkey
                if key == "list_awarded" {
                    let subkey = ["premium_discount", "incoterm", "quantity", "customer", "benchmark", "price", "product", "freight"]
                    if getFilterResultFromArrString(objProperties: subkey, data: data, text: text) {
                        return true
                    }
                }
                if key == "list_customer_reviews" {
                    let subkey = ["quantity", "customer", "tier", "price", "product"]
                    if getFilterResultFromArrString(objProperties: subkey, data: data, text: text) {
                        return true
                    }
                }
                if key == "list_bitumen_summary" {
                    let subkey = ["quantity", "customer", "tier", "price", "selling_price_diff_hsfo", "selling_price_diff_argus"]
                    if getFilterResultFromArrString(objProperties: subkey, data: data, text: text) {
                        return true
                    }
                }
                // Every key
                if value.lowercased().contains(text.lowercased()) {
                    return true
                }
            }
        }
        return false
    }
    
    func getFilterResult(data: [String: Any], text: String) -> Bool {
        var objProperties: [String] = getPropertiesFromDict(data: data)
        if let index = objProperties.firstIndex(of: "transaction_id") {
            objProperties.remove(at: index)
        }
        if let index = objProperties.firstIndex(of: "status") {
            objProperties.remove(at: index)
        }
        if let index = objProperties.firstIndex(of: "type") {
            objProperties.remove(at: index)
        }
        if let index = objProperties.firstIndex(of: "function_id") {
            objProperties.remove(at: index)
        }
        return getFilterResultFromArrString(objProperties: objProperties, data: data, text: text)
    }
    
    private func shortMonthDateFormatter(dateStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.dateFormat = "dd-MMM-yyy"
            return dateFormatter.string(from: (date))
        }
        return dateStr
    }
    
    func getStatusString(_ statusArr: [String]) -> String {
        var status = ""
        if statusArr.count == 0 {
            return ""
        }
        for i in 0...(statusArr.count - 1){
            if i == 0{
                status = "\(statusArr[i])"
            }else{
                status = "\(status)|\(statusArr[i])"
            }
        }
        return status
    }
    
    private func replaceUnescapeString(text: String) -> String {
        var newText = text
        newText = newText.replacingOccurrences(of: "&quot;", with: "\"")
        newText = newText.replacingOccurrences(of: "&#x27;", with: "'")
        newText = newText.replacingOccurrences(of: "&#x92;", with: "'")
        newText = newText.replacingOccurrences(of: "&#x96;", with: "-")
        newText = newText.replacingOccurrences(of: "&gt;", with: ">")
        newText = newText.replacingOccurrences(of: "&lt;", with: "<")
        newText = newText.replacingOccurrences(of: "&amp;", with: "&")
        return newText
    }
    
    private func replaceUnescapeButtonString(text: String) -> String {
        var newText = text
        newText = newText.replacingOccurrences(of: "&gt;", with: ">")
        newText = newText.replacingOccurrences(of: "&lt;", with: "<")
        newText = newText.replacingOccurrences(of: "&amp;", with: "&")
        return newText
    }
    
    private func setupXMLFromString(text: String) -> AEXMLDocument? {
        do {
            let xmlObj = try AEXMLDocument(xml: text)
            return xmlObj
        } catch let xmlError as NSError {
            // Handle Data Error
            log.error("create xml document failed \(xmlError)")
        }
        return nil
    }
    
    func  getDataDictFromXMLDoc(system: String, xmlDoc: AEXMLDocument?, all: Bool) -> [String: Any] {
        if xmlDoc == nil {
            return [:]
        }
        let xmlDoc = xmlDoc!
        let availableData = xmlDoc.root["extra_xml"].xmlCompact
        let dataString = self.replaceUnescapeString(text: availableData)
        if !dataString.contains("list_trx") {
            return getDataDictFromXMLPaf(System: system, Model: Product(), xmlDoc: xmlDoc, all: all)
        }
        //Normal way
        let decodedDataXML = self.setupXMLFromString(text: dataString)!.root["list_trx"].children
        var dataArray = [[String: Any]]()
        for data in decodedDataXML {
            let transDict = getDataItemFromDecodeXML(data, all)
            dataArray.append(transDict)
        }
        let dict = [system: dataArray] as [String: Any]
           log.info("data dict \(dict)")
        return dict
    }
    
    private func getDataItemFromDecodeXML(_ data: AEXMLElement, _ all: Bool) -> [String: Any] {
        var sys = data.attributes["system"] ?? "" //Json Value
        if sys == "" { //XML Value
            for item in data.children where item.name == "system" {
                sys = item.value ?? ""
            }
        }
        if sys.lowercased().contains("product") {
            sys = System.Product
        }
        
        switch sys {
        case System.Product:
            return getDataItemPaf(Model: Product(), data: data, all: all)
        case System.VCool:
            return getDataItem(Model: VCool(), data: data, all: all)
        case System.Crude:
            return getDataItem(Model: Crude(), data: data, all: all)
        case System.Chartering:
            return getDataItem(Model: Chartering(), data: data, all: all)
        case System.Bunker:
            return getDataItem(Model: Bunker(), data: data, all: all)
        case System.Crude_O:
            return getDataItemCDS(Model: Crude_O(), data: data, all: all)
        case System.Hedge_sett:
            return getDataItem(Model: HedgeSett(), data: data, all: all)
        case System.Hedge_tckt:
            return getDataItem(Model: HedgeTckt(), data: data, all: all)
        case System.Hedge_Bot:
            return getDataItem(Model: HedgeBot(), data: data, all: all)
        case System.Demurrage:
            return getDataItemDem(Model: Demurrage(), data: data, all: all)
        default:
            return [:]
        }
    }
    
    private func getDataItem(Model: PropertyNames, data: AEXMLElement, all: Bool) -> [String: Any] {
        
        var transDict = [String: Any]()
        var tmpArrAdvanceLoading = [[String: Any]]()
        var tmpArrContractData = [[String: Any]]()
        if all {
            for key in Model.propertyNames() {
                var notFound: Bool = true
                for item in data.children where item.name == key {
                    notFound = false
                    if key == "reopt_transaction" {
                        transDict[key] = getDataItemCDS(Model: Crude_O(), data: item, all: all)
                    } else {
                        if item.value == "" {
                            transDict[key] = "-"
                        } else {
                            transDict[key] = item.value
                        }
                    }
                }
                if notFound {
                    transDict[key] = "-"
                }
            }
            return transDict
        }
        for item in data.children where item.name == "reopt_transaction" {
            let temp = getDataItemCDS(Model: Crude_O(), data: item, all: all)
            transDict["reopt_transaction"] = temp
        }
        
        for item in data.children where item.name == "advance_loading_request_data" {
            var tmpObj = [String: Any]()
            for obj in item.children {
              tmpObj[obj.name] = obj.value ?? "-"
          }
              tmpArrAdvanceLoading.append(tmpObj)
            
        }
        
        for item in data.children where item.name == "contract_data" {
            var tmpObj = [String: Any]()
            for obj in item.children {
                tmpObj[obj.name] = obj.value ?? "-"
            }
            tmpArrContractData.append(tmpObj)
        }
        
        
        for key in Model.propertyNames() {
            var value = data.attributes[key] ?? "-"
            if value.length == 0 {
                value = "-"
            }
            transDict[key] = value
            if tmpArrAdvanceLoading.count > 0 {
//              log.info("data ======>>>>RRRRRRRR")
              transDict["advance_loading_request_data"] = tmpArrAdvanceLoading
          }
            if tmpArrContractData.count > 0 {
//              log.info("data ======>>>>HHHHHHHHH")
              transDict["contract_data"] = tmpArrContractData
           }
        }
//         log.info("data ======>>>>QQQQQQQ\(transDict)")
        return transDict
    }
    
    private func getDataItemDem(Model: PropertyNames, data: AEXMLElement, all: Bool) -> [String: Any] {
        var transDict = [String: Any]()
        if all {
            for key in Model.propertyNames() {
                for item in data.children where item.name == key {
                    if item.value == "" {
                        transDict[key] = "-"
                    } else {
                        transDict[key] = item.value
                    }
                }
            }
            return transDict
        }
        for dataChild in data.children {
            for key in Model.propertyNames() {
                if dataChild.name == key {
                    let value = dataChild.value ?? "-"
                    transDict[key] = value
                }
            }
        }
        return transDict
    }
    
    private func getDataItemCDS(Model: PropertyNames, data: AEXMLElement, all: Bool) -> [String: Any] {
        var transDict = [String: Any]()
        for dataChild in data.children {
            for key in Model.propertyNames() {
                if dataChild.name == key {
                    let value = dataChild.value ?? "-"
                    transDict[key] = value
                    if key == "list_cdph" {
                        var tempDict = [[String: Any]]()
                        for item in dataChild.children {
                            var tmp = [String: Any]()
                            tmp["cdph_crude"] = item.attributes["cdph_crude"]
                            tmp["cdph_supplier"] = item.attributes["cdph_supplier"] ?? "-"
                            tmp["cdph_quantity"] = item.attributes["cdph_quantity"] ?? "-"
                            tmp["cdph_incoterm"] = item.attributes["cdph_incoterm"] ?? "-"
                            tmp["cdph_price"] = item.attributes["cdph_price"] ?? "-"
                            tmp["cdph_pricing_prd"] = item.attributes["cdph_pricing_prd"] ?? "-"
                            tempDict.append(tmp)
                        }
                        transDict[key] = tempDict
                    } else if key == "list_awarded" {
                        var tempDict = [[String: Any]]()
                        for item in dataChild.children {
                            var tmp = [String: Any]()
                            tmp["awarded_title"] = item.attributes["awarded_title"] ?? "-"
                            tmp["awarded_customer"] = item.attributes["awarded_customer"] ?? "-"
                            tmp["awarded_loading_prd"] = item.attributes["awarded_loading_prd"] ?? "-"
                            tmp["awarded_incoterm"] = item.attributes["awarded_incoterm"] ?? "-"
                            tmp["awarded_pricing_prd"] = item.attributes["awarded_pricing_prd"] ?? "-"
                            tmp["awarded_title"] = item.attributes["awarded_title"] ?? "-"
                            tmp["awarded_quantity"] = item.attributes["awarded_quantity"] ?? "-"
                            tmp["awarded_discharging_prd"] = item.attributes["awarded_discharging_prd"] ?? "-"
                            tmp["awarded_contract_prd"] = item.attributes["awarded_contract_prd"] ?? "-"
                            tmp["awarded_crude"] = item.attributes["awarded_crude"] ?? "-"
                            tmp["awarded_market_price"] = item.attributes["awarded_market_price"] ?? "-"
                            tmp["awarded_price"] = item.attributes["awarded_price"] ?? "-"
                            tmp["awarded_benefit_purchasing"] = item.attributes["awarded_benefit_purchasing"] ?? "-"
                            tempDict.append(tmp)
                        }
                        transDict[key] = tempDict
                    } else if key == "list_reopt" {
                        var tempDict = [[String: Any]]()
                        for item in dataChild.children {
                            var tmp = [String: Any]()
                            tmp["reopt_title"] = item.attributes["reopt_title"] ?? "-"
                            tmp["reopt_crude"] = item.attributes["reopt_crude"] ?? "-"
                            tmp["reopt_supplier"] = item.attributes["reopt_supplier"] ?? "-"
                            tmp["reopt_quantity"] = item.attributes["reopt_quantity"] ?? "-"
                            tmp["reopt_incoterm"] = item.attributes["reopt_incoterm"] ?? "-"
                            tmp["reopt_price"] = item.attributes["reopt_price"] ?? "-"
                            tmp["reopt_market_price"] = item.attributes["reopt_market_price"] ?? "-"
                            tmp["reopt_lpmax_price"] = item.attributes["reopt_lpmax_price"] ?? "-"
                            tmp["reopt_benefit_purchasing"] = item.attributes["reopt_benefit_purchasing"] ?? "-"
                            tmp["reopt_loading_prd"] = item.attributes["reopt_loading_prd"] ?? "-"
                            tmp["reopt_discharging_prd"] = item.attributes["reopt_discharging_prd"] ?? "-"
                            tempDict.append(tmp)
                        }
                        transDict[key] = tempDict
                    } else {
                        let value = dataChild.value ?? "-"
                        transDict[key] = value
                    }
                }
            }
        }
        return transDict
    }
    
    
    
    private func getDataItemPaf(Model: PropertyNames, data: AEXMLElement, all: Bool) -> [String: Any] {
        if !all {
            return [:]
        }
        var transDict = [String: Any]()
        var tmpArrAwarded = [[String: Any]]()
        var tmpArrAdvanceLoading = [[String: Any]]()
        var tmpArrContractData = [[String: Any]]()
        for key in Model.propertyNames() {
            for item in data.children where item.name == key {
                if key == "awaeded" {
                    var tmpObj = [String: Any]()
                    for obj in item.children {
                        if obj.name == "awarded_up_tier" {
                            var tmpArr = [[String: Any]]()
                            let tmpDic = obj.attributes
                            for item in tmpDic {
                                var t = [String: Any]()
                                t[item.key] = item.value
                                tmpArr.append(t)
                            }
                            tmpObj[obj.name] = tmpArr
                        } else {
                            tmpObj[obj.name] = obj.value ?? "-"
                        }
                    }
                    tmpArrAwarded.append(tmpObj)
                } else if item.value == "" {
                    transDict[key] = "-"
                } else {
                    transDict[key] = item.value
                }
                
                if key == "advance_loading_request_data" {
                    var tmpObj = [String: Any]()
                    for obj in item.children {
                        tmpObj[obj.name] = obj.value ?? "-"
                    }
                    tmpArrAdvanceLoading.append(tmpObj)
                }
                
                if key == "contract_data" {
                    var tmpObj = [String: Any]()
                    for obj in item.children {
                        tmpObj[obj.name] = obj.value ?? "-"
                    }
                    tmpArrContractData.append(tmpObj)
                }
            }
            
            if tmpArrAwarded.count > 0 {
                transDict["awaeded"] = tmpArrAwarded
            }
            if tmpArrAdvanceLoading.count > 0 {
                transDict["advance_loading_request_data"] = tmpArrAdvanceLoading
            }
            if tmpArrContractData.count > 0 {
                transDict["contract_data"] = tmpArrContractData
            }
        }
        return transDict
    }
    
    private func getDataItemPafFromDict(Model: PropertyNames, data: [String: Any], all: Bool) -> [String: Any] {
        var transDict = [String: Any]()
        for key in Model.propertyNames() {
            let value = data[key] as? String ?? "-"
            transDict[key] = value
            if key == "awaeded" && data[key] as? [Any] != nil {
                var tempDict = [[String: Any]]()
                let arrSubkey = Product_Award().propertyNames()
                for subItem in (data[key] as! [Any]) where subItem as? [String: Any] != nil {
                    var tmp = [String: Any]()
                    for subKey in arrSubkey {
                        if subKey == "awarded_up_tier" {
                            var tempDict2 = [[String: Any]]()
                            if let tempAwardUpTier = ((subItem as! [String: Any])[subKey] as? [[String: Any]]) {
                                for item2 in tempAwardUpTier {
                                    var tmpItem2 = [String: Any]()
                                    tmpItem2["awarded_tier_quantity"] = item2["awarded_tier_quantity"] as? String ?? "-"
                                    tmpItem2["awarded_tier_price"] = item2["awarded_tier_price"] as? String ?? "-"
                                    tempDict2.append(tmpItem2)
                                }
                                tmp[subKey] = tempDict2
                            }
                        } else {
                            let value = (subItem as! [String: Any])[subKey] as? String ?? "-"
                            tmp[subKey] = value
                        }
                    }
                    tempDict.append(tmp)
                }
                transDict[key] = tempDict
            }
            
            if key == "advance_loading_request_data" && data[key] as? [Any] != nil {
                var tempDict = [[String: Any]]()
                let arrSubkey = Advance_loading().propertyNames()
                for subItem in (data[key] as! [Any]) where subItem as? [String: Any] != nil {
                    var tmp = [String: Any]()
                    for subKey in arrSubkey {
                        let value = (subItem as! [String: Any])[subKey] as? String ?? "-"
                        tmp[subKey] = value
                    }
                    tempDict.append(tmp)
                }
                transDict[key] = tempDict
            }
            
            if key == "contract_data" && data[key] as? [Any] != nil {
                var tempDict = [[String: Any]]()
                let arrSubkey = Contract_Data().propertyNames()
                for subItem in (data[key] as! [Any]) where subItem as? [String: Any] != nil {
                    var tmp = [String: Any]()
                    for subKey in arrSubkey {
                        let value = (subItem as! [String: Any])[subKey] as? String ?? "-"
                        tmp[subKey] = value
                    }
                    tempDict.append(tmp)
                }
                transDict[key] = tempDict
            }
            
        }
        return transDict
    }
    
    private func getDataDicFromXMLHedge(System: String, Model: PropertyNames, xmlDoc: AEXMLDocument?, all: Bool) -> [String: Any] {
        let xmlDoc = xmlDoc!
        log.debug("\(xmlDoc.xml)")
        let objProperties = Model.propertyNames()
        
        let availableData = xmlDoc.root["extra_xml"].xmlCompact
        let dataString = self.replaceUnescapeString(text: availableData)
        let decodedDataXML = self.setupXMLFromString(text: dataString)!.root["list_trx"].children
        var dataArray = [[String: String]]()
        for data in decodedDataXML {
            
            var transDict = [String: String]()
            
            for key in objProperties {
                // Assign string to value, if not string cast to string
                var value = data.attributes[key] ?? "-"
                //New
                if value.length == 0 {
                    value = "-"
                }
                transDict[key] = value
            }
            dataArray.append(transDict)
        }
        let dict = [System: dataArray] as [String: Any]
        return dict
    }
    
    private func getDataDictFromXMLPaf(System: String, Model: PropertyNames, xmlDoc: AEXMLDocument?, all: Bool) -> [String: Any] {
        let xmlDoc = xmlDoc!
        let availableData: String = xmlDoc.root["extra_xml"].xmlCompact
        var dataString = self.replaceUnescapeString(text: availableData)
        dataString = dataString.replacingOccurrences(of: "</extra_xml>", with: "")
        dataString = dataString.replacingOccurrences(of: "<extra_xml>", with: "")
        var dataArray = [[String: Any]]()
        do {
            let data = dataString.data(using: .utf8)
            let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [Any]
            for item in parsedData where item as? [String: Any] != nil {
                let tmp = getDataItemPafFromDict(Model: Product(), data: item as! [String : Any], all: all)
                dataArray.append(tmp)
            }
        } catch {
            
        }
        let dict = [System: dataArray] as [String: Any]
        return dict
    }
    
    func getSortedArrButton(data: [Button]) -> [Button] {
        var tempBtnArr = [Button]()
        for x in data{
            if x.name.lowercased() == "cancel"{
                tempBtnArr.append(x)
            }
        }
        for x in data{
            if x.name.lowercased() == "verified" || x.name.lowercased() == "verify"{
                tempBtnArr.append(x)
            }
        }
        for x in data{
            if x.name.lowercased() == "reject"{
                tempBtnArr.append(x)
            }
        }
        for x in data{
            if x.name.lowercased() == "approve"{
                tempBtnArr.append(x)
            }
        }
        for x in data{
            if x.name.lowercased() != "cancel" &&
                x.name.lowercased() != "verified" &&
                x.name.lowercased() != "verify" &&
                x.name.lowercased() != "reject"  &&
                x.name.lowercased() != "approve"{
                tempBtnArr.append(x)
            }
        }
        return tempBtnArr
    }
    
    func getStringFromDate(date :Date) -> String{
        let df = DateFormatter()
        df.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let tempTimeZone = TimeZone.knownTimeZoneIdentifiers.filter({ (temp) -> Bool in
            temp.lowercased().contains("bangkok")
        })
        df.timeZone = TimeZone.init(identifier: tempTimeZone.first!)
        df.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return df.string(from:date)
    }
    func getDateFromString(date : String) -> Date{
        let df = DateFormatter()
        df.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let tempTimeZone = TimeZone.knownTimeZoneIdentifiers.filter({ (temp) -> Bool in
            temp.lowercased().contains("bangkok")
        })
        df.timeZone = TimeZone.init(identifier: tempTimeZone.first!)
        
        df.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return df.date(from: date)!
    }
    
    func getLast3MonthDate(date : Date) -> Date {
        var calendar = NSCalendar.current
        let tempTimeZone = TimeZone.knownTimeZoneIdentifiers.filter({ (temp) -> Bool in
            temp.lowercased().contains("bangkok")
        }).first!
        calendar.timeZone = TimeZone.init(identifier: tempTimeZone)!
        let comps = NSDateComponents.init()
        comps.month = -3
        //comps.day = -1
        let date = calendar.date(byAdding: comps as DateComponents, to: Date())
        let temp = (getStringFromDate(date: date!)).split(separator: " ")
        let temp2 = temp[0] + " 00:00:00"
        let date2 = getDateFromString(date: temp2)
        //return date!
        return date2
    }
    
    func getLastMonthDate(date: Date) -> Date {
        var calendar = NSCalendar.current
        let tempTimeZone = TimeZone.knownTimeZoneIdentifiers.filter({ (temp) -> Bool in
            temp.lowercased().contains("bangkok")
        }).first!
        calendar.timeZone = TimeZone.init(identifier: tempTimeZone)!
        let comps = NSDateComponents.init()
        comps.month = -1
        //comps.day = -1
        let date = calendar.date(byAdding: comps as DateComponents, to: Date())
        let temp = (getStringFromDate(date: date!)).split(separator: " ")
        let temp2 = temp[0] + " 00:00:00"
        let date2 = getDateFromString(date: temp2)
        //return date!
        return date2
    }
    
    func createSmallImage(_ image : UIImage, width: CGFloat, height: CGFloat) ->UIImage{
        let newSize = CGSize.init(width: width, height:height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect.init(x: 0,
                                   y: 0, width: width, height: height))
        let result : UIImage = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(.alwaysOriginal)
        UIGraphicsEndImageContext()
        return result
    }
}
