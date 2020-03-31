//
//  DetailViewController.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 25/4/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//
import Foundation
import UIKit
import MBProgressHUD

class DetailViewController: BaseViewController {
    @IBOutlet weak var mainTableView: UITableView!
    
    var DataDict = [String: Any]()
    private var cellSystem: String = ""
    private var viewHeight: CGFloat = 0
    var progressHUD = MBProgressHUD()
    private var arrButton = [Button]()
    
    private var briefText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detail"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back_bt-icon"), style: .plain, target: self, action: #selector(onBtnBack(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "zoom"), style: .plain, target: self, action: #selector(onBtnZoom(_:)))
    }
    
    @objc func onBtnZoom(_ sender: Any) {
        GlobalVar.sharedInstance.changeFontNumber()
        mainTableView.reloadData()
    }
    
    
 
    
    @objc func onBtnBack(_ sender: Any) {
        if briefText != "" {
            let alert = UIAlertController.init(title: "Confirm to exit", message: "Confirm to exit without save your Brief? ", preferredStyle: .alert)
            let okAcion = UIAlertAction.init(title: "OK", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okAcion)
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            }
            alert.addAction(cancelAction)
            alert.modalPresentationStyle = .overFullScreen
            self.present(alert, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getButtonData()
    }
    
    private func getButtonData() {
        self.progressHUD = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        self.progressHUD.detailsLabel.text = "Loading Detail..."
        log.info("dataDict 67  \(DataDict)")
        let tmpArrAdvanceLoading = DataDict["advance_loading_request_data"] as? [[String: Any]] ?? []
        let tmpArrContractData = DataDict["contract_data"] as? [[String: Any]] ?? []
        
        if  tmpArrAdvanceLoading.count > 0 {
            if  tmpArrContractData.count > 0 {
            finalButton(Data:DataDict)
            }else{
            advanceButton(Data:DataDict)
            }
            
        }else{
            APIManager.shareInstance.getActionButton(Data: DataDict, callback: { (success, xmlError, dataDict) in
                  self.progressHUD.hide(animated: true)
                  if success {
                      for x in dataDict where x.name.lowercased() == "certified" {
                          x.name = "ENDORSE"
                      }
                      log.info("getButtonData \(String(describing: dataDict))")
                      self.arrButton = DataUtils.shared.getSortedArrButton(data: dataDict)

                  }
                  self.initView()
                  self.mainTableView.reloadData()
              })
        }
    }
    func advanceButton(Data:[String: Any]) {
        let bodyString = APIManager.shareInstance.advanceLoadingXML(Data: Data,system:System.Advance_loading)
        log.debug("bodyStringBTN \(bodyString)")
        let rejectBtn = Button()
        let approveBtn = Button()
        var dataArray = [Button]()
        let system = DataUtils.shared.SysName(System.Advance_loading as? String ?? "")
        var dataDict = Dictionary<String, Any>()
        rejectBtn.name = "REJECT"
        rejectBtn.page_url = "reject2"
        rejectBtn.call_xml = ""
        dataArray.append(rejectBtn)
        
        approveBtn.name = "APPROVE"
        approveBtn.page_url = "reject2"
        approveBtn.call_xml = bodyString
        dataArray.append(approveBtn)
        
        dataDict[system] = dataArray
        self.arrButton = DataUtils.shared.getSortedArrButton(data:  dataDict[system] as! [Button])
        self.progressHUD.hide(animated: true)
        self.initView()
        self.mainTableView.reloadData()
    }
    func finalButton(Data:[String: Any]) {
       let rejectBtn = Button()
        let approveBtn = Button()
        var dataArray = [Button]()
        let system = DataUtils.shared.SysName(DataDict["system"] as? String ?? "")
        var dataDict = Dictionary<String, Any>()
        rejectBtn.name = "REJECT"
        rejectBtn.page_url = "reject2"
        rejectBtn.page_url = "reject2"
        dataArray.append(rejectBtn)
        
        approveBtn.name = "APPROVE"
        approveBtn.page_url = "reject2"
        approveBtn.page_url = "reject2"
        dataArray.append(approveBtn)
        
        dataDict[system] = dataArray
        self.arrButton = DataUtils.shared.getSortedArrButton(data:  dataDict[system] as! [Button])
        self.progressHUD.hide(animated: true)
        self.initView()
        self.mainTableView.reloadData()
    }
    
    func initView() {
        cellSystem = DataDict["system"] as? String ?? ""
        if cellSystem.lowercased().contains("product") {
            cellSystem = System.Product
        }
        switch cellSystem {
        case System.Crude:
            mainTableView.register(UINib.init(nibName: "CrudeDataCell", bundle: nil), forCellReuseIdentifier: "cell")
            mainTableView.register(UINib.init(nibName: "CrudeSaleReoptCell", bundle: nil), forCellReuseIdentifier: "cellreopt")
        case System.Bunker:
            mainTableView.register(UINib.init(nibName: "BunkerDataCell", bundle: nil), forCellReuseIdentifier: "cell")
        case System.Chartering:
            let dataType = DataDict["function_id"] as? String ?? ""
            switch dataType {
            case "26":
                mainTableView.register(UINib.init(nibName: "Chartering26DataCell", bundle: nil), forCellReuseIdentifier: "cell")
            case "7":
                mainTableView.register(UINib.init(nibName: "CharterOutCMMTCell", bundle: nil), forCellReuseIdentifier: "cell")
            default :
                mainTableView.register(UINib.init(nibName: "CharteringDataCell", bundle: nil), forCellReuseIdentifier: "cell")
            }
        case System.VCool:
            mainTableView.register(UINib.init(nibName: "VCoolDataCell", bundle: nil), forCellReuseIdentifier: "cell")
        case System.Demurrage:
            mainTableView.register(UINib.init(nibName: "DemurageDataCell", bundle: nil), forCellReuseIdentifier: "cell")
        case System.Product:
            mainTableView.register(UINib.init(nibName: "NewPafCell", bundle: nil), forCellReuseIdentifier: "cell")
        case System.Hedge_tckt:
            mainTableView.register(UINib.init(nibName: "HedgingDataCell", bundle: nil), forCellReuseIdentifier: "cell")
        case System.Hedge_sett:
            mainTableView.register(UINib.init(nibName: "HedgeDataCellS", bundle: nil), forCellReuseIdentifier: "cell")
        case System.Hedge_Bot:
            mainTableView.register(UINib.init(nibName: "HedgeDataCellBot", bundle: nil), forCellReuseIdentifier: "cell")
        case System.Crude_O:
            mainTableView.register(UINib.init(nibName: "CrudeSaleReoptCell", bundle: nil), forCellReuseIdentifier: "cell")
        default:
            break
        }
    }
    
    func printPDF(_ sender: AnyObject) {
        var funcID = functionIds.print_pdf
        if cellSystem == System.Demurrage || cellSystem == System.Crude_O {
            funcID = functionIds.print_pdf_paf
        }
        if cellSystem == System.Product {
            funcID = functionIds.print_pdf_new_paf
        } 
        progressHUD = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        progressHUD.detailsLabel.text = "Loading File" //ProgressHUD (text: "Loading File...")
        let button: ActionButton = sender as! ActionButton
        APIManager.shareInstance.getPDF(functionID: funcID, transaction_id: button.transaction_id) { (success, xmlError, dataDict) in
            self.progressHUD.hide(animated: true)
            if success {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "pdf") as! PDFViewController
                vc.url = dataDict["pdf_path"] as! String
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                MyUtilities.showErrorAlert(message: xmlError.message, viewController: self)
            }
        }
    }
}



extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.endEditing(true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellSystem {
        case System.VCool:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! VCoolDataCell
            cell.btnData = arrButton
            //cell.txtBrief = self.briefText
            viewHeight  = cell.setCell(Data: DataDict , isExpand: true)
            cell.BaseDelegate = self
            cell.btnCollection.reloadData()
            return cell
        case System.Crude:
            if let temp = DataDict["reopt_transaction"] as? [String: Any] {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellreopt") as! CrudeSaleReoptCell
                cell.btnData = arrButton
                cell.txtBrief = self.briefText
                viewHeight  = cell.setCell(Data: temp)
                cell.req_txn_id = DataDict["req_transaction_id"] as? String ?? cell.req_txn_id
                cell.transaction_id = DataDict["transaction_id"] as? String ?? cell.transaction_id
                cell.system = DataDict["system"] as? String ?? cell.system
                cell.BaseDelegate = self
                cell.btnCollection.reloadData()
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CrudeDataCell
            cell.txtBrief = self.briefText
            cell.btnData = arrButton
            viewHeight  = cell.setCell(Data: DataDict)
            cell.BaseDelegate = self
            cell.btnCollection.reloadData()
            return cell
        case System.Bunker:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BunkerDataCell
            cell.txtBrief = self.briefText
            cell.btnData = arrButton
            viewHeight  = cell.setCell(Data: DataDict as! [String : Any], isExpand: true)
            cell.BaseDelegate = self
            cell.btnCollection.reloadData()
            return cell
        case System.Chartering:
            let dataType = DataDict["function_id"] as? String ?? ""
            switch dataType {
            case "26":
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! Chartering26DataCell
                cell.btnData = arrButton
                cell.txtBrief = self.briefText
                viewHeight  = cell.setCell(Data: DataDict, isExpand: true)
                cell.BaseDelegate = self
                cell.btnCollection.reloadData()
                return cell
            case "7":
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CharterOutCMMTCell
                cell.btnData = arrButton
                cell.txtBrief = self.briefText
                viewHeight  = cell.setCell(Data: DataDict, isExpand: true)
                cell.BaseDelegate = self
                cell.btnCollection.reloadData()
                return cell
            default :
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CharteringDataCell
                cell.btnData = arrButton
                cell.txtBrief = self.briefText
                viewHeight  = cell.setCell(Data: DataDict, isExpand: true)
                cell.BaseDelegate = self
                cell.btnCollection.reloadData()
                return cell
            }
        case System.Demurrage:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DemurageDataCell
            cell.btnData = arrButton
            cell.txtBrief = self.briefText
            viewHeight  = cell.setCell(Data: DataDict)
            cell.BaseDelegate = self
            cell.btnCollection.reloadData()
            return cell
        case System.Product:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NewPafCell
            cell.btnData = arrButton
            cell.txtBrief = self.briefText
            log.info("dataDict \(DataDict)")
            viewHeight  = cell.setCell(Type: DataDict["doc_type"] as? String ?? "", Data: DataDict)
            cell.BaseDelegate = self
            cell.btnCollection.reloadData()
            return cell
        case System.Hedge_tckt:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HedgingDataCell
            cell.btnData = arrButton
            cell.txtBrief = self.briefText
            viewHeight  = cell.setCell(Data: DataDict)
            cell.BaseDelegate = self
            cell.btnCollection.reloadData()
            return cell
            
        case System.Hedge_sett:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HedgeDataCellS
            cell.btnData = arrButton
            cell.txtBrief = self.briefText
            viewHeight  = cell.setCell(Data: DataDict)
            cell.BaseDelegate = self
            cell.btnCollection.reloadData()
            return cell
        case System.Hedge_Bot:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HedgeDataCellBot
            cell.btnData = arrButton
            cell.txtBrief = self.briefText
            viewHeight  = cell.setCell(Data: DataDict)
            cell.BaseDelegate = self
            cell.btnCollection.reloadData()
            return cell
        case System.Crude_O:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CrudeSaleReoptCell
            cell.btnData = arrButton
            cell.txtBrief = self.briefText
            viewHeight  = cell.setCell(Data: DataDict)
            cell.BaseDelegate = self
            cell.btnCollection.reloadData()
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewHeight
    }
}

extension DetailViewController: BaseDataCellDelegate {
    func setBrief(Value: String) {
        self.briefText = Value
    }
    
    func onActionButton(view: UIAlertController) {
        view.modalPresentationStyle = .overFullScreen
        self.present(view, animated: true)
    }
    
    func onActionBrief(ID: String, Value: String) {
        let vc = BriefViewController()
        vc.view.frame = UIScreen.main.bounds
        vc.setView(ID: ID, Text: Value)
        vc.delegate = self
        self.addSubviewWithAnimation(vc)
    }
    
    func onActionButtonAsSubview(view: UIViewController) {
        //for v cool only
        self.addSubviewWithAnimation(view)
        /*
        UIApplication.shared.keyWindow?.addSubview((view.view)!)
        self.addChild(view)
        view.didMove(toParent: self)*/
    }
    
    func showLoadingHud(text: String) {
        self.progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.progressHUD.detailsLabel.text = text
        //UIApplication.shared.keyWindow!.addSubview(self.progressHUD)
       // self.progressHUD = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
    }
    
    func onActionButtonResult(Success: Bool, xmlError: MyError, dataDict: [String : Any]) {
        self.progressHUD.hide(animated: true)
        MyUtilities.showAckAlert(title: "", message: xmlError.message, viewController: self)
        if Success {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func onActionButtonPDF(button: ActionButton) {
        printPDF(button)
    }
}

extension DetailViewController: BriefViewControllerDelegate {
    func showAlert(alertView: UIAlertController) {
        //self.present(alertView, animated: true)
    }
    
    func doneEdit(Text: String) {
        self.briefText = Text
        self.mainTableView.reloadData()
        mainTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
    }
}
