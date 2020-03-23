//
//  BaseDataCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/25/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

protocol BaseDataCellDelegate: class {
    func onActionButton(view: UIAlertController)
    func onActionButtonAsSubview(view: UIViewController)
    func showLoadingHud(text: String)
    func onActionButtonResult(Success: Bool, xmlError: MyError, dataDict: [String : Any])
    func onActionButtonPDF(button: ActionButton)
    func onActionBrief(ID: String, Value: String)
    func setBrief(Value: String)
}

class BaseDataCell: UITableViewCell {
    var btnData = [Button]()
    var type = ""
    var transaction_id = ""
    var req_txn_id = ""
    var row = -1
    var userGroup = ""
    var status = ""
    var underLine = UIView()
    var system = ""
    var system_type = ""
    var pageTitle = ""
    var cellData = [String: Any]()
    //Cell Display data
    var cellHeight = [CGFloat]()
    var value = [String]()
    var header = [String]()
    weak var BaseDelegate: BaseDataCellDelegate?
    
    var txtBrief = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //New
    func calcHeight(lblHead: String, lblVal: String) -> CGFloat {
        let font = UIFont.init(name: "Kanit-Light", size: GlobalVar.sharedInstance.getFontSize()) //Wait for get font size
        var widthIndex: CGFloat = 0.65
        var briefGap: CGFloat = 1
        if lblHead.lowercased().contains("brief") {
            widthIndex = 1
            briefGap = 30
        }
        let width1 = (UIScreen.main.bounds.size.width - 20) * widthIndex
        let width2 = (UIScreen.main.bounds.size.width - 30) - ((UIScreen.main.bounds.size.width - 20) * 0.65)
        let label1: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width1, height: CGFloat.greatestFiniteMagnitude))
        label1.numberOfLines = 0
        label1.lineBreakMode = NSLineBreakMode.byWordWrapping
        label1.font = font
        if lblHead.lowercased().contains("brief") {
            label1.text = lblVal.html2String
        } else {
            label1.text = lblVal
        }
        label1.sizeToFit()
        
        let label2: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width2, height: CGFloat.greatestFiniteMagnitude))
        label2.numberOfLines = 0
        label2.lineBreakMode = NSLineBreakMode.byWordWrapping
        label2.font = font
        label2.text = lblHead
        label2.sizeToFit()
        
        if label1.frame.size.height > label2.frame.size.height {
            return label1.frame.size.height + briefGap + 6
        } else {
            return label2.frame.size.height + briefGap + 6
        }
    }
    
    func addDashLine(layer: CALayer) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [3,3]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x:0, y: 0), CGPoint(x:layer.frame.size.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    //Old
    
    func heightForView(_ TextField: UILabel) -> CGFloat {
        let text = TextField.text
        let font = TextField.font
        let width = TextField.frame.size.width
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        if label.frame.height < 36 { // set for minimum
            return 36
        }
        return label.frame.height
    }
    func heightForView(_ TextField: UILabel, _ Min: CGFloat) -> CGFloat {
        let text = TextField.text
        let font = TextField.font
        let width = TextField.frame.size.width
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        if label.frame.height < Min { // set for minimum
            return Min
        }
        return label.frame.height
    }
    
    func heightForViewWithHide(_ TextField: UILabel, _ Minimum: CGFloat) -> CGFloat {
        let text = TextField.text
        let font = TextField.font
        let width = TextField.frame.size.width
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        if TextField.text?.count == 0 {
            return 0
        }
        
        if label.frame.height < Minimum { // set for minimum
            return Minimum
        }
        return label.frame.height
    }
    
    func Test(_ num1: CGFloat,_ num2: CGFloat) -> CGFloat{
        if num1 < num2 {
            return num2
        }
        return num1
    }
    
    func heightForViewWithString(_ Text: String, _ Font: UIFont, _ Width: CGFloat) -> CGFloat {
        let text = Text
        let font = Font
        let width = Width
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        if label.frame.height < 32 { // set for minimum
            return 32
        }
        return label.frame.height
    }
    func heightForViewWithString(_ Text: String , _ Width: CGFloat, _ Min: CGFloat) -> CGFloat {
        let text = Text
        let font = UIFont.systemFont(ofSize: 15)
        let width = Width
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        if label.frame.height < Min { // set for minimum // 32
            return Min
        }
        return label.frame.height
    }
    
    func heightForViewWithWidth(_ Text: UILabel , _ Width: CGFloat) -> CGFloat {
        let text = Text.text
        let font = Text.font
        let width = Width
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        if label.frame.height < 36 { // set for minimum
            return 36
        }
        return label.frame.height
    }
    func heightForViewWithWidthMin0(_ Text: UILabel , _ Width: CGFloat) -> CGFloat {
        let text = Text.text
        let font = Text.font
        let width = Width
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    func heightForViewWithAtt(_ htmlString: NSAttributedString, w: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.attributedText = htmlString
        label.sizeToFit()
        if label.frame.height < 44 {
            return 44
        }
        return label.frame.height
    }
    
    func shortMonthDateFormatter(dateStr: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        dateFormatter.locale = Locale.init(identifier: "EN_US")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.dateFormat = "dd-MMM-yyy"
            return dateFormatter.string(from: (date))
        }
        return dateStr
    }
    
    func setText(_ Text: Any?, _ Label: UILabel, _ Minumum: CGFloat) -> CGFloat {
        if Text as? String != nil {
            if (Text as! String).trim().length == 0 {
                return 0
            }
            Label.text = Text as? String
        } else {
            Label.text = ""
            return 0
        }
        let temp = heightForView(Label)
        if Minumum < temp {
            return temp
        }
        return Minumum
    }
    
    func getBriefText(def: String) -> String {
        if self.txtBrief != "" {
            return txtBrief
        }
        self.txtBrief = def
        //BaseDelegate?.setBrief(Value: def)
        return def
    }
}

extension BaseDataCell: CrudeButtonCellDelegate {
    func onActionButton(view: UIAlertController) {
        BaseDelegate?.onActionButton(view: view)
    }
    
    func onActionButtonResult(Success: Bool, xmlError: MyError, dataDict: [String : Any]) {
        BaseDelegate?.onActionButtonResult(Success: Success, xmlError: xmlError, dataDict: dataDict)
    }
    
    func onActionButtonAsSubview(view: UIViewController) {
        BaseDelegate?.onActionButtonAsSubview(view: view)
    }
    func onActionButtonPDF(button: ActionButton) {
        BaseDelegate?.onActionButtonPDF(button: button)
    }
    
    func showLoadingHud(text: String) {
        BaseDelegate?.showLoadingHud(text: text)
    }
}

extension BaseDataCell: UICollectionViewDataSource , UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.system.lowercased().contains("vcool") {
            return btnData.count
        }
        return btnData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "btncell", for: indexPath) as! CrudeButtonCell
        cell.btnAction.isUserInteractionEnabled = false
        cell.btnAction.Row = row
        cell.userGroup = userGroup
        cell.userStatus = status
        cell.system = system
        cell.PageTitle = pageTitle
        cell.delegate = self
        cell.data = cellData
        if self.system.lowercased().contains("vcool") {
            cell.Size = CGFloat(btnData.count)
        } else {
            cell.Size = CGFloat(btnData.count + 1)
        }
        let numberOfButton: CGFloat = 4
        let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - 20) / numberOfButton
        let startPos = (UIScreen.main.bounds.size.width - (cellWidth * cell.Size)) / 2
        let PosX = startPos + (CGFloat(indexPath.item) * cellWidth)
        cell.frame = CGRect.init(x: PosX, y: 0, width: cellWidth, height: 50)
        
        if indexPath.item == btnData.count {
            cell.btnAction.setTitle(getAttachmentTitle(), for: .normal)
            cell.btnAction.name = "PRINT"
            cell.btnAction.type = type
            cell.btnAction.transaction_id = transaction_id
            cell.btnAction.backgroundColor = UIColor.init(red: 132/255, green: 132/255, blue: 134/255, alpha: 1)
            cell.btnAction.layer.cornerRadius = 3
            cell.btnAction.titleLabel?.font =  UIFont(name: (cell.btnAction.titleLabel?.font.fontName)!, size: 12)
            return cell
        }
        cell.btnAction.call_xml = btnData[indexPath.item].call_xml
        cell.btnAction.name = btnData[indexPath.item].name
        cell.btnAction.type = type
        cell.btnAction.transaction_id = transaction_id
        cell.btnAction.req_txn_id = req_txn_id
        if btnData[indexPath.item].name.lowercased() == "approve" || btnData[indexPath.item].name.lowercased().contains("verif") ||
            btnData[indexPath.item].name.lowercased().contains("endor"){//} == "verified" {
            cell.btnAction.backgroundColor = UIColor.init(red: 230/255, green: 62/255, blue: 156/255, alpha: 1)
        } else {
            cell.btnAction.backgroundColor = UIColor.init(red: 132/255, green: 132/255, blue: 134/255, alpha: 1)
        }
        cell.btnAction.layer.cornerRadius = 3 //cell.btnAction.frame.size.height / 2
        cell.btnAction.titleLabel?.font =  UIFont(name: (cell.btnAction.titleLabel?.font.fontName)!, size: 12)
        cell.btnAction.setTitle(cell.btnAction.name, for: .normal)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CrudeButtonCell
        cell.onButtonClick([:], brief: self.txtBrief)
    }
    func getAttachmentTitle() -> String {
        if system == System.Hedge_Bot {
            return "VIEW"
        }
        return "ATTACHMENT"
    }
}

extension BaseDataCell: ListDataCellDelegate {
    func onBtnBriefEdit(Value: String) {
        BaseDelegate?.onActionBrief(ID: req_txn_id, Value: Value)
    }
}
