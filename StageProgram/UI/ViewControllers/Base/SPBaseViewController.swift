//
//  BaseViewController.swift
//  StageProgram
//
//  Created by Rohit Sharma on 11/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import MBProgressHUD
import SideMenu

enum LeftBarButtonType {
    case Menu
    case WhiteBack
    case RedBack
}


class SPBaseViewController: UIViewController {

    var sideMenu : SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#a4001d")
        self.navigationController?.navigationBar.tintColor = UIColor.white  
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func handleLeftBarButtonItem(leftButtonType: LeftBarButtonType) {
        if leftButtonType == .Menu {
            let image = UIImage(named: "MenuIcon")?.withRenderingMode(.alwaysOriginal)
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showSideMenu))
        }else if leftButtonType == .WhiteBack {
             let image = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(moveBack))
        }
    }
    
    @objc func moveBack() {
        self.navigationController?.popViewController(animated: true)
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

//MARK: SideMenu related methods
extension SPBaseViewController {
    @objc func showSideMenu() {
        if let _ = self.sideMenu {
            self.present(self.sideMenu!, animated: true, completion: nil)
        } else {
            let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let sideMenuController = homeStoryboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SPSideMenuViewController
            self.sideMenu = SideMenuNavigationController(rootViewController: sideMenuController)
            self.sideMenu?.navigationBar.isHidden = true
            self.sideMenu?.leftSide = true
            self.sideMenu?.statusBarEndAlpha = 0
            self.present(self.sideMenu!, animated: true, completion: nil)
        }
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
