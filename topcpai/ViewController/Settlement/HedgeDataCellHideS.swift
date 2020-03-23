//
//  HedgeDataCellHideS.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 9/1/2561 BE.
//  Copyright © 2561 PTT ICT Solutions. All rights reserved.
//

import Foundation
class HedgingDataCellHideS: BaseDataCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    
    @IBOutlet weak var hdrSettlementNo: UILabel!
    @IBOutlet weak var hdrCompany: UILabel!
    @IBOutlet weak var hdrSettPeriod: UILabel!
    @IBOutlet weak var hdrType: UILabel!
    
    @IBOutlet weak var lblSettlementNo: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblSettPeriod: UILabel!
    @IBOutlet weak var lblType: UILabel!
    
    @IBOutlet weak var imgArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setCell(data : [String: Any]) -> CGFloat {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        
        type = data["type"]! as! String
        transaction_id = data["transaction_id"]! as! String
        req_txn_id = data["req_transaction_id"]! as! String
        
        lblSettlementNo.text = data["purchase_no"] as? String ?? "-"
        lblCompany.text = data["company"] as? String ?? "-"
        lblSettPeriod.text = data["settlement_period"] as? String ?? "-"
        lblType.text = data["frame_type"] as? String ?? "-"
        
        var height: CGFloat = 0
        height += Test(heightForView(lblSettlementNo, 0) + 5, heightForView(hdrSettlementNo, 0) + 5)
        height += Test(heightForView(lblCompany, 0) + 5, heightForView(hdrCompany, 0) + 5)
        height += Test(heightForView(lblSettPeriod, 0) + 5, heightForView(hdrSettPeriod, 0) + 5)
        height += Test(heightForView(lblType, 0) + 5, heightForView(hdrType, 0) + 5)
        return height + 20
    }
}
