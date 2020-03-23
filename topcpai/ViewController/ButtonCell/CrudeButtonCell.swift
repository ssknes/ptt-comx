//
//  CrudeButtonCell.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 1/4/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

protocol CrudeButtonCellDelegate: class {
    func onActionButton(view: UIAlertController)
    func onActionButtonAsSubview(view: UIViewController)
    func showLoadingHud(text: String)
    func onActionButtonResult(Success: Bool, xmlError: MyError, dataDict: [String: Any])
    func onActionButtonPDF(button: ActionButton)
}

class CrudeButtonCell: UICollectionViewCell {
    @IBOutlet weak var btnAction: ActionButton!
    var Size: CGFloat = 0
    var userGroup: String = ""
    var userStatus: String = ""
    var system: String = ""
    var PageTitle: String = ""
    var data = [String: Any]()
    private var detailBrief: String = ""
    
    weak var delegate: CrudeButtonCellDelegate?
    
    override func awakeFromNib() {
        btnAction.titleLabel?.lineBreakMode = .byWordWrapping
    }
    
    func onButtonClick(_ dict: [String: Any], brief: String) {
        detailBrief = brief
        switch btnAction.name.lowercased() {
        case "print":
            delegate?.onActionButtonPDF(button: btnAction)
        case "reject":
            showAlertReject()
        case "cancel":
            showAlertCancel()
        case "approve":
            showAlertApprove()
        case "request to revise":
            showAlertRequestToRevise()
        case "verify", "verified":
            showAlertVerify(dict)
        case "endorse":
            showAlertEndorse()
        default:
            showAlertApprove()
        }
    }
    
    private func getSystemName() -> String {
        return DataUtils.shared.SysName(system)
    }
    
    private func showAlertReject() {
        switch getSystemName() {
        default:
            self.delegate?.onActionButton(view: getDefaultAlertReject())
        }
    }
    
    private func showAlertCancel() {
        switch getSystemName() {
        default:
            self.delegate?.onActionButton(view: getDefaultAlertCancel())
        }
    }
    
    private func showAlertApprove() {
        switch getSystemName(){
        default:
            self.delegate?.onActionButton(view: getDefaultAlertApprove())
        }
    }
    private func showAlertEndorse() {
        switch getSystemName(){
        case System.Product:
            self.delegate?.onActionButton(view: getDefaultAlertEndorse())
        default:
            self.delegate?.onActionButton(view: getDefaultAlertEndorse())
        }
    }
    
    private func showAlertVerify(_ dict: [String: Any]) {
        switch getSystemName(){
        case System.VCool:
            self.delegate?.onActionButton(view: getVCoolAlertVerify(dict))
        case System.Product:
            self.delegate?.onActionButton(view: getDefaultAlertVerity())
        default:
            self.delegate?.onActionButton(view: getDefaultAlertVerity())
        }
    }
    
    private func showAlertRequestToRevise() {
        switch getSystemName(){
        case System.VCool:
            if userGroup == "SCVP" {
                let vw = VCoolRevisePopup.init()
                vw.view.frame = UIScreen.main.bounds
                vw.initCheckButton()
                vw.txtReason.text = ""
                vw.btn1.isSelected = false
                vw.btn2.isSelected = false
                vw.button = self.btnAction
                vw.delegate = self
                delegate?.onActionButtonAsSubview(view: vw)
            } else {
                let vw = getDefaultAlertWithTextBox(title: "", message: "Note : The transaction can be resubmitted by your subordinate and reapproved by you again. \nPlease state reasons for revise below.", Ok: "OK", Cancel: "Cancel", okAction: { (message) in
                    if message == "-" {
                        let alert = UIAlertController(title: "Sorry", message: "Please enter reason for revise", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                            (action) in
                        })
                        alert.addAction(okAction)
                        self.delegate?.onActionButton(view: alert)
                    } else {
                        self.doButtonProcess(message: message)
                    }
                })
                delegate?.onActionButton(view: vw)
            }
        case System.Crude_O:
            let temp = getDefaultAlertWithTextBox(title: "", message: "Note : The transaction can be resubmitted by your subordinate and reapproved by you again. \nPlease state reasons for revise below.", Ok: "OK", Cancel: "Cancel", okAction: { (message) in
                if message == "-" {
                    let alert = UIAlertController(title: "Sorry", message: "Please enter reason for revise", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                        (action) in
                    })
                    alert.addAction(okAction)
                    self.delegate?.onActionButton(view: alert)
                } else {
                    self.doButtonProcess(message: message)
                }
            })
            delegate?.onActionButton(view: temp)
        default:
            break
        }
    }
    
    private func getDefaultAlertReject() -> UIAlertController {
        switch getSystemName(){
        default: // Crude
            return getDefaultAlertWithTextBox(title: getRejectTitle(), message: getRejectMessage(), Ok: "Ok", Cancel: "Cancel", okAction: { (message) in
                if message == "-" {
                    let alert = UIAlertController(title: "Sorry", message: self.getRejectErrorMsg(), preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                        (action) in
                    })
                    alert.addAction(okAction)
                    self.delegate?.onActionButton(view: alert)
                } else {
                    self.doButtonProcess(message: message)
                }
            })
        }
    }
    
    private func getDefaultAlertCancel() -> UIAlertController {
        switch getSystemName(){
        default:
            return getDefaultAlertWithTextBox(title: getCancelTitle(), message: getCancelMessage()
                , Ok: "Ok", Cancel: "Cancel", okAction: { (message) in
                    self.doButtonProcess(message: message)
            })
        }
    }
    
    private func getDefaultAlertRecall() -> UIAlertController {
        switch  system {
        default:
            return getDefaultAlertWithTextBox(title: "", message: "Reason for recall : The transaction can be resubmit and approve again", Ok: "OK", Cancel: "Cancel", okAction: { (message) in
                if message == "-" {
                    let alert = UIAlertController(title: "Sorry", message: "Please enter reason for recall", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                        (action) in
                    })
                    alert.addAction(okAction)
                    self.delegate?.onActionButton(view: alert)
                } else {
                    self.doButtonProcess(message: message)
                }
            })
        }
    }
    
    private func getDefaultAlertApprove() -> UIAlertController {
        switch getSystemName(){
        case System.VCool:
            return getDefaultAlertWithTextBox(title: "", message: getApproveMessage(), Ok: "OK", Cancel: "Cancel", okAction: { (message) in
                var tmp = message
                if message.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
                    tmp = "-"
                }
                self.doButtonProcess(message: tmp)
            })
        case System.Crude_O:
            return getDefaultAlertWithTextBox(title: "", message: getApproveMessage(), Ok: "OK", Cancel: "Cancel", okAction: { (message) in
                var tmp = message
                if message.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
                    tmp = "-"
                }
                self.doButtonProcess(message: tmp)
            })
        default: // Crude
            return getDefaultAlert(title: getApproveTitle(), message: getApproveMessage(), Ok: "Yes", Cancel: "No", okAction: { (message) in
                self.doButtonProcess(message: "-")
            })
        }
    }
    
    private func getVCoolAlertVerify(_ dict: [String: Any]) -> UIAlertController {
        if dict.count == 0 {
            return getDefaultAlert(title: getApproveTitle(), message: "Are you sure to verify?", Ok: "YES", Cancel: "NO", okAction: { (message) in
                var jsonData: Data = Data()
                var jsonString = ""
                do {
                    jsonData = try JSONSerialization.data(withJSONObject: dict, options: .init(rawValue: 0))
                    jsonString = String(data: jsonData, encoding: .utf8)!// .ascii)!
                    jsonString = jsonString.replacingOccurrences(of: "\\", with: "")
                    jsonString = jsonString.toBase64()
                } catch {
                    print("error")
                }
                APIManager.shareInstance.sendXMLFromButtonRevise(system: self.system, type: self.btnAction.type, xml: self.btnAction.call_xml, req_txn_id: self.btnAction.req_txn_id, note: message, jsonData: jsonString, txtBrief: self.detailBrief) { (success, xmlError, dataDict) in
                    self.delegate?.onActionButtonResult(Success: success, xmlError: xmlError, dataDict: dataDict)
                }
            })
        } else {
            return getDefaultAlert(title: getApproveTitle(), message: "Are you sure to verify?", Ok: "YES", Cancel: "NO", okAction: { (message) in
                self.doButtonProcess(message: "-")
            })
        }
    }
    
    private func getDefaultAlertVerity() -> UIAlertController {
        switch getSystemName(){
        case System.Product:
            return getDefaultAlert(title: getApproveTitle(), message: "Are you sure to verify?", Ok: "YES", Cancel: "NO", okAction: { (message) in
                self.doButtonProcess(message: "-")
            })
        default:
            return getDefaultAlert(title: getApproveTitle(), message: "Are you sure to verify?", Ok: "YES", Cancel: "NO", okAction: { (message) in
                self.doButtonProcess(message: "-")
            })
        }
    }
    
    private func getDefaultAlertEndorse() -> UIAlertController {
        switch getSystemName(){
        case System.Product:
            return getDefaultAlert(title: getApproveTitle(), message: "Are you sure to endorse?", Ok: "YES", Cancel: "NO", okAction: { (message) in
                self.doButtonProcess(message: "-")
            })
        default:
            return getDefaultAlert(title: getApproveTitle(), message: "Are you sure to endorse?", Ok: "YES", Cancel: "NO", okAction: { (messge) in
                self.doButtonProcess(message: "-")
            })
        }
    }
    
    
    private func getRejectTitle() -> String {
        switch getSystemName(){
        default:
            return ""
        }
    }
    private func getCancelTitle() -> String {
        switch getSystemName(){
        default:
            return ""
        }
    }
    
    private func getRejectMessage() -> String {
        switch getSystemName(){
        case System.VCool:
            if userGroup == "CMCS_SH" || userGroup == "SCSC_SH" || userGroup == "SCEP_SH" || (userGroup == "CMVP" && userStatus == "WAITING APPROVE PRICE") {
                return "Note : The transaction can be resubmitted by your subordinate and reverify by you again. \n Please state reasons for reject below."
            }
            if userGroup == "EVPC" {
                return "Warning : If you \"REJECT\", this workflow will be terminated and required be created again."
            }
            return "Warning : If you \"REJECT\", this workflow will be terminated and required be created again.\n In case you wish to only revise your subordinate work, please click \"REQUEST TO REVISE\" instead.\nPlease state reasons for reject below."
        default:
            return "Reason for reject : The transaction can be resubmit and approve again"
        }
    }
    
    private func getRejectErrorMsg() -> String {
        switch getSystemName(){
        default:
            return "Please enter reason for reject"
        }
    }
    
    private func getCancelMessage() -> String {
        switch getSystemName(){
        default:
            return  "Reason for cancel : The transaction cannot be reused."
        }
    }
    private func getApproveTitle() -> String {
        switch getSystemName(){
        default:
            return PageTitle
        }
    }
    private func getApproveMessage() -> String {
        switch getSystemName(){
        case System.Crude_O:
            return "Reason for approval"
        case System.VCool:
            return "Please state reasons for approve below"
        default:
            return "Are you sure to approve?"
        }
    }
    
    private func getDefaultAlert(title: String, message: String, Ok: String, Cancel: String, okAction: ((_ message: String) -> Void)?) -> UIAlertController {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Ok, style: .default, handler: {
            (action) in
            if let ok = okAction {
                ok("-")
            }
        })
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: Cancel, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        return alert
    }
    
    private func getDefaultAlertWithTextBox(title: String, message: String, Ok: String, Cancel: String, okAction: ((_ message: String) -> Void)?) -> UIAlertController {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction.init(title: Ok, style: .default) { (action) in
            if let ok = okAction {
                ok(alert.textFields?[0].text ?? "-")
            }
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction.init(title: Cancel, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        return alert
    }
    
    private func doButtonProcess(message: String) {
        self.delegate?.showLoadingHud(text: "Updating Transaction...")
        switch getSystemName(){
        case System.Product:
            APIManager.shareInstance.sendXMLFromButtonNewPaf(system: system, brief: detailBrief, reason: message, xml: btnAction.call_xml, req_txn_id: btnAction.req_txn_id, note: "mobile", callback: { (success, xmlError, dataDict)  in
                self.delegate?.onActionButtonResult(Success: success, xmlError: xmlError, dataDict: dataDict)
            })
            
        default: //Crude
            APIManager.shareInstance.sendXMLFromButton(system: system, type: btnAction.type, xml: btnAction.call_xml, req_txn_id: btnAction.req_txn_id, note: message, txtBrief: detailBrief) { (success, xmlError, dataDict) in
                self.delegate?.onActionButtonResult(Success: success, xmlError: xmlError, dataDict: dataDict)
            }
        }
    }
    private func doButtonProcessRevise(message: String, Flag1: String, Flag2: String) {
        self.delegate?.showLoadingHud(text: "Updating Transaction...")
        switch getSystemName(){
        case System.VCool:
            let requester_info = ["name": data["requested_name"]!,
                                  "area_unit": data["user_group"]!,
                                  "date_purchase": data["date_purchase"]!,
                                  "purchase_no": data["purchase_no"]!,
                                  "workflow_status": "",
                                  "workflow_status_description": "",
                                  "workflow_priority": "",
                                  "status_tn": "",
                                  "status_tn_description": "",
                                  "status_sc": data["sc_status"]!,
                                  "status_sc_description": data["status"]!,
                                  "status_scvp": "",
                                  "status_scsc": "",
            ]
            var rev1 = ""
            var rev2 = ""
            var rev3 = ""
            if self.userGroup == "CMVP" {
                rev2 = message
            } else if self.userGroup == "SCVP"  {
                rev1 = message
            } else if self.userGroup == "TNVP" {
                rev3 = message
            }
            let comment = ["scep_flag": Flag1,
                           "scsc_flag": Flag2,
                           "revise_scvp": rev1,
                           "revise_cmvp": rev2,
                           "revise_tnvp": rev3]
            let json :[String: Any] = ["requester_info": requester_info,
                                       "comment": comment]
            
            var jsonData: Data = Data()
            var jsonString = ""
            do {
                jsonData = try JSONSerialization.data(withJSONObject: json, options: .init(rawValue: 0))
                jsonString = String(data: jsonData, encoding: .utf8)!// .ascii)!
                jsonString = jsonString.replacingOccurrences(of: "\\", with: "")
                jsonString = jsonString.toBase64()
            } catch {
                print("error")
            }
            APIManager.shareInstance.sendXMLFromButtonRevise(system: system, type: btnAction.type, xml: btnAction.call_xml, req_txn_id: btnAction.req_txn_id, note: message, jsonData: jsonString, txtBrief: detailBrief, callback: { (success, xmlError, dataDict) in
                self.delegate?.onActionButtonResult(Success: success, xmlError: xmlError, dataDict: dataDict)
            })
        default:
            break
        }
    }
}

extension CrudeButtonCell: VCoolRevisePopupDelegate {
    func onBtnOK(reasonText: String, Flag1: String, Flag2: String) {
         doButtonProcessRevise(message: reasonText, Flag1: Flag1, Flag2: Flag2)
    }
}
