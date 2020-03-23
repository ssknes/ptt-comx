//
//  SignInViewController.swift
//  topcpai
//
//  Created by NB590194 on 11/30/16.
//  Copyright © 2016 PTT ICT Solutions. All rights reserved.
//

import UIKit
import LocalAuthentication

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var viewTouchID: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    
    let progressHUD = ProgressHUD(text: "Loading...")
    var openFromNoti = false
    //    var userInfo = [AnyHashable : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        self.title = "Sign in"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignInViewController.methodOfReceivedNotification(notification:)), name: Notification.Name("ReceivedPush"), object: nil)
        
        let width = CGFloat(3.0)
        
        let border = CALayer()
        border.borderColor = UIColor.lightGray.cgColor
        border.borderWidth = width
        border.frame = CGRect(x: 0, y: txtEmail.frame.size.height - width, width:  txtEmail.frame.size.width, height: txtEmail.frame.size.height)
        txtEmail.layer.addSublayer(border)
        txtEmail.layer.masksToBounds = true
        
        //        if CredentialManager.shareInstance.userId != ""{
        //            txtEmail.text = "\(CredentialManager.shareInstance.userId!)"
        //            txtPassword.text = "\(CredentialManager.shareInstance.userPassword!)"
        //        }
        
        let border2 = CALayer()
        border2.borderColor = UIColor.lightGray.cgColor
        border2.borderWidth = width
        border2.frame = CGRect(x: 0, y: txtPassword.frame.size.height - width, width:  txtPassword.frame.size.width, height: txtPassword.frame.size.height)
        txtPassword.layer.addSublayer(border2)
        txtPassword.layer.masksToBounds = true
        viewTouchID.isHidden = true
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        MyUtilities.showAckAlert(title: "2", message: "2", viewController: self)
        //Take Action on Notification
        //let userInfo = notification.userInfo as! [String: AnyObject]
        //        self.userInfo = userInfo
        self.openFromNoti = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.openFromNoti {
            self.callLoginReguest(username: CredentialManager.shareInstance.userId!, password: CredentialManager.shareInstance.userPassword!)
        } else {
            self.checkConnection()
        }
    }
    
    func checkConnection(){
        if APIManager.shareInstance.connectedToNetwork(){
            if InitialVCStateManager.sharedInstance.getValueForKey(key: "firstTime") as! Bool == false {
                self.authenticateUser()
            }
        } else {
            MyUtilities.showAckwithAction(title: "Sorry", message: "No Internet Connection", viewController: self, okAction: self.checkConnection)
        }
    }
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        self.callLoginReguest(username: txtEmail.text!, password: txtPassword.text!)
    }
    
    
    @IBAction func touchIDMethod(_ sender: Any) {
        self.authenticateUser()
    }
    
    func authentication(success: Bool, fail: MyError?, dataDict: [String: Any]) {
        self.progressHUD.removeFromSuperview()
        
        if success {
            self.prepareNextPage(dataDict)
        } else {
            if let fail = fail {
                if fail.code == "900002" {
                    MyUtilities.showErrorAlert(message: "Username or password is incorrect", viewController: self)
                    //MyUtilities.showErrorAlert(message: fail.message, viewController: self)
                } else if fail.code == "10000070" {
                    // force update
                    MyUtilities.showAckAlert(title: "Commercial Excellence Update", message: "Get the latest version for all of the available features and improvements.", okText: "Update Now", okStyle: .cancel, viewController: self, completion: {
                        var url : URL
                        if GlobalVar.sharedInstance.appMode == WorkMode.UAT || GlobalVar.sharedInstance.appMode == WorkMode.DEV{
                            url = URL(string :"https://cpai.thaioilgroup.com/mobile-trading-qas/")!
                        }else{
                            url = URL(string :"https://cpai.thaioilgroup.com/mobile-trading-prod/")!
                        }
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                            //UIApplication.shared.openURL(url)
                        }
                    })
                } else {
                    MyUtilities.showErrorAlert(message: (fail.message), viewController: self)
                }
            } else {
                MyUtilities.showErrorAlert(message: "No response from server", viewController: self)
            }
            
        }
    }
    
    func initFrontData() {
        GlobalVar.sharedInstance.FrontData.removeAll()
        GlobalVar.sharedInstance.BadgeData.removeAll()
        for item in (GlobalVar.sharedInstance.userMobileMenu?.menu)! {
            if let temp = item as? UserMobileMenuItem{
                if temp.tab.trim().length > 0 {
                    GlobalVar.sharedInstance.FrontData.append(temp)
                    GlobalVar.sharedInstance.BadgeData.append("0")
                }
            }
        }
        
        if GlobalVar.sharedInstance.mockMenu {
            let temp = UserMobileMenuItem(dataDict: NSDictionary())
            temp.desc = "CrudeSale"
            temp.order = "\(GlobalVar.sharedInstance.FrontData.count + 1)"
            temp.name = "CrudeSale"
            temp.tab = "Waiting Approve|Approved|Cancel"
            temp.tabName = "CrudeSale"
            temp.status = "WAITING CERTIFIED|APPROVED|CANCEL"
            GlobalVar.sharedInstance.FrontData.append(temp)
            GlobalVar.sharedInstance.BadgeData.append("0")
        }
        
        GlobalVar.sharedInstance.FrontData.sort { (Obj1, Obj2) -> Bool in
            return Int(Obj1.order)! < Int(Obj2.order)!
        }
    }
    
    func prepareNextPage(_ dataDict : [String: Any]?){
        if dataDict?["user_mobile_menu"] != nil {
            UserDefaults.standard.set(dataDict?["user_mobile_menu"], forKey: "mobileUserMenu")
            let dict : Dictionary = self.convertToDictionary(text: dataDict!["user_mobile_menu"] as! String)!
            let data = NSDictionary.init(dictionary: dict)
            GlobalVar.sharedInstance.userMobileMenu = UserMobileMenuList.init(dataDict: data)
            self.initFrontData()
        } else {
            GlobalVar.sharedInstance.userMobileMenu = UserMobileMenuList.init(dataDict: NSDictionary())
        }
        if openFromNoti == false {
            if InitialVCStateManager.sharedInstance.getValueForKey(key: "firstTime") as! Bool == true{
                InitialVCStateManager.sharedInstance.saveValue(value: false as AnyObject, forKey: "firstTime")
                CredentialManager.shareInstance.userId = txtEmail.text!
                CredentialManager.shareInstance.userPassword = txtPassword.text!
            } else if CredentialManager.shareInstance.userId != txtEmail.text! || CredentialManager.shareInstance.userPassword != txtPassword.text{
                if txtEmail.text?.trim() != "" && txtPassword.text?.trim() != "" {
                    CredentialManager.shareInstance.userId = txtEmail.text
                    CredentialManager.shareInstance.userPassword = txtPassword.text
                }
            }
            //let ad = UIApplication.shared.delegate as! AppDelegate
            let storyBoard : UIStoryboard = self.storyboard!
            //let frontview = storyBoard.instantiateViewController(withIdentifier: "frontview") as UIViewController
            let vc = storyBoard.instantiateViewController(withIdentifier: "newdashboard") as! NewDashboardViewController
            let frontview = UINavigationController.init(rootViewController: vc)
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            UIApplication.shared.keyWindow?.rootViewController = frontview
            //self.present(frontview, animated: false, completion: nil)
        } else {
            let userDefaults = UserDefaults.standard
            let temp = userDefaults.value(forKey: "userInfo") as? [AnyHashable : Any]
            if let aps = temp?["action_data"] as? String {
                let apsArray = aps.components(separatedBy: "|")
                //if let vcName = apsArray[1] as? String {
                if apsArray.count > 1 {
                    let vcName = apsArray[1]
                    GlobalVar.sharedInstance.openFromNoti = true
                    GlobalVar.sharedInstance.purchaseIDNoti = apsArray[0]
                    GlobalVar.sharedInstance.page = vcName.lowercased()
                    
                    let storyBoard : UIStoryboard = self.storyboard!
                    //let frontview = storyBoard.instantiateViewController(withIdentifier: "frontview") as UIViewController
                    let vc = storyBoard.instantiateViewController(withIdentifier: "newdashboard") as! NewDashboardViewController
                    let frontview = UINavigationController.init(rootViewController: vc)
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.type = CATransitionType.push
                    transition.subtype = CATransitionSubtype.fromRight
                    view.window!.layer.add(transition, forKey: kCATransition)
                    UIApplication.shared.keyWindow?.rootViewController = frontview
                    //self.present(frontview, animated: false, completion: nil)
                }
            }else { //Mock
                GlobalVar.sharedInstance.openFromNoti = true
                
                let storyBoard : UIStoryboard = self.storyboard!
                //let frontview = storyBoard.instantiateViewController(withIdentifier: "frontview") as UIViewController
                let vc = storyBoard.instantiateViewController(withIdentifier: "newdashboard") as! NewDashboardViewController
                let frontview = UINavigationController.init(rootViewController: vc)
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                view.window!.layer.add(transition, forKey: kCATransition)
                UIApplication.shared.keyWindow?.rootViewController = frontview
                //self.present(frontview, animated: false, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return false
    }
    
    // MARK: Touch ID
    func authenticateUser() {
        // Get the local authentication context.
        let context = LAContext()
        context.localizedFallbackTitle = "Enter Pin"
        // Declare a NSError variable.
        var error: NSError?
        
        // Check if the device can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            verifyFingerprint(context: context)
            viewTouchID.isHidden = false
        } else {
            // If the security policy cannot be evaluated then show a short message depending on the error.
            switch error!.code {
            case kLAErrorBiometryNotEnrolled.hashValue:
                viewTouchID.isHidden = false
                self.showalert(title: "There are no fingerprints registered.", message: "Please enroll your fingerprint in Settings.")
                log.info("TouchID is not enrolled")
            case LAError.passcodeNotSet.rawValue:
                viewTouchID.isHidden = false
                self.showalert(title: "A passcode has not been set.", message: "")
                log.info("A passcode has not been set")
            default:
                // The LAError.TouchIDNotAvailable case.
                viewTouchID.isHidden = true
                log.info("TouchID not available")
            }
            
            // Optionally the error description can be displayed on the console.
            log.debug(error!.localizedDescription)
        }
    }
    
    func verifyFingerprint(context: LAContext) {
        // Set the reason string that will appear on the authentication alert.
        let head: String = self.title!
        let reasonString = "Authentication is needed to \(head)."
        
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { (success, evalPolicyError) in
            if success {
                self.fingerprintMatched()
            } else {
                // If authentication failed then show a message to the console with a short description.
                // In case that the error is a user fallback, then show the password alert view.
                log.debug(evalPolicyError?.localizedDescription)
                
                //                switch evalPolicyError.code {
                //
                //                case LAError.SystemCancel.rawValue:
                //                    log.debug("Authentication was cancelled by the system")
                //
                //                case LAError.UserCancel.rawValue:
                //                    log.debug("Authentication was cancelled by the user")
                //
                //                case LAError.UserFallback.rawValue:
                //                    log.debug("User selected to enter custom password")
                //
                //                default:
                //                    log.debug("Authentication failed")
                //                }
            }
        }
    }
    
    func fingerprintMatched() {
        DispatchQueue.main.async {
            // CALL SERVICE
            self.callLoginReguest(username: CredentialManager.shareInstance.userId!, password: CredentialManager.shareInstance.userPassword!)
        }
    }
    
    func showalert(title: String, message: String){
        let myImage = UIImage(named: "ic_fingerprint")
        let prevImage = UIImageView(frame: CGRect(x: 120, y: 20, width: 30, height: 40))
        prevImage.image = myImage
        let spacer = "\r\n\r\n\r\n"
        let previewController = UIAlertController(title: "", message: "\(spacer)\(title)\r\n\(message)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        previewController.addAction(cancelAction)
        previewController.view.addSubview(prevImage)
        self.present(previewController, animated: true, completion: nil)
    }
    
    func callLoginReguest(username: String, password: String){
        self.view.addSubview(progressHUD)
        APIManager.shareInstance.requestLogin(userId: username, userPassword: password, callback: authentication)
    }
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

}
