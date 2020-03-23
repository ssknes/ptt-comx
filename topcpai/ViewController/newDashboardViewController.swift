//
//  newDashboardViewController.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 8/22/2560 BE.
//  Copyright © 2560 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
import MBProgressHUD

class NewDashboardViewController: BaseViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwCoutner: UIView!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var mainCollection: UICollectionView!
    
    @IBOutlet weak var tvAllMyTask: UIView!
    
    var openFromNoti: Bool = GlobalVar.sharedInstance.openFromNoti
    var notiPage = GlobalVar.sharedInstance.page
    var notiPurchaseID = GlobalVar.sharedInstance.purchaseIDNoti
    
    var fontSize = 11
    var progressHud = MBProgressHUD()
    
    var vwAllMyTask: AllMyTaskViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSideMenu()
        let gest = UITapGestureRecognizer.init(target: self, action: #selector(onHeaderlabel(_:)))
        lblTitle.addGestureRecognizer(gest)
        lblTitle.isUserInteractionEnabled = true
        vwCoutner.layer.cornerRadius = 3
        setCurrentView(force: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = UIColor.init(red: 48 / 255, green: 44 / 255, blue: 117 / 255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
        //navigationController?.navigationBar
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.init(red: 48 / 255, green: 44 / 255, blue: 117 / 255, alpha: 1)]
        
        updateApiBadges()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if vwAllMyTask == nil {
            vwAllMyTask = AllMyTaskViewController.init()
            vwAllMyTask?.view.frame = CGRect.init(x: 0, y: 0, width: tvAllMyTask.frame.size.width, height: tvAllMyTask.frame.size.height)
            tvAllMyTask.addSubview(vwAllMyTask!.view)
            vwAllMyTask?.delegate = self
            addChild(vwAllMyTask!)
            vwAllMyTask?.didMove(toParent: self)
            vwAllMyTask?.checkConnection()
        } else {
            if !tvAllMyTask.isHidden {
                vwAllMyTask?.checkConnection()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setCurrentView(force: Bool) {
        if !force && GlobalVar.sharedInstance.dashboardShowTask == !tvAllMyTask.isHidden {
            return
        }
        if GlobalVar.sharedInstance.dashboardShowTask {
            tvAllMyTask.isHidden = false
            lblTitle.text = "All My Task"
            vwAllMyTask?.checkConnection()
        } else {
            tvAllMyTask.isHidden = true
            lblTitle.text = "My Dashboard"
            updateApiBadges()
        }
    }
    @objc func onHeaderlabel(_ sender: Any) {
        GlobalVar.sharedInstance.dashboardShowTask = !GlobalVar.sharedInstance.dashboardShowTask
        self.setCurrentView(force: false)
    }
    
    private func initSideMenu() {
        let menuLeftNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        menuLeftNavigationController?.leftSide = true
        menuLeftNavigationController?.pushStyle = .default
        menuLeftNavigationController?.presentationStyle = .menuSlideIn
        menuLeftNavigationController?.presentationStyle.onTopShadowColor = UIColor.black
        menuLeftNavigationController?.menuWidth = UIScreen.main.bounds.size.width * 0.8
        SideMenuManager.default.leftMenuNavigationController =  menuLeftNavigationController
        menuLeftNavigationController?.sideMenuDelegate = self
        
        //SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        //SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    
    @IBAction func onBtnMenu(_ sender: UIButton) {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    func updateApiBadges() {
        let batchgroup = DispatchGroup()
        progressHud.hide(animated: true)
        progressHud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        if GlobalVar.sharedInstance.BadgeData.count == 0 {
            return
        }
        for i in 0 ... (GlobalVar.sharedInstance.BadgeData.count - 1) {
            batchgroup.enter()
            let toDay : Date = Date()
            let targetDate = DataUtils.shared.getLast3MonthDate(date: toDay)
            let strDay = DataUtils.shared.getStringFromDate(date: toDay)
            let strTargetDay = DataUtils.shared.getStringFromDate(date: targetDate)
            let Type = GlobalVar.sharedInstance.FrontData[i].name
            APIManager.shareInstance.getCountTxn(Type: Type, fromDate: strTargetDay,toDate: strDay, callback: { (success, xmlError, dataDict) in
                if success {
                    if (dataDict.count > 0) {
                        var count = 0
                        let dataArray = dataDict[System.CountTxn] as! [String : String]
                        for x in dataArray {
                            count += Int(x.value)!
                        }
                        if (count > 0){
                            GlobalVar.sharedInstance.BadgeData[i] = String(count)
                        } else {
                            GlobalVar.sharedInstance.BadgeData[i] = "0"
                        }
                    }
                }else{
                    print("Error")
                    //MyUtilities.showErrorAlert(message: xmlError.message, viewController: self)
                }
                batchgroup.leave()
            })
            
        }
        
        batchgroup.notify(queue: .main) {
            self.progressHud.hide(animated: true)
            var sum: Int = 0
            for item in GlobalVar.sharedInstance.BadgeData {
                sum += Int(item) ?? 0
            }
            if !self.tvAllMyTask.isHidden {
                sum = 0
            }
            if sum == 0 {
                self.vwCoutner.isHidden = true
            } else {
                self.vwCoutner.isHidden = false
                self.lblCounter.text = "\(sum)"
            }
            self.mainCollection.reloadData()
        }
    }
}

extension NewDashboardViewController: AllMyTaskViewDelegate {
    func setCounter(value: Int) {
        if value == 0 {
            self.vwCoutner.isHidden = true
        } else {
            self.vwCoutner.isHidden = false
            self.lblCounter.text = "\(value)"
        }
    }
    
    func hideView() {
        tvAllMyTask.isHidden = true
        lblTitle.text = "My Dashboard"
        updateApiBadges()
    }
    
    func onBtnMore(Data: [String : Any]) {
         let vc = storyboard?.instantiateViewController(withIdentifier: "detailView") as! DetailViewController
         vc.DataDict = Data
         self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewDashboardViewController: SideMenuNavigationControllerDelegate {
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        setCurrentView(force: false)
    }
}

extension NewDashboardViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GlobalVar.sharedInstance.FrontData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DashboardCollectionViewCell
        cell.lblTitle.text = GlobalVar.sharedInstance.FrontData[indexPath.row].tabName
        cell.lblDescription.text = GlobalVar.sharedInstance.FrontData[indexPath.row].desc
        cell.setImageView(systemType: GlobalVar.sharedInstance.FrontData[indexPath.row].name)
        cell.setCounter(Num: GlobalVar.sharedInstance.BadgeData[indexPath.row])
        
        var canAccess = false
        //Create can access
        if GlobalVar.sharedInstance.FrontData[indexPath.item].tab.trim().length > 0 {
            canAccess = true
        }
        if GlobalVar.sharedInstance.canAccessView.count < (indexPath.item + 1) {
            GlobalVar.sharedInstance.canAccessView.append(canAccess)
        } else {
            GlobalVar.sharedInstance.canAccessView[indexPath.item] = canAccess
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (UIScreen.main.bounds.size.width / 2)
        return CGSize.init(width: w, height:  w * 0.8)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if GlobalVar.sharedInstance.canAccessView[indexPath.item] {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ListView") as! ListViewController
            vc.page = GlobalVar.sharedInstance.FrontData[indexPath.item].name.lowercased()
            if self.openFromNoti {
                self.openFromNoti = false
                GlobalVar.sharedInstance.openFromNoti = false
                vc.openFromNoti = true
                vc.purchaseIDNoti = self.notiPurchaseID
                vc.page = self.notiPage
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            MyUtilities.showErrorAlert(message: "Not ready to use now!!", viewController: self)
        }
    }
}
