//
//  Type24DataCellF.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 9/14/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
class Type24DataCellF: BaseDataCell {
    @IBOutlet weak var btnCollection: UICollectionView!
    @IBOutlet weak var cellScrollView: UIScrollView!
    
    @IBOutlet weak var lblFormID: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblLoadingPeriod: UILabel!
    @IBOutlet weak var lblRequestedBy: UILabel!
    
    var showFreight: Bool = true
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func initView() {
        for i in 0...4 {
            let tempView = Type24dataView()
            tempView.showFreight = true
            tempView.frame = CGRect.init(x: i * 120, y: 0, width: 120, height: Int(cellScrollView.frame.size.height))
            self.cellScrollView.addSubview(tempView)
        }
    }
}
