//
//  BaseViewController.swift
//  StageProgram
//
//  Created by Rohit Sharma on 11/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import MBProgressHUD

class SPBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#a4001d")
        self.navigationController?.navigationBar.tintColor = UIColor.white  
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func showAlert(withTitle title: String = "Stage Program", withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
}

//  For showing & Hiding Progress View
extension SPBaseViewController {
    func showProgressHUD() {
        if let keyWindow = UIApplication.shared.windows.first {
            MBProgressHUD.showAdded(to: keyWindow, animated: true)
        }
    }
    
    func hideProgressHUD() {
        if let keyWindow = UIApplication.shared.windows.first {
            MBProgressHUD.hide(for: keyWindow, animated: true)
        }
    }
}
