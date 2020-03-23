//
//  VCoolRevisePopup.swift
//  Trading Mobile
//
//  Created by Thisan Thanthanakul on 7/2/2561 BE.
//  Copyright © 2561 PTT ICT Solutions. All rights reserved.
//

import Foundation
import UIKit

protocol VCoolRevisePopupDelegate: class {
    func onBtnOK(reasonText: String, Flag1: String, Flag2: String)
}

class VCoolRevisePopup: BaseDetailViewController {
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var txtReason: UITextField!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var button: ActionButton = ActionButton()
    weak var delegate: VCoolRevisePopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCheckButton()
    }
    
    func initCheckButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        self.btn1.setImage(UIImage.init(named: "Check0"), for: .normal)
        self.btn1.setImage(UIImage.init(named: "Check1"), for: .selected)
        self.btn2.setImage(UIImage.init(named: "Check0"), for: .normal)
        self.btn2.setImage(UIImage.init(named: "Check1"), for: .selected)
    }
    
    func check() -> Bool {
        if self.btn1.isSelected || self.btn2.isSelected {
            return true
        }
        return false
    }
    
    @IBAction func onBtnCheck(_ Sender: UIButton) {
        Sender.isSelected = !Sender.isSelected
    }
    
    @IBAction func onBtnOK(_ Sender: UIButton) {
        var flag1 = ""
        var flag2 = ""
        if btn1.isSelected {
            flag1 = "W"
        }
        if btn2.isSelected {
            flag2 = "W"
        }
        delegate?.onBtnOK(reasonText: txtReason.text!, Flag1: flag1, Flag2: flag2)
        if txtReason.text?.trim().count != 0 {
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    @IBAction func onBtnCancel(_ Sender: UIButton) {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
