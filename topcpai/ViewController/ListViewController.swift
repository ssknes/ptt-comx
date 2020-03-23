//
//  ListViewController.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 25/4/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: BaseViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    var page = "bunker"
    var pdfurl = ""
    var openFromNoti = false
    var purchaseIDNoti = ""
    var oldIndex : Int = 0
    var anime : Bool = false
    var progressHUD: ProgressHUD?
    var allSubView = [BaseListViewController]()
    var fromBack: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainScrollView.contentInsetAdjustmentBehavior = .never
        
        mainScrollView.bounces = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back_bt-icon"), style: .plain, target: self, action: #selector(onBtnBack(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "zoom"), style: .plain, target: self, action: #selector(onBtnZoom(_:)))
        
    }
    @objc func onBtnZoom(_ sender: Any) {
        GlobalVar.sharedInstance.changeFontNumber()
        allSubView[0].reloadData()
    }
    
    @objc func onBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initView()
    }
    
    func initView() {
        if self.allSubView.count > 0 {
            return
        }
        mainScrollView.isPagingEnabled = true
        self.AddView(Name: page, order: "1")
        for item in GlobalVar.sharedInstance.FrontData where page == item.name.lowercased() {
            self.title = item.tabName
            if page == "crude_p" {
                self.title = "CRUDE L/R PURCHASE"
            }
        }
    }
    
    func AddView(Name: String, order: String) {
        let intOrder = Int(order)! - 1
        let width = self.mainScrollView.frame.size.width
        let height = self.mainScrollView.frame.size.height
        let xPos: CGFloat = CGFloat(intOrder) * width
        switch Name.lowercased() {
        case "crude_p":
            let temp = storyboard?.instantiateViewController(withIdentifier: "newCrude") as! newCrudeViewController
            temp.view.frame = CGRect.init(x: xPos, y: 0, width: width , height: height)
            if openFromNoti {
                if self.page == "crude_p" {
                    self.openFromNoti = false
                    temp.openFromNoti = true
                    temp.purchaseIDNoti = self.purchaseIDNoti
                }
            }
            self.allSubView.append(temp)
            mainScrollView.addSubview(allSubView[intOrder].view)
            self.addChild(allSubView[intOrder])
            allSubView[intOrder].didMove(toParent: self)
        case "bunker":
            let temp = storyboard?.instantiateViewController(withIdentifier: "newBunker") as! newBunkerViewController
            temp.view.frame = CGRect.init(x: xPos, y: 0, width: width , height: height)
            if openFromNoti {
                if self.page == "bunker" {
                    self.openFromNoti = false
                    temp.openFromNoti = true
                    temp.purchaseIDNoti = self.purchaseIDNoti
                }
            }
            self.allSubView.append(temp)
            mainScrollView.addSubview(allSubView[intOrder].view)
            self.addChild(allSubView[intOrder])
            allSubView[intOrder].didMove(toParent: self)
        case "chartering":
            let temp = storyboard?.instantiateViewController(withIdentifier: "newCharter") as! newCharteringViewController
            temp.view.frame = CGRect.init(x: xPos, y: 0, width: width , height: height)
            if openFromNoti {
                if self.page == "chartering" {
                    self.openFromNoti = false
                    temp.openFromNoti = true
                    temp.purchaseIDNoti = self.purchaseIDNoti
                }
            }
            self.allSubView.append(temp)
            mainScrollView.addSubview(allSubView[intOrder].view)
            self.addChild(allSubView[intOrder])
            allSubView[intOrder].didMove(toParent: self)
        case "vcool":
            let temp = storyboard?.instantiateViewController(withIdentifier: "vcool") as! VCoolViewController
            temp.view.frame = CGRect.init(x: xPos, y: 0, width: width , height: height)
            if openFromNoti {
                if self.page == "vcool" {
                    self.openFromNoti = false
                    temp.openFromNoti = true
                    temp.purchaseIDNoti = self.purchaseIDNoti
                }
            }
            self.allSubView.append(temp)
            mainScrollView.addSubview(allSubView[intOrder].view)
            self.addChild(allSubView[intOrder])
            allSubView[intOrder].didMove(toParent: self)
        case "product_purchase":
            let temp = storyboard?.instantiateViewController(withIdentifier: "NewPaf") as! PafViewController
            temp.view.frame = CGRect.init(x: xPos, y: 0, width: width , height: height)
            temp.setFormType(fType: "PRODUCT_PURCHASE")
            if openFromNoti {
                if self.page == "product_purchase" {
                    self.openFromNoti = false
                    temp.openFromNoti = true
                    temp.purchaseIDNoti = self.purchaseIDNoti
                }
            }
            self.allSubView.append(temp)
            mainScrollView.addSubview(allSubView[intOrder].view)
            self.addChild(allSubView[intOrder])
            allSubView[intOrder].didMove(toParent: self)
        case "product_sale":
            let temp = storyboard?.instantiateViewController(withIdentifier: "NewPaf") as! PafViewController
            temp.view.frame = CGRect.init(x: xPos, y: 0, width: width , height: height)
            temp.setFormType(fType: "PRODUCT_SALE")
            if openFromNoti {
                if self.page == "product_sale" {
                    self.openFromNoti = false
                    temp.openFromNoti = true
                    temp.purchaseIDNoti = self.purchaseIDNoti
                }
            }
            self.allSubView.append(temp)
            mainScrollView.addSubview(allSubView[intOrder].view)
            self.addChild(allSubView[intOrder])
            allSubView[intOrder].didMove(toParent: self)
        case "daf":
            let temp = storyboard?.instantiateViewController(withIdentifier: "daf") as! DemurageViewController
            temp.view.frame = CGRect.init(x: xPos, y: 0, width: width , height: height)
            if openFromNoti {
                if self.page == "daf" {
                    self.openFromNoti = false
                    temp.openFromNoti = true
                    temp.purchaseIDNoti = self.purchaseIDNoti
                }
            }
            self.allSubView.append(temp)
            mainScrollView.addSubview(allSubView[intOrder].view)
            self.addChild(allSubView[intOrder])
            allSubView[intOrder].didMove(toParent: self)
        case "hedg_tckt":
            let temp = storyboard?.instantiateViewController(withIdentifier: "Hedging") as! HedgingViewController
            temp.SystemKey = System.Hedge_tckt
            temp.view.frame = CGRect.init(x: xPos, y: 0, width: width , height: height)
            if openFromNoti {
                if self.page == "hedg_tckt" {
                    self.openFromNoti = false
                    temp.openFromNoti = true
                    temp.purchaseIDNoti = self.purchaseIDNoti
                }
            }
            self.allSubView.append(temp)
            mainScrollView.addSubview(allSubView[intOrder].view)
            self.addChild(allSubView[intOrder])
            allSubView[intOrder].didMove(toParent: self)
        case "hedg_sett":
            let temp = storyboard?.instantiateViewController(withIdentifier: "Hedging") as! HedgingViewController
            temp.SystemKey = System.Hedge_sett
            temp.view.frame = CGRect.init(x: xPos, y: 0, width: width , height: height)
            if openFromNoti {
                if self.page == "hedg_sett" {
                    self.openFromNoti = false
                    temp.openFromNoti = true
                    temp.purchaseIDNoti = self.purchaseIDNoti
                }
            }
            self.allSubView.append(temp)
            mainScrollView.addSubview(allSubView[intOrder].view)
            self.addChild(allSubView[intOrder])
            allSubView[intOrder].didMove(toParent: self)
        case "hedg_bot":
            let temp = storyboard?.instantiateViewController(withIdentifier: "HedgingBot") as! HedgingBotViewController
            temp.view.frame = CGRect.init(x: xPos, y: 0, width: width , height: height)
            if openFromNoti {
                if self.page == "hedg_bot" {
                    self.openFromNoti = false
                    temp.openFromNoti = true
                    temp.purchaseIDNoti = self.purchaseIDNoti
                }
            }
            self.allSubView.append(temp)
            mainScrollView.addSubview(allSubView[intOrder].view)
            self.addChild(allSubView[intOrder])
            allSubView[intOrder].didMove(toParent: self)
        case "crude_o" :
            let temp = storyboard?.instantiateViewController(withIdentifier: "crudesale") as! CrudeSaleViewController
            temp.view.frame = CGRect.init(x: xPos, y: 0, width: width , height: height)
            if openFromNoti {
                if self.page == "crude_o" {
                    self.openFromNoti = false
                    temp.openFromNoti = true
                    temp.purchaseIDNoti = self.purchaseIDNoti
                }
            }
            self.allSubView.append(temp)
            mainScrollView.addSubview(allSubView[intOrder].view)
            self.addChild(allSubView[intOrder])
            allSubView[intOrder].didMove(toParent: self)
        default:
            break
        }
    }
}


