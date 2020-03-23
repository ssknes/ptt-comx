//
//  SideMenuTableViewController.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 12/4/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
import MBProgressHUD

class SideMenuTableViewController: UITableViewController {
    @IBOutlet weak var menuTableView: UITableView!
    var progressHud = MBProgressHUD()
    private var NotiFlag: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.menuTableView.separatorStyle = .none
        self.menuTableView.bounces = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch  indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! SideMenuCell1
            let pic_path = GlobalVar.sharedInstance.appMode.getUrl() + "/Content/images/Emp/" + CredentialManager.shareInstance.userId! + ".jpg"
            cell.lblName.text = CredentialManager.shareInstance.userId
            DispatchQueue.main.async {
                APIManager.shareInstance.getImageFromURL(url: pic_path, type: "image/jpeg") { (success, error, data) in
                    if success {
                        cell.imgProfile.image = UIImage(data: data)
                    } else {
                        let no_pic_path = GlobalVar.sharedInstance.appMode.getUrl() + "/Content/images/Emp/NoImage.png"
                        APIManager.shareInstance.getImageFromURL(url: no_pic_path, type: "image/png", callback: { (success, error, data) in
                            if success {
                            cell.imgProfile.image = UIImage(data: data)
                                
                            }
                        })
                    }
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! SideMenuCell2
            cell.swSwitch.isHidden = true
            cell.lblName.text = "All My Task"
            cell.imgIcon.image = UIImage.init(named: "ic_mytask")
            cell.vwLine.isHidden = false
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! SideMenuCell2
            cell.swSwitch.isHidden = true
            cell.lblName.text = "My Dashboard"
            cell.imgIcon.image = UIImage.init(named: "ic_dashboard")
            cell.vwLine.isHidden = false
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! SideMenuCell2
            cell.swSwitch.isHidden = false
            cell.lblName.text = "Notifications"
            if NotiFlag {
                cell.imgIcon.image = UIImage.init(named: "ic_notifications")
                cell.swSwitch.isOn = true
            } else {
                cell.imgIcon.image = UIImage.init(named: "ic_notifications_off")
                cell.swSwitch.isOn = false
            }
            cell.vwLine.isHidden = false
            cell.delegate = self
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! SideMenuCell2
            cell.swSwitch.isHidden = true
            cell.lblName.text = "About"
            cell.imgIcon.image = UIImage.init(named: "ic_person")
            cell.vwLine.isHidden = false
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! SideMenuCell2
            cell.swSwitch.isHidden = true
            cell.lblName.text = "Sign out"
            cell.imgIcon.image = UIImage.init(named: "ic_clear")
            cell.vwLine.isHidden = false
            return cell
        default:
            return UITableViewCell()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            GlobalVar.sharedInstance.dashboardShowTask = true
            self.dismiss(animated: true) {
                
            }
        case 2:
            GlobalVar.sharedInstance.dashboardShowTask = false
            self.dismiss(animated: true) {
                
            }
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "aboutview") as! AboutViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            self.dismiss(animated: true) {
                GlobalVar.sharedInstance.restoreDefaultValue()
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let signin = storyBoard.instantiateViewController(withIdentifier: "main") as! SignInViewController
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window?!.rootViewController = signin
            }
        default:
            break
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 90
        }
        return 44
    }
}

extension SideMenuTableViewController: SideMenuCell2Delegate {
    func onSwitch(Sender: UISwitch) {
        self.progressHud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        if APIManager.shareInstance.connectedToNetwork(){
            if InitialVCStateManager.sharedInstance.getValueForKey(key: "firstTime") as! Bool == false {
                APIManager.shareInstance.setNotification(user: "\(CredentialManager.shareInstance.userId!)", key: "NOTI", set_flag: Sender.isOn ? "Y" : "N", callback: setNotiSwitch)
            }
        }
    }
    func setNotiSwitch(flag: Bool, error: MyError?, dataDict: [String : Any]){
        self.progressHud.hide(animated: true)
        if let data = dataDict[System.Message] as? [String:String] {
            if data["NOTI"] == "Y"{
                self.NotiFlag = true
            } else {
                self.NotiFlag = false
            }
        } else {
            self.NotiFlag = !self.NotiFlag
        }
        tableView.reloadData()
    }
}
