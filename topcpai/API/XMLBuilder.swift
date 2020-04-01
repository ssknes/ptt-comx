//
//  XMLBuilder.swift
//  ICTPocketPay
//

import UIKit
import AEXML

struct functionIds {
    //Login
    static let login         = "F10000003"
    //Crude, Chartering, Bunker
    static let list_transaction         = "F10000004"
    static let get_action_button        = "F10000005"
    static let get_counter_transaction  = "F10000018"
    static let print_pdf                = "F10000019"
    static let dropdown                 = "F10000020"
    static let globalconfig             = "F10000021"
    static let messageControl           = "F10000022"
    
    //Vcool
    static let list_transactio_vcool    = "F10000061"
    static let get_action_button_vcool  = "F10000062"
    static let save_data_evpc           = "F10000063"
    static let save_data_cmvp_scvp      = "F10000064"
    static let save_data_tnvp           = "F10000065"
    //Demurrage
    static let list_transaction_demurrage = "F10000081"
    static let get_action_button_demurrage = "F10000082"
    //Paf
    static let list_transaction_paf     = "F10000045"
    static let get_action_button_paf    = "F10000046"
    static let print_pdf_paf            = "F10000083"
    //Hedge
    static let list_transaction_hedge_tckt = "F10000078"
    static let get_action_button_hedge_tckt = "F10000079"
    static let list_transaction_hedge_sett = "F10000084"
    static let get_action_button_hedge_sett = "F10000085"
    static let save_hedge_tckt = "F10000075"
    static let save_hedge_sett = "F10000086"
    //Crude Sale
    static let list_transaction_crude_o = "F10000091"
    static let get_action_button_crude_o = "F10000092"
    //New Paf
    static let list_transaction_new_paf = "F10000101"
    static let print_pdf_new_paf = "F10000102"
    //All My Task
    static let list_all_my_task = "F10000105"
    //Hedge Bot
    static let list_transaction_hedge_bot = "F10000112"
    static let get_action_button_hedge_bot = "F10000109"
    static let update_status_hedge_bot = "F10000108"
}

class XMLBuilder {
    static let shareInstance = XMLBuilder()
    
    private let dateFormatter: DateFormatter
    private var reqTransactionId: String {        
        let unixTimeStamp = Int(NSDate().timeIntervalSince1970)
        return "\(MyUtilities.randomInt(min: 0, max: 9999999))\(unixTimeStamp)"
    }
    
    /* XML Header */
    private var app_user = ""
    private var app_password = ""
    
    private init() {
        switch GlobalVar.sharedInstance.appMode {
        case WorkMode.DEV:
            app_user = "cpaiios"
            app_password = "ios@132"
            break
        case WorkMode.UAT:
            app_user = "cpaiios"
            app_password = "ios@132"
            break
        case WorkMode.PRD:
            app_user = "cpaiios"
            app_password = "ios@132"
            break
        case WorkMode.PPRD:
            app_user = "cpaiios"
            app_password = "ios@132"
            break
        }
        
        dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        dateFormatter.dateFormat = "ddMMyyHHmmssSS"
    }
    
    func loginRequestXML(userId: String, userPassword: String) -> String {
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        let params = [
            "channel"		: "MOBILE",
            "user"          : userId,
            "password"		: (Encryptor.encryptWithRSA(plain: userPassword)).addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!,
            "user_system"	: "CPAI",
            "user_os"		: "IOS",
            "app_version"	: GlobalVar.sharedInstance.appVersion,
            "user_noti_id"	: CredentialManager.shareInstance.fcmToken
        ]
        let xmlRequest = buildXMLDoc(functionId: functionIds.login, params: params)
        log.debug("Request = \n\(xmlRequest.xml)\n\n\n")
        return xmlRequest.xmlCompact
    }

    //Default
    func listTransactionXML(system: String, data: [String: Any]) -> String {
        let params = getlistTransactionXMLParams(system: system, data: data)
        let funcID = getListTransactionXMLFunctionID(system: system)
        let xmlRequest = buildXMLDoc(functionId: funcID, params: params)
        
        log.debug(xmlRequest.xml)
        return xmlRequest.xmlCompact
    }
    
    private func getListTransactionXMLFunctionID(system: String) -> String {
        switch system {
        case System.Crude_O:
            return functionIds.list_transaction_crude_o
        case System.Hedge_sett:
            return functionIds.list_transaction_hedge_sett
        case System.Hedge_tckt:
            return functionIds.list_transaction_hedge_tckt
        case System.Hedge_Bot:
            return functionIds.list_transaction_hedge_bot
        case System.Demurrage:
            return functionIds.list_transaction_demurrage
        case System.Product:
            return functionIds.list_transaction_new_paf
        case System.VCool:
            return functionIds.list_transactio_vcool
        case System.All_My_Task:
            return functionIds.list_all_my_task
        default:
            return functionIds.list_transaction
        }
    }
    
    private func getlistTransactionXMLParams(system: String, data: [String: Any]) -> [String: String] {
        switch system {
        case System.All_My_Task:
            return ["channel"       : "MOBILE",
                    "user"          : CredentialManager.shareInstance.userId ?? "",
                    "system"        : system,
                    "status"        : "",
                    "page_number"   : "1",
                    "rows_per_page" : "20",
                    "from_date"     : data["from_date"] as! String,
                    "to_date"       : data["to_date"] as! String]
        case System.Hedge_tckt:
            return ["channel"       : "MOBILE",
                    "user"          : CredentialManager.shareInstance.userId ?? "",
                    "system"        : "hedg",
                    "status"        : "",
                    "page_number"   : "1",
                    "rows_per_page" : "20",
                    "from_date"     : data["from_date"] as! String,
                    "to_date"       : data["to_date"] as! String,
                    "user_group"    : "",
                    "function_code" : String(functionIds.list_transaction_hedge_tckt.suffix(2)),
                    "frame_type"    : (data["frame"] as! String).uppercased()]
        case System.Hedge_sett:
            return ["channel"       : "MOBILE",
                    "user"          : CredentialManager.shareInstance.userId ?? "",
                    "system"        : "hedg",
                    "status"        : "",
                    "page_number"   : "1",
                    "rows_per_page" : "20",
                    "from_date"     : data["from_date"] as! String,
                    "to_date"       : data["to_date"] as! String,
                    "user_group"    : "",
                    "function_code" : "86",
                    "frame_type"    : (data["frame"] as! String).uppercased()]
        case System.Hedge_Bot:
            return ["channel": "MOBILE",
                    "user": CredentialManager.shareInstance.userId ?? "",
                    "page_number": "1",
                    "rows_per_page": "20",
                    "function_code": "112",
                    "trading_book": data["trading_book"] as! String ?? "",
                    "quater": data["quater"] as! String ?? "",
                    "year": data["year"] as! String ?? "",
                    "system": "hedg"]
        case System.Demurrage:
            return ["channel"       : "MOBILE",
                    "user"          : CredentialManager.shareInstance.userId ?? "",
                    "system"        : system,
                    "type"          : system,
                    "status"        : data["statusString"] as! String,
                    "page_number"   : "1",
                    "rows_per_page" : "20",
                    "from_date"     : data["from_date"] as! String,
                    "to_date"       : data["to_date"] as! String]
        case System.Product:
            return ["channel"       : "MOBILE",
                    "user"          : CredentialManager.shareInstance.userId ?? "",
                    "system"        : system,
                    "form_type"     : data["form_type"] as! String,
                    "status"        : "",
                    "page_number"   : "1",
                    "rows_per_page" : "20",
                    "from_date"     : data["from_date"] as! String,
                    "to_date"       : data["to_date"] as! String,
                    "search_material": data["search_material"] as! String]
        case System.Crude_O:
            return ["channel": "MOBILE",
                    "user": CredentialManager.shareInstance.userId ?? "",
                    "system": system,
                    "page_number": "1",
                    "rows_per_page": "20",
                    "status": data["statusString"] as! String,   //if error change to ""
                    "from_date": data["from_date"] as! String,
                    "to_date": data["to_date"] as! String,
                    "function_code": "90",
                    "vessel": "",
                    "create_by": "",
                    "index_7": data["index_7"] as! String,
                    "search_material": data["search_material"] as! String]
        default: //Crude, Bunker, Chartering, VCool
            let index = data["index"] as! [String]
            return ["channel": "MOBILE",
                    "user": CredentialManager.shareInstance.userId ?? "",
                    "system": system,
                    "status": data["statusString"] as! String,
                    "page_number": "1",
                    "rows_per_page": "20",
                    "from_date": data["from_date"] as! String,
                    "to_date": data["to_date"] as! String,
                    "index_1": index[0],
                    "index_2": index[1],
                    "index_3": index[2],
                    "index_4": index[3],
                    "index_5": index[4],
                    "index_6": index[5],
                    "index_7": index[6],
                    "index_8": index[7],
                    "index_9": index[8],
                    "index_10": index[9],
                    "index_11": index[10],
                    "index_12": index[11],
                    "index_13": index[12],
                    "index_14": index[13],
                    "index_15": index[14],
                    "index_16": index[15],
                    "index_17": index[16],
                    "index_18": index[17],
                    "index_19": index[18],
                    "index_20": index[19],
                    "mobile_flag" : "Y"]
        }
    }
    //Button
    private func getActionButtonXMLFuncId(system: String) -> String {
        switch system {
        case System.Crude_O:
            return functionIds.get_action_button_crude_o
        case System.Hedge_tckt:
            return functionIds.get_action_button_hedge_tckt
        case System.Hedge_sett:
            return functionIds.get_action_button_hedge_sett
        case System.Hedge_Bot:
            return functionIds.get_action_button_hedge_bot
        case System.Demurrage:
            return functionIds.get_action_button_demurrage
        case System.VCool:
            return functionIds.get_action_button_vcool
        default: //Crude, Bunker, Chartering, product
            return functionIds.get_action_button
        }
    }
    
    private func getActionButtonXMLParams(system: String, type: String, transaction_id: String, companycode: String) -> [String: String] {
        switch system {
        case System.Crude_O:
            return ["channel"       : "MOBILE",
                    "user"          : CredentialManager.shareInstance.userId ?? "",
                    "system"        : system,
                    "type"          : "OTHER",
                    "transaction_id": transaction_id]
        case System.Hedge_tckt:
            return ["channel"       : "MOBILE",
                    "user"          : CredentialManager.shareInstance.userId ?? "",
                    "system"        : "hedg",
                    "type"          : type,
                    "transaction_id": transaction_id,
                    "user_group"    : "",
                    "companycode"   : companycode]
            
        case System.Hedge_sett:
            return ["channel"       : "MOBILE",
                    "user"          : CredentialManager.shareInstance.userId ?? "",
                    "system"        : "hedg",
                    "type"          : type,
                    "transaction_id": transaction_id,
                    "user_group"    : "",
                    "company"   : companycode]
        case System.Hedge_Bot:
            return ["channel": "MOBILE",
                    "user": CredentialManager.shareInstance.userId ?? "",
                    "transaction_id": transaction_id,
                    "system": "HEDG",
                    "type": "HEDG"]
        case System.Demurrage:
            return ["channel"       : "MOBILE",
                    "user"          : CredentialManager.shareInstance.userId ?? "",
                    "system"        : system,
                    "type"          : type,
                    "transaction_id": transaction_id,
                    "mobile_flag" : "Y"]
        case System.Product:
            return  ["channel"       : "MOBILE",
                     "user"          : CredentialManager.shareInstance.userId ?? "",
                     "system"        : system,
                     "type"          : type,
                     "transaction_id": transaction_id]
        case System.VCool:
            return ["channel"       : "MOBILE",
                    "user"          : CredentialManager.shareInstance.userId ?? "",
                    "system"        : system,
                    "type"          : type,
                    "transaction_id": transaction_id,
                    "mobile_flag" : "Y"]
        case System.Advance_loading:
            return ["channel"       : "MOBILE",
                    "user"          : CredentialManager.shareInstance.userId ?? "",
                    "system"        : system,
                    "doc_type"      : type,
                    "data_detail_input": "#json"]
        case System.Final_contract:
            return ["channel"       : "MOBILE",
                    "user"          : CredentialManager.shareInstance.userId ?? "",
                    "system"        : system,
                    "doc_type"      : type,
                    "data_detail_input": "#json"]
            
        default: //Crude, Bunker, Chartering, VCool
            return ["channel"       : "MOBILE",
                    "user"          : CredentialManager.shareInstance.userId ?? "",
                    "system"        : system,
                    "type"          : type,
                    "transaction_id": transaction_id,
                    "mobile_flag" : "Y"]
        }
    }
    func getAdvanceXML(system: String, type: String, transaction_id: String ,action: String,reason:String) -> String {
        let params = getActionButtonXMLParams(system: system, type: type, transaction_id: transaction_id, companycode: "companyCode")
        let funcID = "F10000114"
        
        let json: [Any]  = [
                      [
                          "trans_id": transaction_id,
                          "action": action,
                          "reject_reason": reason,
                      ]
                  ]
                  
                  let jsonData = try! JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
                   let jsonString = String(data:jsonData,  encoding: .utf8)
        let xmlRequest = buildAdvanceXMLDoc(functionId: funcID, params: params, json: jsonString! )
        
        log.debug(xmlRequest.xml)
        return xmlRequest.xmlCompact
    }
    
    func getActionButtonXML(system: String, type: String, transaction_id: String, companyCode: String) -> String {
        let params = getActionButtonXMLParams(system: system, type: type, transaction_id: transaction_id, companycode: companyCode)
        let funcID = getActionButtonXMLFuncId(system: system)
        
        let xmlRequest = buildXMLDoc(functionId: funcID, params: params)
        
        log.debug(xmlRequest.xml)
        return xmlRequest.xmlCompact
    }
    
    //--------------------------
    
    func notiXMLBuilder(user: String, key: String, set_flag: String) -> String{
        let params = [
            "channel"		: "MOBILE",
            "user"          : user,
            "key"           : key,
            "set_flag"      : set_flag
        ]
        
        let xmlRequest = buildXMLDoc(functionId: functionIds.messageControl, params: params)
        log.debug("Request = \n\(xmlRequest.xml)\n\n\n")
        return xmlRequest.xmlCompact
    }
    
    func sendXMLFromButtonWithJsonData(system: String, type: String, xml: String, req_txn_id: String, note: String, jsonData: String, brief: String) -> String {
        if let userId = CredentialManager.shareInstance.userId {
            
            var xmlRequest = xml.replacingOccurrences(of: "#appuser", with: app_user)
            xmlRequest = xmlRequest.replacingOccurrences(of: "#password", with: app_password)
            xmlRequest = xmlRequest.replacingOccurrences(of: "#req_txn_id", with: req_txn_id)
            xmlRequest = xmlRequest.replacingOccurrences(of: "WEB", with: "MOBILE")
            xmlRequest = xmlRequest.replacingOccurrences(of: "#user", with: userId)
            xmlRequest = xmlRequest.replacingOccurrences(of: "#user_group", with: type)
            xmlRequest = xmlRequest.replacingOccurrences(of: "#json_data", with: jsonData)
            xmlRequest = xmlRequest.replacingOccurrences(of: "#note", with: note)
            xmlRequest = xmlRequest.replacingOccurrences(of: "&gt;", with: ">")
            xmlRequest = xmlRequest.replacingOccurrences(of: "&lt;", with: "<")
            xmlRequest = xmlRequest.replacingOccurrences(of: "\n", with: "")
            xmlRequest = xmlRequest.replacingOccurrences(of: "\"", with: "\" ")
            xmlRequest = xmlRequest.replacingOccurrences(of: "=\" ", with: "=\"")
            xmlRequest = xmlRequest.replacingOccurrences(of: "#form_brief", with: brief.toBase64())
            let regex = try! NSRegularExpression(pattern: ">\\s*<", options: .caseInsensitive)
            //let range = NSMakeRange(0, xmlRequest.characters.count)
            let range = NSMakeRange(0, xmlRequest.length)
            xmlRequest = regex.stringByReplacingMatches(in: xmlRequest, options: [], range: range, withTemplate: "><")
            log.debug(xmlRequest)
            return xmlRequest
            
        } else {
            // Handle error
            log.error("Failed to get userId")
            return ""
        }
    }
    func sendXMLFromButtonWithJsonDataNewPaf(system: String, brief: String, reason: String, xml: String, req_txn_id: String, note: String, jsonData: String) -> String {
        if let userId = CredentialManager.shareInstance.userId {
            
            var xmlRequest = xml.replacingOccurrences(of: "#appuser", with: app_user)
            xmlRequest = xmlRequest.replacingOccurrences(of: "#password", with: app_password)
            xmlRequest = xmlRequest.replacingOccurrences(of: "#req_txn_id", with: req_txn_id)
            xmlRequest = xmlRequest.replacingOccurrences(of: "WEB", with: "MOBILE")
            xmlRequest = xmlRequest.replacingOccurrences(of: "#user", with: userId)
            xmlRequest = xmlRequest.replacingOccurrences(of: "#form_brief", with: brief.toBase64())
            xmlRequest = xmlRequest.replacingOccurrences(of: "#form_note", with: note)
            xmlRequest = xmlRequest.replacingOccurrences(of: "#form_reason", with: reason)
            xmlRequest = xmlRequest.replacingOccurrences(of: "#json_data", with: jsonData)
            
            xmlRequest = xmlRequest.replacingOccurrences(of: "&gt;", with: ">")
            xmlRequest = xmlRequest.replacingOccurrences(of: "&lt;", with: "<")
            xmlRequest = xmlRequest.replacingOccurrences(of: "\n", with: "")
            xmlRequest = xmlRequest.replacingOccurrences(of: "\"", with: "\" ")
            xmlRequest = xmlRequest.replacingOccurrences(of: "=\" ", with: "=\"")
            let regex = try! NSRegularExpression(pattern: ">\\s*<", options: .caseInsensitive)
            //let range = NSMakeRange(0, xmlRequest.characters.count)
            let range = NSMakeRange(0, xmlRequest.length)
            xmlRequest = regex.stringByReplacingMatches(in: xmlRequest, options: [], range: range, withTemplate: "><")
            log.debug(xmlRequest)
            return xmlRequest
            
        } else {
            // Handle error
            log.error("Failed to get userId")
            return ""
        }
    }
    
    func getCountTxnXML(Type : String,fromDate : String, toDate :String) -> String {
        if let userId = CredentialManager.shareInstance.userId {
            var params = [
                "channel"       : "MOBILE",
                "user"          : userId,
                "system"        : Type,
                "from_date"     : fromDate,
                "to_date"       : toDate
            ]
            if Type.lowercased() == "product_sale" || Type.lowercased() == "product_purchase" {
                params =  [
                    "channel"       : "MOBILE",
                    "user"          : userId,
                    "system"        : "PRODUCT",
                    "from_date"     : fromDate,
                    "to_date"       : toDate,
                    "type"          : Type
                ]
            }
            if Type == System.Hedge_sett || Type == System.Hedge_tckt {
                params =  [
                    "channel"       : "MOBILE",
                    "user"          : userId,
                    "system"        : "HEDG",
                    "from_date"     : fromDate,
                    "to_date"       : toDate,
                    "type"          : Type.uppercased()
                ]
            }
            let funcId = functionIds.get_counter_transaction
            let xmlRequest = buildXMLDoc(functionId: funcId, params: params)
            
            log.debug(xmlRequest.xml)
            return xmlRequest.xmlCompact
            
        } else {
            // Handle error
            log.error("Failed to get userId")
            return ""
        }
    }
    
    func getPDFXML(functionID: String, transaction_id: String) -> String {
        if let userId = CredentialManager.shareInstance.userId {
            let params = [
                "channel"       : "MOBILE",
                "user"          : userId,
                "transaction_id": transaction_id,
                ]
            
            let xmlRequest = buildXMLDoc(functionId: functionID, params: params)
            
            log.debug(xmlRequest.xml)
            return xmlRequest.xmlCompact
            
        } else {
            // Handle error
            log.error("Failed to get userId")
            return ""
        }
    }
    func getPDFXMLNewPaf(functionID: String, system: String, transaction_id: String) -> String {
        if let userId = CredentialManager.shareInstance.userId {
            let params = [
                "channel"       : "MOBILE",
                "user"          : userId,
                "transaction_id": transaction_id,
                "system": system
                ]
            
            let xmlRequest = buildXMLDoc(functionId: functionID, params: params)
            
            log.debug(xmlRequest.xml)
            return xmlRequest.xmlCompact
            
        } else {
            // Handle error
            log.error("Failed to get userId")
            return ""
        }
    }
    
    func getDropDownListXML(key: String, system: String, type: String) -> String {
        if let userId = CredentialManager.shareInstance.userId {
            let params = [
                "channel"       : "MOBILE",
                "user"          : userId,
                "key"           : key,
                "system"        : system,
                "type"          : type
                ]
            
            let xmlRequest = buildXMLDoc(functionId: functionIds.dropdown, params: params)
            
            log.debug(xmlRequest.xml)
            return xmlRequest.xmlCompact
            
        } else {
            // Handle error
            log.error("Failed to get userId")
            return ""
        }
    }
    
    func getValueFromGlobalConfigXML(key: String) -> String {
        if let userId = CredentialManager.shareInstance.userId {
            let params = [
                "channel"       : "MOBILE",
                "user"          : userId,
                "key"           : key
            ]
            
            let xmlRequest = buildXMLDoc(functionId: functionIds.globalconfig, params: params)
            
            log.debug(xmlRequest.xml)
            return xmlRequest.xmlCompact
            
        } else {
            // Handle error
            log.error("Failed to get userId")
            return ""
        }
    }
    
    // MARK: - Private methods
    
    private func buildXMLDoc(functionId: String, params: [String: String]) -> AEXMLDocument {
        let xmlRequest = AEXMLDocument()
        let attr = [
            "function_id": functionId,
            "app_user": app_user,
            "app_password": app_password,
            "req_transaction_id": reqTransactionId.md5(),
            "state_name": ""
        ]
        
        let root = xmlRequest.addChild(name: "request", attributes: attr)
        let reqParams = root.addChild(name: "req_parameters")
        
        for (key, value) in params {
            reqParams.addChild(name: "p", value: "", attributes: ["k": key, "v": value])
        }
        return xmlRequest
    }
    
    private func buildAdvanceXMLDoc(functionId: String,params: [String: String],json:String) -> AEXMLDocument {
        let xmlRequest = AEXMLDocument()
        
        let attr = [
            "function_id": functionId,
            "app_user": app_user,
            "app_password": app_password,
            "req_transaction_id": reqTransactionId.md5(),
            "state_name": ""
        ]
        
        let root = xmlRequest.addChild(name: "request", attributes: attr)
        let reqParams = root.addChild(name: "req_parameters")
        root.addChild(name:"extra_xml",value:json)
        
        
        
        for (key, value) in params {
            reqParams.addChild(name: "p", value: "", attributes: ["k": key, "v": value])
        }
        return xmlRequest
    }
}
