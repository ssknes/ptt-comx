//
//  AboutViewController.swift
//  topcpai
//
//  Created by Piyanant Srisirinant on 12/15/2559 BE.
//  Copyright © 2559 PTT ICT Solutions. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var appLabel: UILabel!
    @IBOutlet weak var iOSLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appLabel.text = GlobalVar.sharedInstance.appVersion + " Beta"
        iOSLabel.text = IOSVersion.getVersion()
        //btn.addTarget(self, action: #selector(onBtnBack(_:)), for: .touchUpInside)
        
        let backBtn = UIBarButtonItem.init(image: UIImage.init(named: "back_bt-icon"), style: .plain, target: self, action: #selector(onBtnBack(_:)))
        
        self.navigationItem.leftBarButtonItem = backBtn
        
        //let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "buttonMethod")
        //navigationItem.leftBarButtonItem = refreshButton
    }
    
    @objc func onBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
