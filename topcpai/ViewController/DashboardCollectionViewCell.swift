//
//  DashboardCollectionViewCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 22/4/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var vwCounter: UIView!
    @IBOutlet weak var lblCounter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
    }
    
    
    func setImageView(systemType: String) {
        imgIcon.image = UIImage.init(named: getImageName(systemType: systemType))
    }
    
    func setCounter(Num: String) {
        if Num == "0" || Num == "" {
            vwCounter.isHidden = true
        } else {
            vwCounter.isHidden = false
            lblCounter.text = "\(Num)"
        }
       
    }
    
    private func getImageName(systemType: String) -> String {
        switch systemType {
        case System.Crude:
            return "dashboard_crude_purchase"
        case System.Bunker:
            return "dashboard_bunker"
        case System.Chartering:
            return "dashboard_chartering"
        case System.VCool:
            return "dashboard_vcool"
        case System.Crude_O:
            return "dashboard_crude_sale"
        case System.Demurrage:
            return "dashboard_demurrage"
        case System.Hedge_sett:
            return "dashboard_settlement_memo"
        case System.Hedge_tckt:
            return "dashboard_hedging_ticket"
        case "PRODUCT_SALE":
            return "dashboard_product_sale"
        case "PRODUCT_PURCHASE":
            return "dashboard_product_purchase"
        case System.Hedge_Bot:
            return "dashboard_hedging_bot"
        default:
            return ""
        }
    }
}
