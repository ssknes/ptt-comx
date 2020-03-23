//
//  BriefViewController.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 22/8/2562 BE.
//  Copyright © 2562 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

protocol BriefViewControllerDelegate: class {
    func doneEdit(Text: String)
    func showAlert(alertView: UIAlertController)
}

class BriefViewController: BaseViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var vwEdit: UIView!
    @IBOutlet weak var vwBorder: UIView!
    private var ID: String = ""
    weak var delegate: BriefViewControllerDelegate?
    private var oldText: String = ""
    private var testED = TestEditor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwBorder.layer.borderColor = UIColor.black.cgColor
        vwBorder.layer.borderWidth = 0
        testED.view.frame = CGRect.init(x: 0, y: 0, width: vwEdit.frame.size.width, height: vwEdit.frame.size.height)
        vwEdit.addSubview(testED.view)
        self.addChild(testED)
        testED.didMove(toParent: self)
        registerForKeyboardNotifications(scrollView: mainScrollView)
    }
    
    func setView(ID: String, Text: String) {
        self.ID = ID
        oldText = Text
        testED.setView(Value: Text)
    }
    
    @IBAction func onBtnOK(_ Sender: UIButton) {
        
        if oldText != testED.getHTML() {
            delegate?.doneEdit(Text: testED.getHTML())
        } else {
            delegate?.doneEdit(Text: oldText)
        }
        self.removeSubviewWithAnimation(self)
        
    }
    @IBAction func onBtnCancel(_ Sender: UIButton) {
        let alert = UIAlertController.init(title: "Confirm to exit", message: "Confirm to exit without save your Brief?", preferredStyle: .alert)
        let okAcion = UIAlertAction.init(title: "OK", style: .default) { (action) in
            self.removeSubviewWithAnimation(self)
        }
        alert.addAction(okAcion)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(cancelAction)
        alert.modalPresentationStyle = .overFullScreen
        self.present(alert, animated: true)
        //delegate?.showAlert(alertView: alert)
    }
}
