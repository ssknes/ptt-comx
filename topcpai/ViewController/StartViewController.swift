//
//  StartController.swift
//  topcpai
//
//  Created by Piyanant Srisirinant on 11/30/2559 BE.
//  Copyright © 2559 Piyanant Srisirinant. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            // Put your code which should be executed with a delay here
            self.spinner.stopAnimating()
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "main") as! SignInViewController
            let mainController = UINavigationController(
                rootViewController: homeVC
            )
            UIApplication.shared.keyWindow?.rootViewController = mainController
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
