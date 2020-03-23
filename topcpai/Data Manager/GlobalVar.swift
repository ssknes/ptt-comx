//
//  GlobalVar.swift
//  PocketPay
//

import Foundation
import UIKit

class GlobalVar {
    static let sharedInstance = GlobalVar()
    
    //let appMode = WorkMode.UAT
//    let appMode = WorkMode.PRD
    let appMode = WorkMode.DEV
    //let appMode = WorkMode.PPRD
    
    let mockMenu = false
    let mockSkipLogin = false
    let mockNotification = false

    let defaults = UserDefaults.standard
    
    var appVersion = Bundle.main.releaseVersionNumber
    
    var userInfo: [AnyHashable : Any]!
    
    var userMobileMenu : UserMobileMenuList?
    
    var FrontData = [UserMobileMenuItem]()
    var BadgeData = [String]()
    var canAccessView = [Bool]()
    
    //Notification
    var openFromNoti = false
    var purchaseIDNoti = ""
    var page = ""
    
    var tempSecKey: SecKey?
    
    var dashboardShowTask: Bool = true
    
    let detailViewGap: CGFloat = 120
    
    private var fontNumber = 0
    
    func changeFontNumber() {
        fontNumber += 1
        if fontNumber == 5 {
            fontNumber = 0
        }
    }
    
    func getFontSize() -> CGFloat {
        return CGFloat(16 + 2 * fontNumber)
    }
    
    func getSmallFontSize() -> CGFloat {
        return CGFloat(10 + 2 * fontNumber)
    }
    
    func restoreDefaultValue() {
        dashboardShowTask = true
        openFromNoti = false
        purchaseIDNoti = ""
        page = ""
    }
    
    func getOrder(Name: String) -> Int {
        for item in FrontData where item.name.lowercased() == Name.lowercased(){
            return (Int(item.order)! - 1)
        }
        return -1
    }
    
    let mockVCoolData = false
    
}
