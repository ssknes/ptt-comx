//
//  APIManager.swift
//  ICTPocketPay
//

import Foundation
import AEXML
import SystemConfiguration

class APIManager {
    
    static let shareInstance = APIManager()
    private let domain: String
    
    init() {
        domain = GlobalVar.sharedInstance.appMode.getUrl()
        
        let iOSVersion = IOSVersion.getVersion()
        let releaseVersion = Bundle.main.releaseVersionNumber
        log.info("iOS Version : \(iOSVersion) Version Number : \(releaseVersion)")
        
        httpClient = HTTPClient(domain: domain)
        log.info("URL is "+self.domain)
    }
    
    func getDomain() -> String {
        return domain
    }
    
    func connectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    func requestLogin(userId: String, userPassword: String, callback: ((_ success: Bool, _ fail: MyError?, _ dataDict: [String: Any]) -> Void)?) {
        // Initialize return variables
        var dataDict = Dictionary<String, Any>()
        var successFlag = false
        var errMsg = ""
      let bodyString = xmlBuilder.loginRequestXML(userId: userId, userPassword: userPassword)
        if !connectedToNetwork(){
            let err = MyError(message: "No Internet Connection.")
            callback?(false, err, dataDict)
            return
        }
        
        // Make request
        httpClient.postAndDecodeData(path: Paths.defaultPath, body: bodyString.data(using: .utf8)! as NSData) { (decodedData, response, error) in
            
            if GlobalVar.sharedInstance.appMode != .DEV {
                if error != nil {
                    errMsg = (error?.localizedDescription)!
                    
                    let err = MyError(message: errMsg)
                    callback?(false, err, dataDict)
                    return
                }
            }
            
            let string = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)
            log.debug("data = \(string!)\n\n\n")
            
            self.setupXMLDocument(xmlData: decodedData! as Data, options: nil, respose: response, error: error, callback: {
                (success, xmlError, xmlDoc) in
                
                errMsg = xmlError.message
               // if !GlobalVar.sharedInstance.mockBypassUpdate {
                var tempSuccess = success
                if GlobalVar.sharedInstance.mockSkipLogin {
                    tempSuccess = true
                }
                    if !tempSuccess {
                        if xmlDoc != nil {
                            let err: MyError
                            if let errorCode = xmlDoc!.root.attributes["result_code"] {
                                err = MyError(code: errorCode, message: errMsg)
                            } else {
                                log.error("Unknown error : \(errMsg)")
                                err = MyError(message: errMsg)
                            }
                            callback?(successFlag, err, dataDict)
                            return
                        } else {
                            // request timed out, server down
                            let err = MyError(code: "1", message: errMsg)
                            callback?(successFlag, err, dataDict)
                            return
                        }
                    }
                //}
                
                if let xmlDoc = xmlDoc {
                    // Parse resp_parameter
                    let params = xmlDoc.root["resp_parameters"].children
                    
                    for item in params {
                        if let attr = item.attributes["k"]{
                            dataDict[attr] = item.attributes["v"]
                        } else {
                            log.error("Unwrapping item.attributes[k] failed = \(item.xml)")
                        }
                    }
                    successFlag = true
                } else {
                    log.error("xmlDoc nil: \(String(describing: xmlDoc))")
                    errMsg = MyMessage.failedToParseReponseBody
                }
                let err = MyError(message: errMsg)
                callback?(successFlag, err, dataDict)
            })
        }
    }
    
    func listTransaction(system: String, data: [String: Any], callback: ((_ success: Bool, _ fail: MyError, _ xmlData: AEXMLDocument?) -> Void)?) {
        let bodyString = xmlBuilder.listTransactionXML(system: system, data: data)
        log.info("bodyString \(bodyString)")
        if bodyString == "" {
            let err = MyError(message: MyMessage.failedToCreateRequestBody)
            callback?(false, err, nil)
            return
        }
        if !connectedToNetwork(){
            let err = MyError(message: "No Internet Connection.")
            callback?(false, err, nil)
            return
        }
        log.info("path \(Paths.defaultPath)")
        httpClient.postAndDecodeData(path: Paths.defaultPath, body: (bodyString.data(using: .utf8))! as NSData) {
            (decodedData, response, error) in
            self.setupXMLDocument(xmlData: decodedData!, response: response, error: error, callback: {
                (success, xmlError, xmlDoc) in
                
                let errMsg = xmlError.message
                
                if !success {
                    let err = MyError(message: errMsg)
                    callback?(false, err, nil)
                } else {
                    let err = MyError(message: errMsg)
                    callback?(success, err, xmlDoc)
                }
            })
        }
    }
    
    private func getButtonKey(system: String) -> String {
        switch system {
        case System.Hedge_tckt:
            return "ButtonDetail"
        default:
            return "button_detail"
        }
    }
    
    private func getButtonType(system: String, Data: [String: Any]) -> String {
        switch system {
        case System.Hedge_sett:
            return "hedg"
        case System.Hedge_tckt:
            return "hedg"
        case System.Product:
            return "OTHER"
        default:
            return Data["type"] as? String ?? ""
        }
    }
    private func getTransactionID(system: String, Data: [String: Any]) -> String {
        switch system {
        case System.Hedge_Bot:
            return Data["bot_rowid"] as? String ?? ""
        case System.Hedge_tckt:
            return Data["ticketid"] as? String ?? ""
        case System.Product:
            return Data["doc_trans_id"] as? String ?? ""
        default:
            return Data["transaction_id"] as? String ?? ""
        }
    }
    
    func getActionButton(Data: [String: Any], callback: ((_ success: Bool, _ fail: MyError, _ data: [Button]) -> Void)?) {
        //init First Data
        let system = DataUtils.shared.SysName(Data["system"] as? String ?? "")
        let type = getButtonType(system: system, Data: Data)
        let transaction_id = getTransactionID(system: system, Data: Data)
        let companyCode = Data["company_code"] as? String ?? ""
        //----------
        var dataDict = Dictionary<String, Any>()
        let bodyString = xmlBuilder.getActionButtonXML(system: system, type: type, transaction_id: transaction_id, companyCode: companyCode)
        if bodyString == "" {
            let err = MyError(message: MyMessage.failedToCreateRequestBody)
            callback?(false, err, dataDict[system] as? [Button] ?? [])
            return
        }
        if !connectedToNetwork(){
            let err = MyError(message: "No Internet Connection.")
            callback?(false, err, dataDict[system] as? [Button] ?? [])
            return
        }
        httpClient.postAndDecodeData(path: Paths.defaultPath, body: (bodyString.data(using: .utf8))! as NSData) {
            (decodedData, response, error) in
            self.setupXMLDocument(xmlData: decodedData!, response: response, error: error, callback: {
                (success, xmlError, xmlDoc) in
                let errMsg = xmlError.message
                if !success {
                    let err = MyError(message: errMsg)
                    callback?(false, err, dataDict[system] as? [Button] ?? [])
                    return
                }
                if let xmlDoc = xmlDoc {
                    log.debug("\(xmlDoc.xml)")
                    // Parse extra xml
                    let availableData = xmlDoc.root["extra_xml"].xml
                    let dataString = self.replaceUnescapeButtonString(text: availableData)
                    let decodedDataXML = self.setupXMLFromString(text: dataString).root[self.getButtonKey(system: system)].children
                    var dataArray = [Button]()
                    for data in decodedDataXML {
                        let newButton = Button()
                        
                        for button in data.children {
                            if button.name == "name" {
                                newButton.name = button.value ?? "\(button.value ?? "")"
                            } else if button.name == "page_url" {
                                newButton.page_url = button.value ?? "\(button.value ?? "")"
                            } else if button.name == "call_xml" {
                                newButton.call_xml = button.value ?? "\(button.value ?? "")"
                            }
                        }
                        dataArray.append(newButton)
                    }
                    dataDict[system] = dataArray
                    
                    let err = MyError(message: errMsg)
                    callback?(true, err, dataDict[system] as? [Button] ?? [])
                    
                } else {
                    log.error("xmlDoc nil: \(String(describing: xmlDoc))")
                    let err = MyError(message: MyMessage.failedToParseReponseBody)
                    callback?(false, err, dataDict[system] as? [Button] ?? [])
                }
            })
        }
    }
    
    func sendXMLFromButton(system: String, type: String, xml: String, req_txn_id: String, note: String, txtBrief: String, callback: ((_ success: Bool, _ fail: MyError, _ dataDict: [String: Any]) -> Void)?) {
        let dataDict = Dictionary<String, Any>()
        
        let bodyString = xmlBuilder.sendXMLFromButtonWithJsonData(system: system, type: type, xml: xml, req_txn_id: req_txn_id, note: note, jsonData: "", brief: txtBrief)
        
        if bodyString == "" {
            let err = MyError(message: MyMessage.failedToCreateRequestBody)
            callback?(false, err, dataDict)
            return
        }
        
        if !connectedToNetwork(){
            let err = MyError(message: "No Internet Connection.")
            callback?(false, err, dataDict)
            return
        }
        httpClient.postAndDecodeData(path: Paths.defaultPath, body: (bodyString.data(using: .utf8))! as NSData) {
            (decodedData, response, error) in
            
            self.setupXMLDocument(xmlData: decodedData!, response: response, error: error, callback: {
                (success, xmlError, xmlDoc) in
                
                let errMsg = xmlError.message
                
                if !success {
                    let err = MyError(message: errMsg)
                    callback?(false, err, dataDict)
                    return
                } else {
                    if let err = xmlDoc?.root.attributes["response_message"] {
                        callback?(true, MyError(message: err), dataDict)
                    } else {
                        callback?(true, MyError(message: ""), dataDict)
                    }
                    return
                }
            })
        }
    }
    
    func sendXMLFromButtonRevise(system: String, type: String, xml: String, req_txn_id: String, note: String, jsonData: String, txtBrief: String, callback: ((_ success: Bool, _ fail: MyError, _ dataDict: [String: Any]) -> Void)?) {
        let dataDict = Dictionary<String, Any>()
        
        let bodyString = xmlBuilder.sendXMLFromButtonWithJsonData(system: system, type: type, xml: xml, req_txn_id: req_txn_id, note: note, jsonData: jsonData, brief: txtBrief)
        
        if bodyString == "" {
            let err = MyError(message: MyMessage.failedToCreateRequestBody)
            callback?(false, err, dataDict)
            return
        }
        
        if !connectedToNetwork(){
            let err = MyError(message: "No Internet Connection.")
            callback?(false, err, dataDict)
            return
        }
        
        httpClient.postAndDecodeData(path: Paths.defaultPath, body: (bodyString.data(using: .utf8))! as NSData) {
            (decodedData, response, error) in
            
            self.setupXMLDocument(xmlData: decodedData!, response: response, error: error, callback: {
                (success, xmlError, xmlDoc) in
                
                let errMsg = xmlError.message
                
                if !success {
                    let err = MyError(message: errMsg)
                    callback?(false, err, dataDict)
                    return
                } else {
                    if let err = xmlDoc?.root.attributes["response_message"] {
                        callback?(true, MyError(message: err), dataDict)
                    } else {
                        callback?(true, MyError(message: ""), dataDict)
                    }
                    return
                }
            })
        }
    }
    
    func sendXMLFromButtonNewPaf (system: String, brief: String, reason: String, xml: String, req_txn_id: String, note: String, callback: ((_ success: Bool, _ fail: MyError, _ dataDict: [String: Any]) -> Void)?) {
        let dataDict = Dictionary<String, Any>()
        let bodyString = xmlBuilder.sendXMLFromButtonWithJsonDataNewPaf(system: system, brief: brief, reason: reason, xml: xml, req_txn_id: req_txn_id, note: note, jsonData: "")
        
        if bodyString == "" {
            let err = MyError(message: MyMessage.failedToCreateRequestBody)
            callback?(false, err, dataDict)
            return
        }
        
        if !connectedToNetwork(){
            let err = MyError(message: "No Internet Connection.")
            callback?(false, err, dataDict)
            return
        }
        httpClient.postAndDecodeData(path: Paths.defaultPath, body: (bodyString.data(using: .utf8))! as NSData) {
            (decodedData, response, error) in
            
            self.setupXMLDocument(xmlData: decodedData!, response: response, error: error, callback: {
                (success, xmlError, xmlDoc) in
                
                let errMsg = xmlError.message
                
                if !success {
                    let err = MyError(message: errMsg)
                    callback?(false, err, dataDict)
                    return
                } else {
                    if let err = xmlDoc?.root.attributes["response_message"] {
                        callback?(true, MyError(message: err), dataDict)
                    } else {
                        callback?(true, MyError(message: ""), dataDict)
                    }
                    return
                }
            })
        }
    }

    
    func getCountTxn(Type : String,fromDate : String, toDate : String,  callback: ((_ success: Bool, _ fail: MyError, _ dataDict: [String: Any]) -> Void)?) {
        var dataDict = Dictionary<String, Any>()
        
        let bodyString = xmlBuilder.getCountTxnXML(Type: Type,fromDate: fromDate, toDate: toDate)
        
        if bodyString == "" {
            let err = MyError(message: MyMessage.failedToCreateRequestBody)
            callback?(false, err, dataDict)
            return
        }
        
        if !connectedToNetwork(){
            let err = MyError(message: "No Internet Connection.")
            callback?(false, err, dataDict)
            return
        }
        
        httpClient.postAndDecodeData(path: Paths.defaultPath, body: (bodyString.data(using: .utf8))! as NSData) {
            (decodedData, response, error) in
            
            self.setupXMLDocument(xmlData: decodedData!, response: response, error: error, callback: {
                (success, xmlError, xmlDoc) in
                
                let errMsg = xmlError.message
                
                if !success {
                    let err = MyError(message: errMsg)
                    callback?(false, err, dataDict)
                    return
                }
                
                if let xmlDoc = xmlDoc {
                    
                    log.debug("\(xmlDoc.xml)")
                    
                    // Parse extra xml
                    
                    let availableData = xmlDoc.root["extra_xml"].xmlCompact
                    var dataString = self.replaceUnescapeString(text: availableData)
                    dataString = dataString.replacingOccurrences(of: "<extra_xml><data_detail>", with: "")
                    dataString = dataString.replacingOccurrences(of: "</data_detail></extra_xml>", with: "")
                    let data = dataString.data(using: .utf8)
                    do {
                        let json: [String: AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
                        if let counter_txns: [[String: String]] = json["counter_txn"] as? [[String: String]] {
                            var transDict = [String: String]()
                            for counter_txn in counter_txns {
                                transDict[counter_txn["function"]!] = counter_txn["counter"]
                            }
                            dataDict[System.CountTxn] = transDict
                        }
                    } catch {
                        print("error serializing JSON: \(error)")
                    }
                    
                    let err = MyError(message: errMsg)
                    callback?(true, err, dataDict)
                    
                } else {
                    log.error("xmlDoc nil: \(String(describing: xmlDoc))")
                    let err = MyError(message: MyMessage.failedToParseReponseBody)
                    callback?(false, err, dataDict)
                }
            })
        }
    }
    
    func getPDFNewPaf(functionID: String, system: String, transaction_id: String, callback: ((_ success: Bool, _ fail: MyError, _ dataDict: [String: Any]) -> Void)?) {
        var dataDict = Dictionary<String, Any>()
        let bodyString = xmlBuilder.getPDFXMLNewPaf(functionID: functionID, system: system, transaction_id: transaction_id)
        
        if bodyString == "" {
            let err = MyError(message: MyMessage.failedToCreateRequestBody)
            callback?(false, err, dataDict)
            return
        }
        if !connectedToNetwork(){
            let err = MyError(message: "No Internet Connection.")
            callback?(false, err, dataDict)
            return
        }
        httpClient.postAndDecodeData(path: Paths.defaultPath, body: (bodyString.data(using: .utf8))! as NSData) {
            (decodedData, response, error) in
            
            self.setupXMLDocument(xmlData: decodedData!, response: response, error: error, callback: {
                (success, xmlError, xmlDoc) in
                
                let errMsg = xmlError.message
                
                if !success {
                    let err = MyError(message: errMsg)
                    callback?(false, err, dataDict)
                    return
                }
                
                if let xmlDoc = xmlDoc {
                    
                    log.debug("\(xmlDoc.xml)")
                    
                    // Parse resp_parameter
                    let params = xmlDoc.root["resp_parameters"].children
                    
                    for item in params {
                        if let attr = item.attributes["k"]{
                            dataDict[attr] = item.attributes["v"]
                        } else {
                            log.error("Unwrapping item.attributes[k] failed = \(item.xml)")
                        }
                    }
                    
                    let err = MyError(message: errMsg)
                    callback?(true, err, dataDict)
                } else {
                    log.error("xmlDoc nil: \(String(describing: xmlDoc))")
                    let err = MyError(message: MyMessage.failedToParseReponseBody)
                    callback?(false, err, dataDict)
                }
            })
        }
    }
    
    func getPDF(functionID: String, transaction_id: String, callback: ((_ success: Bool, _ fail: MyError, _ dataDict: [String: Any]) -> Void)?) {
        var dataDict = Dictionary<String, Any>()
        let bodyString = xmlBuilder.getPDFXML(functionID: functionID, transaction_id: transaction_id)
        
        if bodyString == "" {
            let err = MyError(message: MyMessage.failedToCreateRequestBody)
            callback?(false, err, dataDict)
            return
        }
        if !connectedToNetwork(){
            let err = MyError(message: "No Internet Connection.")
            callback?(false, err, dataDict)
            return
        }
        httpClient.postAndDecodeData(path: Paths.defaultPath, body: (bodyString.data(using: .utf8))! as NSData) {
            (decodedData, response, error) in
            
            self.setupXMLDocument(xmlData: decodedData!, response: response, error: error, callback: {
                (success, xmlError, xmlDoc) in
                
                let errMsg = xmlError.message
                
                if !success {
                    let err = MyError(message: errMsg)
                    callback?(false, err, dataDict)
                    return
                }
                
                if let xmlDoc = xmlDoc {
                    
                    log.debug("\(xmlDoc.xml)")
                    
                    // Parse resp_parameter
                    let params = xmlDoc.root["resp_parameters"].children
                    
                    for item in params {
                        if let attr = item.attributes["k"]{
                            dataDict[attr] = item.attributes["v"]
                        } else {
                            log.error("Unwrapping item.attributes[k] failed = \(item.xml)")
                        }
                    }
                    
                    let err = MyError(message: errMsg)
                    callback?(true, err, dataDict)
                } else {
                    log.error("xmlDoc nil: \(String(describing: xmlDoc))")
                    let err = MyError(message: MyMessage.failedToParseReponseBody)
                    callback?(false, err, dataDict)
                }
            })
        }
    }
    
    func getPDFFileFromURL(url: String, callback: ((_ success: Bool, _ fail: NSError, _ data: Data) -> Void)?) {
        httpClient.getFileFromURL(url: url, type: "") { (data, response, err) in
            if let data = data {
                callback?(true, NSError(), data)
            } else {
                callback?(false, err!, Data())
            }
        }
        if !connectedToNetwork(){
            let err = MyError(message: "No Internet Connection.")
            callback?(false, err as? NSError ?? NSError(), Data())
            return
        }
    }
    
    func getImageFromURL(url: String, type: String, callback: ((_ success: Bool, _ fail: NSError, _ data: Data) -> Void)?) {
        if !connectedToNetwork(){
            let err = MyError(message: "No Internet Connection.")
            callback?(false, err as? NSError ?? NSError(), Data())
            return
        }
        
        httpClient.getFileFromURL(url: url, type: type) { (data, response, err) in
            if let data = data {
                if data != Data() {
                    callback?(true, NSError(), data)
                } else {
                    callback?(false, NSError(), data)
                }
            } else {
                callback?(false, err!, Data())
            }
        }
    }
    
    func getDropdownList(key: String, system: String, type: String, callback: ((_ success: Bool, _ fail: MyError, _ dataDict: [String: Any]) -> Void)?) {
        var dataDict = Dictionary<String, Any>()
        if !connectedToNetwork(){
            let err = MyError(message: "No Internet Connection.")
            callback?(false, err, dataDict)
            return
        }
        let bodyString = xmlBuilder.getDropDownListXML(key: key, system: system, type: type)
        
        if bodyString == "" {
            let err = MyError(message: MyMessage.failedToCreateRequestBody)
            callback?(false, err, dataDict)
            return
        }
        
        httpClient.postAndDecodeData(path: Paths.defaultPath, body: (bodyString.data(using: .utf8))! as NSData) {
            (decodedData, response, error) in
            
            self.setupXMLDocument(xmlData: decodedData!, response: response, error: error, callback: {
                (success, xmlError, xmlDoc) in
                
                let errMsg = xmlError.message
                
                if !success {
                    let err = MyError(message: errMsg)
                    callback?(false, err, dataDict)
                    return
                }
                
                if let xmlDoc = xmlDoc {
                    
                    log.debug("\(xmlDoc.xml)")
                    
                    // Parse extra xml
                    
                    let availableData = xmlDoc.root["extra_xml"].xmlCompact
                    var dataString = self.replaceUnescapeString(text: availableData)
                    dataString = dataString.replacingOccurrences(of: "<extra_xml><data_detail>", with: "")
                    dataString = dataString.replacingOccurrences(of: "</data_detail></extra_xml>", with: "")
                    let data = dataString.data(using: .utf8)
                    var dataArray = [[String: String]]()
                    do {
                        let json: [String: AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
                        if let counter_txns: [[String: String]] = json["data"] as? [[String: String]] {
                            var transDict = [String: String]()
                            for counter_txn in counter_txns {
                                transDict["text"] = counter_txn["text"]
                                transDict["value"] = counter_txn["value"]
                                dataArray.append(transDict)
                            }
                            dataDict[System.Dropdown] = dataArray
                        }
                    } catch {
                        print("error serializing JSON: \(error)")
                    }
                    
                    let err = MyError(message: errMsg)
                    callback?(true, err, dataDict)
                    
                } else {
                    log.error("xmlDoc nil: \(String(describing: xmlDoc))")
                    let err = MyError(message: MyMessage.failedToParseReponseBody)
                    callback?(false, err, dataDict)
                }
            })
        }
    }
    
    func getFeedDropdownList(key: String, callback: ((_ success: Bool, _ fail: MyError, _ dataDict: [String: Any]) -> Void)?) {
        var dataDict = Dictionary<String, Any>()
        if !connectedToNetwork(){
            let err = MyError(message: "No Internet Connection.")
            callback?(false, err, dataDict)
            return
        }
        
        let bodyString = xmlBuilder.getValueFromGlobalConfigXML(key: key)
        
        if bodyString == "" {
            let err = MyError(message: MyMessage.failedToCreateRequestBody)
            callback?(false, err, dataDict)
            return
        }
        
        httpClient.postAndDecodeData(path: Paths.defaultPath, body: (bodyString.data(using: .utf8))! as NSData) {
            (decodedData, response, error) in
            
            self.setupXMLDocument(xmlData: decodedData!, response: response, error: error, callback: {
                (success, xmlError, xmlDoc) in
                
                let errMsg = xmlError.message
                
                if !success {
                    let err = MyError(message: errMsg)
                    callback?(false, err, dataDict)
                    return
                }
                
                if let xmlDoc = xmlDoc {
                    
                    log.debug("\(xmlDoc.xml)")
                    
                    // Parse extra xml
                    
                    let availableData = xmlDoc.root["extra_xml"].xmlCompact
                    var dataString = self.replaceUnescapeString(text: availableData)
                    dataString = dataString.replacingOccurrences(of: "<extra_xml><data_detail>", with: "")
                    dataString = dataString.replacingOccurrences(of: "</data_detail></extra_xml>", with: "")
                    let data = dataString.data(using: .utf8)
                    var dataArray = [[String: String]]()
                    do {
                        let json: [String: AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
                        if let counter_txns: [[String: String]] = json["feedstock"] as? [[String: String]] {
                            var transDict = [String: String]()
                            for counter_txn in counter_txns {
                                //transDict["text"] = counter_txn["unit"]
                                transDict["text"] = counter_txn["key"]
                                transDict["value"] = counter_txn["key"]
                                dataArray.append(transDict)
                            }
                            dataDict[System.Dropdown] = dataArray
                        }
                    } catch {
                        print("error serializing JSON: \(error)")
                    }
                    
                    let err = MyError(message: errMsg)
                    callback?(true, err, dataDict)
                    
                } else {
                    log.error("xmlDoc nil: \(xmlDoc)")
                    let err = MyError(message: MyMessage.failedToParseReponseBody)
                    callback?(false, err, dataDict)
                }
            })
        }
    }

    func setNotification(user: String, key: String, set_flag: String, callback: ((_ success: Bool, _ fail: MyError?, _ dataDict: [String: Any]) -> Void)?){
        
        // Initialize return variables
        var dataDict = Dictionary<String, Any>()
        var successFlag = false
        var errMsg = ""
        
        // Generate XML
        let bodyString = xmlBuilder.notiXMLBuilder(user: user, key: key, set_flag: set_flag)
        
        if !connectedToNetwork(){
            let err = MyError(message: "No Internet Connection.")
            callback?(false, err, dataDict)
            return
        }
        
        // Make request
        httpClient.postAndDecodeData(path: Paths.defaultPath, body: bodyString.data(using: .utf8)! as NSData) { (decodedData, response, error) in
            if error != nil {
                errMsg = (error?.localizedDescription)! 
                
                let err = MyError(message: errMsg)
                callback?(false, err, dataDict)
                return
            }
            
            let string = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)
            log.debug("data = \(string!)\n\n\n")
            
            self.setupXMLDocument(xmlData: decodedData! as Data, options: nil, respose: response, error: error, callback: {
                (success, xmlError, xmlDoc) in
                
                errMsg = xmlError.message
                
                if !success {
                    if xmlDoc != nil {
                        let err: MyError
                        if let errorCode = xmlDoc!.root.attributes["result_code"] {
                            err = MyError(code: errorCode, message: errMsg)
                        } else {
                            log.error("Unknown error : \(errMsg)")
                            err = MyError(message: errMsg)
                        }
                        callback?(successFlag, err, dataDict)
                        return
                    } else {
                        // request timed out, server down
                        let err = MyError(code: "1", message: errMsg)
                        callback?(successFlag, err, dataDict)
                        return
                    }
                }
                
                if let xmlDoc = xmlDoc {
                    log.debug("\(xmlDoc.xml)")
                    
                    // Parse extra xml
                    let availableData = xmlDoc.root["extra_xml"].xmlCompact
                    var dataString = self.replaceUnescapeString(text: availableData)
                    dataString = dataString.replacingOccurrences(of: "<extra_xml><data_detail>", with: "")
                    dataString = dataString.replacingOccurrences(of: "</data_detail></extra_xml>", with: "")
                    let data = dataString.data(using: .utf8)
                    do {
                        let json: [String: AnyObject] = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject]
                        if let counter_txns: [[String: String]] = json["data"] as? [[String: String]] {
                            var transDict = [String: String]()
                            for counter_txn in counter_txns {
                                transDict[counter_txn["key"]!] = counter_txn["value"]
                            }
                            dataDict[System.Message] = transDict
                        }
                    } catch {
                        print("error serializing JSON: \(error)")
                    }
                    successFlag = true
                } else {
                    log.error("xmlDoc nil: \(String(describing: xmlDoc))")
                    errMsg = MyMessage.failedToParseReponseBody
                }
                let err = MyError(message: errMsg)
                callback?(successFlag, err, dataDict)
            })
        }
        
    }
    
    // MARK: - Helper Methods
    
    private func encodePTTDataFromString(string: String) -> NSData? {
        
        let toEscape = "~!@#$%^&*(){}[]=:/,;?+'\"\\"
        
        let escapedString = String(CFURLCreateStringByAddingPercentEscapes(nil, string as CFString?, nil, toEscape as CFString?, CFStringConvertNSStringEncodingToEncoding(String.Encoding.utf8.rawValue)))
        
        //let escapedString = string.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        
        return escapedString.data(using: String.Encoding.utf8) as NSData?
        
    }
    
    private func setupXMLDocument(xmlData: NSData, response: URLResponse!, error: NSError!, callback: (_ success: Bool, _ fail: MyError, _ XMLDoc: AEXMLDocument?) -> Void) {
        setupXMLDocument(xmlData: xmlData as Data, options: nil, respose: response, error: error, callback: callback)
    }
    
    private func setupXMLDocument(xmlData: Data, options: Dictionary<String, AnyObject>?, respose response: URLResponse!, error: NSError!, callback: (_ success: Bool,_ fail: MyError, _ XMLDoc: AEXMLDocument?) -> Void) {
        
        // Request Error Handling
        if error != nil {
            callback(false, MyError(message: error.localizedDescription), nil)
            return
        }
        
        // Parse XML
        do {
            var options = AEXMLOptions()
            options.parserSettings.shouldTrimWhitespace = false
            let xmlObj = try AEXMLDocument.init(xml: xmlData, options: options)
            // Check status
            
            if xmlObj.root.attributes["result_status"] != nil && (xmlObj.root.attributes["result_status"])?.uppercased() != "FAIL" {
            //if xmlObj.root.attributes["result_status"] == "SUCCESS" {
                let err = MyError(message: "")
                callback(true, err, xmlObj)
            } else {
                // Handle Server Response Error
                log.error("result status not success \(xmlObj.xml)")
                
                if let errorCode = xmlObj.root.attributes["result_code"], let errorMessage = xmlObj.root.attributes["response_message"]{
                    
                    log.error("message to respond = \(errorMessage)")
                    callback(false, MyError(code: errorCode, message: errorMessage), xmlObj)
                    
                } else {
                    log.error(xmlObj.root.attributes["result_desc"])
                    callback(false, MyError(message: "No response from server"), xmlObj)
                }
            }
        } catch let xmlError as NSError {
            // Handle Data Error
            log.error("create xml document failed \(xmlError)")
            log.error("xmlData = \(String(describing: String(data: xmlData, encoding: String.Encoding.utf8)))")
            let err = MyError(message: "Connection Error. Please try again") //let err = MyError(message: "XML Corrupted")
            callback(false, err, nil)
        }
    }
    
    private func setupXMLFromString(text: String) -> AEXMLDocument {
        // Parse XML
        do {
            let xmlObj = try AEXMLDocument(xml: text)
            return xmlObj
        } catch let xmlError as NSError {
            // Handle Data Error
            log.error("create xml document failed \(xmlError)")
            //log.error("Text = " + text)
        }
        return AEXMLDocument()
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
    
    private var httpClient: HTTPClient
    private let xmlBuilder = XMLBuilder.shareInstance
    private struct Paths {
        static let defaultPath = "/ServiceProvider/ProjService.svc/CallService/"
        static let pdfPath = "/Web/Report/TmpFileEnc/"
    }
    
}
