//
//  BaseViewController.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 22/8/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    var baseScrollView: UIScrollView?
    var tap: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11, *) {
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    }
    
    func addSubviewWithAnimation(_ vc: UIViewController) {
        vc.view.alpha = 0
        UIApplication.shared.keyWindow?.addSubview((vc.view)!)
        self.addChild(vc)
        vc.didMove(toParent: self)
        UIView.animate(withDuration: 0.25) {
            vc.view.alpha = 1
        }
    }
    
    func addSubviewWithAnimation(_ vc: UIViewController, _ target: UIViewController) {
        vc.view.alpha = 0
        target.view.addSubview((vc.view)!)
        self.addChild(vc)
        vc.didMove(toParent: self)
        UIView.animate(withDuration: 0.25) {
            vc.view.alpha = 1
        }
    }
    
    func removeSubviewWithAnimation(_ vc: UIViewController) {
        UIView.animate(withDuration: 0.25, animations: {
            vc.view.alpha = 0
        }) { (success) in
            if success {
                self.removeFromParent()
                self.view.removeFromSuperview()
            }
        }
    }
    
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - prevent keyboard textField overlap
    func registerForKeyboardNotifications(scrollView: UIScrollView) {
        self.baseScrollView = scrollView
        
        NotificationCenter.default.addObserver(self, selector:
            //#selector(BaseViewController.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
            #selector(BaseViewController.keyboardWasShown(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        view.addGestureRecognizer(tap!)
        if let scrollView = baseScrollView {
            let info = notification.userInfo!
            if let kbFrame = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
                let kbSize: CGSize = kbFrame.cgRectValue.size
                
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0.0)
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets
                
                // If active text field is hidden by keyboard, scroll it so it's visible
                for view in scrollView.subviews where view.isFirstResponder {
                    if let activeField = view as? UITextField {
                        var aRect = self.view.frame
                        aRect.size.height -= kbSize.height
                        var fieldRect = activeField.frame
                        fieldRect.origin.y += 20.0
                        if !aRect.contains(fieldRect.origin) {
                            scrollView.scrollRectToVisible(fieldRect, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        view.removeGestureRecognizer(tap!)
        if let scrollView = baseScrollView {
            let contentInsets = UIEdgeInsets.zero
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }
}
