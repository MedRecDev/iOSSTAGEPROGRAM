//
//  CustomSplashViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 20/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class CustomSplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchToken()
    }
    
    func fetchToken() {
        UserDataManager.shared.createToken { (success, message) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.createHomeController()
        }
    }
}
