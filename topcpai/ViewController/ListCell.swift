//
//  ListCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 24/4/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

protocol ListCellDelegate: class {
    func onBtnMore(_ Sender: UIButton)
}

class ListCell: UITableViewCell {
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSystem: UILabel!
    @IBOutlet weak var conTableView: NSLayoutConstraint!
    @IBOutlet weak var btnMore: UIButton!
    
    var cellHeight = [CGFloat]()
    var value = [String]()
    var header = [String]()
    
    weak var delegate: ListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        mainTableView.contentInsetAdjustmentBehavior = .never
        mainTableView.register(UINib.init(nibName: "ListDataCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    func doSelect() {
        self.onBtnMore(self.btnMore)
    }
    
    @IBAction func onBtnMore(_ Sender: UIButton) {
        Sender.tag = self.tag
        delegate?.onBtnMore(Sender)
    }
    
    func setView(Data: [String: Any]) -> CGFloat {
        log.info("Data ===>\(Data)")
        lblDate.text = getDateString(Data: Data)
        lblSystem.text = getSystemName(Data: Data)
        conTableView.constant = setTableValue(Data: Data)
        mainTableView.reloadData()
        layoutIfNeeded()
        //return lblSystem.frame.size.height + lblSystem.frame.origin.y + 15
        return conTableView.constant + 50
    }
    
    private func setTableValue(Data: [String: Any]) -> CGFloat {
        value.removeAll()
        header.removeAll()
        cellHeight.removeAll()
        let sys = getSystem(Data: Data)
        switch sys {
        case System.Crude:
            return setTableValueCrudeP(Data: Data)
        case System.Bunker:
            return setTableValueBunker(Data: Data)
        case System.Chartering:
            return setTableValueChartering(Data: Data)
        case System.VCool:
            return setTableValueVcool(Data: Data)
        case System.Demurrage:
            return setTableValueDemurrage(Data: Data)
        case System.Product:
            return setTableValueProduct(Data: Data)
        case System.Crude_O:
            return setTableValueCrudeSale(Data: Data)
        case System.Hedge_sett:
            return setTableValueHedgeSett(Data: Data)
        case System.Hedge_tckt:
            return setTableValueHedgeTckt(Data: Data)
        case System.Hedge_Bot:
            return setTableValueHedgeBot(Data: Data)
        default:
            return 150
        }
    }
    
    private func setTableValueCrudeSale(Data: [String: Any]) -> CGFloat {
        if (Data["system"] as? String ?? "") == System.Crude_O {
            appendValue(hd: "Sale&Re-Optimization No. :", val: Data["doc_no"] as? String ?? "-")
            appendValue(hd: "Status :", val: Data["status"] as? String ?? "")
            appendValue(hd: "Crude Name :", val: Data["crude_name"] as? String ?? "-")
        } else {
            appendValue(hd: "Sale No. :", val: Data["doc_no"] as? String ?? "-")
            appendValue(hd: "Status :", val: Data["status"] as? String ?? "")
            appendValue(hd: "Crude Name :", val: Data["crude_name"] as? String ?? "-")
        }
        appendValue(hd: "Requested By :", val: Data["created_by"] as? String ?? "-")
        makeCellHeight()
        return getTableHeight()
    }
    
    private func setTableValueHedgeBot(Data: [String: Any]) -> CGFloat {
        appendValue(hd: "File Name :", val: Data["bot_file_name"] as? String ?? "-")
        appendValue(hd: "Trading Book :", val: Data["bot_trading_book"] as? String ?? "-")
        appendValue(hd: "Period :", val: Data["bot_period"] as? String ?? "-")
        makeCellHeight()
        return getTableHeight()
    }
    
    private func setTableValueHedgeTckt(Data: [String: Any]) -> CGFloat {
        appendValue(hd: "Ticket No. :", val: Data["ticket_no"] as? String ?? "-")
        appendValue(hd: "Trader :", val: Data["trader"] as? String ?? "-")
        
        if (Data["ticket_type"] as? String ?? "-").lowercased().contains("terminate") {
             appendValue(hd: "Terminate Date :", val: Data["ticket_deal_date"] as? String ?? "-")
        } else {
             appendValue(hd: "Trade Date :", val: Data["ticket_deal_date"] as? String ?? "-")
        }
        appendValue(hd: "Ticket Type :", val: Data["ticket_type"] as? String ?? "-")
        makeCellHeight()
        return getTableHeight()
    }
    
    private func setTableValueHedgeSett(Data: [String: Any]) -> CGFloat {
        appendValue(hd: "Settlement No. :", val: Data["purchase_no"] as? String ?? "-")
        appendValue(hd: "Status :", val: Data["status"] as? String ?? "")
        appendValue(hd: "Company :", val: Data["company"] as? String ?? "-")
        appendValue(hd: "Settlement Period :", val: Data["settlement_period"] as? String ?? "-")
        appendValue(hd: "Type :", val: Data["frame_type"] as? String ?? "-")
        makeCellHeight()
        return getTableHeight()
    }
    
    private func setTableValueProduct(Data: [String: Any]) -> CGFloat {
        appendValue(hd: "Reference No. :", val: Data["doc_no"] as? String ?? "")
        appendValue(hd: "Status :", val: Data["doc_status"] as? String ?? "")
        appendValue(hd: "Transaction For :", val: Data["doc_for"] as? String ?? "")
        appendValue(hd: "Request By :", val: Data["created_by"] as? String ?? "")
        makeCellHeight()
        return getTableHeight()
    }
    
    private func setTableValueDemurrage(Data: [String: Any]) -> CGFloat {
        appendValue(hd: "Refference No. :", val: Data["purchase_no"] as? String ?? "")
        appendValue(hd: "Status :", val: Data["status"] as? String ?? "")
        appendValue(hd: "Transaction between :", val: Data["for_company"] as? String ?? "")
        appendValue(hd: "Counterparty :", val: Data["counterparty"] as? String ?? "")
        appendValue(hd: "Demurrage type :", val: Data["demurrage_type"] as? String ?? "")
        appendValue(hd: "Vessel name :", val: Data["vessel_name"] as? String ?? "")
        makeCellHeight()
        return getTableHeight()
    }
    
    private func setTableValueVcool(Data: [String: Any]) -> CGFloat {
        appendValue(hd: "Purchase No. :", val: Data["purchase_no"] as? String ?? "")
        appendValue(hd: "Status :", val: Data["status"] as? String ?? "")
        appendValue(hd: "Crude Name :", val: Data["product_name"] as? String ?? "")
        appendValue(hd: "Quantity :", val: "\(Data["quantity_kbbl_max"] as? String ?? "") KBBL")
        makeCellHeight()
        return getTableHeight()
    }
    
    private func setTableValueCrudeP(Data: [String: Any]) -> CGFloat {
        appendValue(hd: "Purchase No. :", val: Data["purchase_no"] as? String ?? "")
        appendValue(hd: "Status :", val: Data["status"] as? String ?? "")
        appendValue(hd: "Crude Name :", val: Data["product_name"] as? String ?? "")
        appendValue(hd: "Supplier :", val: Data["supplier_name"] as? String ?? "")
        appendValue(hd: "Quantity :", val: Data["volumes"] as? String ?? "")
        makeCellHeight()
        return getTableHeight()
    }
    
    private func setTableValueBunker(Data: [String: Any]) -> CGFloat {
        appendValue(hd: "Purchase No. :", val: Data["purchase_no"] as? String ?? "")
        appendValue(hd: "Status :", val: Data["status"] as? String ?? "")
        appendValue(hd: "Vessle :", val: "\(Data["vessel"] as? String ?? "") \(Data["trip_no"] as? String ?? "")")
        appendValue(hd: "Grade :", val: BunkerCellUtility.Share.getGrade(data: Data))
        appendValue(hd: "Supplier :", val: Data["supplier"] as? String ?? "")
        appendValue(hd: "Volume :", val: BunkerCellUtility.Share.getVolume(data: Data))
        makeCellHeight()
        return getTableHeight()
    }
    
    private func setTableValueChartering(Data: [String: Any]) -> CGFloat {
        switch Data["function_id"] as? String ?? "" {
        case "26":
            appendValue(hd: "Document No. :", val: Data["purchase_no"]  as? String ?? "")
            appendValue(hd: "Status :", val: Data["status"] as? String ?? "")
            appendValue(hd: "Vessel Name :", val: Data["vessel"] as? String ?? "")
            appendValue(hd: "Charterer :", val: Data["cust_name"] as? String ?? "")
            appendValue(hd: "Ship broker :", val: CharteringCellUtils.Shared.getBrokerName(data: Data))
            appendValue(hd: "WS :", val: Data["ws"] as? String ?? "")
        case "7":
            appendValue(hd: "Document No. :", val: Data["purchase_no"]  as? String ?? "")
            appendValue(hd: "Status :", val: Data["status"] as? String ?? "")
            appendValue(hd: "Vessel Name :", val: Data["vessel"] as? String ?? "")
            appendValue(hd: "Charterer :", val: Data["cust_name"] as? String ?? "")
            appendValue(hd: "Broker :", val: CharteringCellUtils.Shared.getBrokerName(data: Data))
            appendValue(hd: "Laycan :", val: CharteringCellUtils.Shared.getLaycan(data: Data))
        default:
            appendValue(hd: "Purhcase No. :", val: Data["purchase_no"]  as? String ?? "")
            appendValue(hd: "Status :", val: Data["status"] as? String ?? "")
            appendValue(hd: "Vessel Name :", val: Data["vessel"] as? String ?? "")
            appendValue(hd: "Owner :", val: Data["owner"] as? String ?? "")
            appendValue(hd: "Broker :", val: Data["cust_name"] as? String ?? "")
        }
        makeCellHeight()
        return getTableHeight()
    }
    private func getTableHeight() -> CGFloat {
        var tmp: CGFloat = 0
        for item in cellHeight {
            tmp += item
        }
        return tmp
    }
    
    private func appendValue(hd: String, val: String) {
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
    
    private func calcHeight(lblHead: String, lblVal: String) -> CGFloat {
        let font = UIFont.init(name: "Kanit-Light", size: GlobalVar.sharedInstance.getFontSize())
        let width1 = (UIScreen.main.bounds.size.width - 20) * 0.65
        let width2 = (UIScreen.main.bounds.size.width - 30) - width1
        let label1:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width1, height: CGFloat.greatestFiniteMagnitude))
        label1.numberOfLines = 0
        label1.lineBreakMode = NSLineBreakMode.byWordWrapping
        label1.font = font
        label1.text = lblVal
        label1.sizeToFit()
        
        let label2:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width2, height: CGFloat.greatestFiniteMagnitude))
        label2.numberOfLines = 0
        label2.lineBreakMode = NSLineBreakMode.byWordWrapping
        label2.font = font
        label2.text = lblHead
        label2.sizeToFit()
        
        if label1.frame.size.height > label2.frame.size.height {
            return label1.frame.size.height + 6
        } else {
            return label2.frame.size.height + 6
        }
    }
    
    private func getSystem(Data: [String: Any]) -> String {
        if (Data["system"] as? String ?? "").lowercased().contains("product") {
            return System.Product
        }
        return Data["system"] as? String ?? ""
    }
    
    private func getSystemName(Data: [String: Any]) -> String {
        let sys = Data["system_type"] as? String ?? ""
        switch  sys {
        default:
            return sys
        }
    }
    
    private func getDateString(Data: [String: Any]) -> String {
        let sys = getSystem(Data: Data)
        switch sys {
        case System.Crude:
            return Data["date_purchase"] as? String ?? ""
        case System.Bunker:
            return Data["date_purchase"] as? String ?? ""
        case System.Chartering:
            return Data["date_purchase"] as? String ?? ""
        case System.VCool:
            return Data["date_purchase"] as? String ?? ""
        case System.Demurrage:
            return DemurrageCellUtilitiy.Share.getCreateDateString(Data: Data)
        case System.Product:
            return Data["doc_date"] as? String ?? ""
        case System.Crude_O:
            return Data["date_purchase"] as? String ?? ""
        case System.Hedge_sett:
            return Data["created_date"] as? String ?? ""
        case System.Hedge_tckt:
            return Data["ticket_date"] as? String ?? ""
        case System.Hedge_Bot:
            return Data["bot_created_date"] as? String ?? ""
        default:
            return ""
        }
    }
}

extension ListCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ListDataCell
        if indexPath.row == 0 {
             cell.setupView(header: header[indexPath.row], value: value[indexPath.row], bold: true)
        } else {
             cell.setupView(header: header[indexPath.row], value: value[indexPath.row], bold: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight[indexPath.row]
    }
}


