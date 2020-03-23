//
//  UserMobileMenu.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 3/22/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation

class UserMobileMenuList : NSObject{
    var menu : NSArray = []
    init(dataDict : NSDictionary){
        if dataDict["menu"] as? NSArray != nil{
            let arr = NSMutableArray()
            let dict = dataDict["menu"]  as! NSArray
            for x in dict{
                let data = x as! NSDictionary
                arr.add(UserMobileMenuItem.init(dataDict: data))
            }
            self.menu = arr.copy() as! NSArray
        }
    }
}

class UserMobileMenuItem : NSObject{
    var name: String = ""
    var tab: String = ""
    var status: String = ""
    var tabName: String = ""
    var desc: String = ""
    var order: String = ""
    
    init(dataDict : NSDictionary){
        if dataDict["name"] as? String != nil{
            self.name = dataDict["name"] as! String
        }
        if dataDict["tab"] as? String != nil{
            self.tab = dataDict["tab"] as! String
        }
        if dataDict["status"] as? String != nil{
            self.status = dataDict["status"] as! String
        }
        if dataDict["tab_name"] as? String != nil {
            self.tabName = dataDict["tab_name"] as! String
        }
        if dataDict["order"] as? String != nil {
            self.order = dataDict["order"] as! String
        }
        if dataDict["desc"] as? String != nil {
            self.desc = dataDict["desc"] as! String
        }
    }
}
