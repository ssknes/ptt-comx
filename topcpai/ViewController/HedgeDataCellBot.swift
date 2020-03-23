//
//  HedgeDataCellBot.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/1/2563 BE.
//  Copyright © 2563 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class HedgeDataCellBot: BaseDataCell {
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSystem: UILabel!
    @IBOutlet weak var conTableView: NSLayoutConstraint!
    @IBOutlet weak var btnCollection: UICollectionView!
    @IBOutlet weak var vwLine : UIView!
    
    private var frameType: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        mainTableView.register(UINib.init(nibName: "ListDataCell", bundle: nil), forCellReuseIdentifier: "cell")
        mainTableView.register(UINib.init(nibName: "ListDataCell2", bundle: nil), forCellReuseIdentifier: "cell2")
        btnCollection.register(UINib.init(nibName: "CrudeButtonCell", bundle: nil), forCellWithReuseIdentifier: "btncell")
    }
    
    private var reqTransactionId: String {
        let unixTimeStamp = Int(NSDate().timeIntervalSince1970)
        return "\(MyUtilities.randomInt(min: 0, max: 9999999))\(unixTimeStamp)"
    }
    
    func setCell(Data: [String: Any]) -> CGFloat {
        addDashLine(layer: vwLine.layer)
        transaction_id = Data["bot_rowid"] as! String
        system = Data["system"] as? String ?? ""
        lblDate.text = Data["bot_created_date"] as? String
        lblSystem.text = Data["system_type"] as? String ?? ""
        
        value.removeAll()
        header.removeAll()
        cellHeight.removeAll()
        
        appendValue(hd: "File Name :", val: Data["bot_file_name"] as? String ?? "-", noValueHide: false)
        appendValue(hd: "Trading Book :", val: Data["bot_trading_book"] as? String ?? "-", noValueHide: false)
        appendValue(hd: "Period :", val: Data["bot_period"] as? String ?? "-", noValueHide: false)
        makeCellHeight()
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

extension HedgeDataCellBot: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListDataCell
            cell.delegate = self
            cell.setupView(header: header[indexPath.row], value: value[indexPath.row], bold: true)
            cell.layoutIfNeeded()
            return cell
        } else {
            if header[indexPath.row].lowercased().contains("brief") {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! ListDataCell2
                cell.delegate = self
                cell.setupView(header: header[indexPath.row], value: value[indexPath.row], bold: false, arrButton: btnData)
                cell.layoutIfNeeded()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListDataCell
                cell.delegate = self
                cell.setupView(header: header[indexPath.row], value: "", bold: false)
                HedgeCellSUtility.Shared.setText(Index: indexPath.row, Label: cell.lblValue, Value: value[indexPath.row], FrameType: frameType)
                cell.layoutIfNeeded()
                return cell
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight[indexPath.row]
    }
}
