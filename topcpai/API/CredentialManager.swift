//
//  CredentialManager.swift
//  ICTPocketPay
//

import Foundation
import SwiftKeychainWrapper
import CryptoSwift

// swiftlint:disable type_body_length
class CredentialManager: NSObject {
    
    // MARK: - Variables
    static let shareInstance = CredentialManager()
    
    var custId: String? {
        get {
            return KeychainWrapper.standard.string(forKey:"custId")
        }
        set (value) {
            if let value = value {
                KeychainWrapper.standard.set(value, forKey: "custId")
            } else {
                KeychainWrapper.standard.set("", forKey: "custId")
            }
        }
    }
    var mobile: String? {
        get {
            return KeychainWrapper.standard.string(forKey:"mobile")
        }
        set (value) {
            if let value = value {
                KeychainWrapper.standard.set(value, forKey: "mobile")
            } else {
                KeychainWrapper.standard.set("", forKey: "mobile")
            }
        }
    }
    
    var birthdateString: String? {
        get {
            return KeychainWrapper.standard.string(forKey:"birthdateString")
        }
        set (value) {
            if let value = value {
                KeychainWrapper.standard.set(value, forKey: "birthdateString")
            } else {
                KeychainWrapper.standard.removeObject(forKey: "birthdateString")
            }
        }
    }
    
    @objc dynamic var name: String? {
        get {
            return KeychainWrapper.standard.string(forKey:"name")
        }
        set(value) {
            if let value = value {
                KeychainWrapper.standard.set(value, forKey: "name")
            } else {
                KeychainWrapper.standard.set("", forKey: "name")
            }
        }
    }
    @objc dynamic var firstName: String? {
        get {
            return KeychainWrapper.standard.string(forKey:"first_name")
        }
        set(value) {
            KeychainWrapper.standard.set(value!, forKey: "first_name")
        }
    }
    @objc dynamic var lastName: String? {
        get {
            return KeychainWrapper.standard.string(forKey:"last_name")
        }
        set(value) {
            KeychainWrapper.standard.set(value!, forKey: "last_name")
        }
    }
    
    var userId: String? {
        get {
            if let userId = KeychainWrapper.standard.string(forKey:"userId") {
                return userId
            } else {
                return ""
            }
        }
        set(value) {
            if let value = value {
                KeychainWrapper.standard.set(value, forKey: "userId")
            } else {
                KeychainWrapper.standard.removeObject(forKey: "userId")
            }
        }
    }
    
    var userPassword: String? {
        get {
            return KeychainWrapper.standard.string(forKey:"userPassword")
        }
        set(value) {
            if let value = value {
                KeychainWrapper.standard.set(value, forKey: "userPassword")
            } else {
                KeychainWrapper.standard.removeObject(forKey: "userPassword")
            }
        }
    }
    
    var userPin: String? {
        get {
            return KeychainWrapper.standard.string(forKey:"userPin")
        }
        set(value) {
            if let value = value {
                KeychainWrapper.standard.set(value, forKey: "userPin")
            } else {
                KeychainWrapper.standard.removeObject(forKey: "userPin")
            }
        }
    }
    
    var accountRowId: String? {
        get {
            return KeychainWrapper.standard.string(forKey:"accountRowId")
        }
        set(value) {
            if let value = value {
                KeychainWrapper.standard.set(value, forKey: "accountRowId")
            } else {
                KeychainWrapper.standard.set("", forKey: "accountRowId")
            }
        }
    }
    
    var accountTable: String? {
        get {
            return KeychainWrapper.standard.string(forKey:"accountTable")
        }
        set(value) {
            if let value = value {
                KeychainWrapper.standard.set(value, forKey: "accountTable")
            }
        }
    }
    
    let fcmTokenKey = MyConfigs.appName.appending("FcmToken")
    var fcmToken: String {
        get {
            if let token = KeychainWrapper.standard.string(forKey: fcmTokenKey) {
                return token
            } else {
                return ""
            }
        }
        set (token) {
            KeychainWrapper.standard.set(token, forKey: fcmTokenKey)
        }
    }
    
    let fcmTopicsKey = MyConfigs.appName.appending("FcmTopics")
    var fcmTopics: String {
        get {
            if let topics = KeychainWrapper.standard.string(forKey: fcmTopicsKey) {
                return topics
            } else {
                return ""
            }
        }
        set (topics) {
            KeychainWrapper.standard.set(topics, forKey: fcmTopicsKey)
        }
    }
    
    // MARK: - init
    
    override init() {
        super.init()
        log.debug("Done initializing")
    }
    
    // MARK: - Methods
    
    private func pathForProfileImageForUserId(userId: String) -> String? {
        return documentsPathForFileName(userId: userId, fileName: userId + ".png")
    }
    
    private func documentsPathForFileName(userId: String, fileName: String) -> String? {
        let paths: [String]? = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        if let documentsPath: String = paths?[0] {
            let userPath = documentsPath.stringByAppendingPathComponent(path: userId.md5())
            
            if !FileManager.default.fileExists(atPath: userPath) {
                do {
                    try FileManager.default.createDirectory(atPath: userPath, withIntermediateDirectories: false, attributes: nil)
                } catch _ {
                }
            }
            
            return userPath.stringByAppendingPathComponent(path: fileName)
        } else {
            log.error("Failed to unwrap path \(String(describing: paths))")
            return nil
        }
    }
    
    func login(userId: String, password: String, callback: ((_ success: Bool, _ error: MyError?, _ dataDict: [String: Any]) -> Void)?) {
        APIManager.shareInstance.requestLogin(userId: userId, userPassword: password) {
            (success, apiError, dataDict) in
            if success {
                log.debug("login successful")
                
                self.name    = dataDict["name"] as? String
                self.firstName = dataDict["first_name"] as? String
                self.lastName = dataDict["last_name"] as? String
                self.mobile  = dataDict["mobile"] as? String
                self.birthdateString = dataDict["birthdate"] as? String
                self.custId  = dataDict["cust_id"] as? String
                self.userId  = dataDict["user_id"] as? String
                self.accountTable = dataDict["account_table"] as? String
                self.accountRowId = dataDict["account_rowid"] as? String
                
                if let fcmTopics = dataDict["gcm_topics"] as? String {
                    log.debug("FCM topic : \(fcmTopics)")
                    if fcmTopics == CredentialManager.shareInstance.fcmTopics {
                        // same topic, don't have to re subscribe
                    } else {
                        CredentialManager.shareInstance.fcmTopics = fcmTopics
                        // topic changed, subscribe
                        let topics = fcmTopics.split(separator: "|")
                        for topic in topics {
                            FCMUtilities.subscribeTopic(topicName: topic)
                        }
                    }
                }
            }
            callback?(success, apiError, dataDict)
        }
    }
}
