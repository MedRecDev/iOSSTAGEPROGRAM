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

enum RightBarButtonType {
    case Upload
    case Profile
}

class SPBaseViewController: UIViewController {

    var sideMenu : SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#a4001d")
        self.navigationController?.navigationBar.tintColor = UIColor.white  
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 16)!]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func handleLeftBarButtonItem(leftButtonType: LeftBarButtonType) {
        if leftButtonType == .Menu {
            let image = UIImage(named: "MenuIcon")?.withRenderingMode(.alwaysOriginal)
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showSideMenu))
        }else if leftButtonType == .WhiteBack {
             let image = UIImage(named: "white_back")?.withRenderingMode(.alwaysOriginal)
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(moveBack))
        }
    }
    
    func handleRightBarButtonItem(rightButtonTypes: [RightBarButtonType]) {
        var barButtonItems : [UIBarButtonItem] = []
        for buttonType in rightButtonTypes {
            if buttonType == .Upload {
                let image = UIImage(named: "ic_file_upload")?.withRenderingMode(.alwaysOriginal)
                let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(uploadVideo))
                barButtonItems.append(barButton)
            } else if buttonType == .Profile {
                let rightButton = UIButton(frame: CGRect(x: 0, y: 20, width: 30, height: 30))
                let placeholderImage = UIImage(named: "user_placeholder")
                rightButton.setBackgroundImage(placeholderImage, for: .normal)
                rightButton.addTarget(self, action: #selector(didTapOnUser), for: .touchUpInside)
                rightButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
                rightButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
                let rightBarButtomItem = UIBarButtonItem(customView: rightButton)
                barButtonItems.append(rightBarButtomItem)
            }
        }
        navigationItem.rightBarButtonItems = barButtonItems
    }
    
    @objc func didTapOnUser() {
        let isRegistrationComplete = UserDefaults.standard.bool(forKey: KEY_REGISTRATION_COMPLETED)
        if let _ = UserDefaults.standard.value(forKey: KEY_USER_TOKEN), isRegistrationComplete {
            //  Will show Profile screen
        } else {
            if let _ = UserDefaults.standard.value(forKey: KEY_USER_TOKEN) {
                let loginStoryboard = UIStoryboard(name: "LoginSignup", bundle: nil)
                let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "OTPViewController") as! UINavigationController
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            } else {
                let loginStoryboard = UIStoryboard(name: "LoginSignup", bundle: nil)
                let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "loginNavigationController") as! UINavigationController
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc func uploadVideo() {
        let isRegistrationComplete = UserDefaults.standard.bool(forKey: KEY_REGISTRATION_COMPLETED)
        if let _ = UserDefaults.standard.value(forKey: KEY_USER_TOKEN), isRegistrationComplete {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let videoUploadVC = storyboard.instantiateViewController(withIdentifier: "VideoUploadViewController")
            videoUploadVC.modalPresentationStyle = .fullScreen
            self.present(videoUploadVC, animated: true, completion: nil)
        } else {
            if let _ = UserDefaults.standard.value(forKey: KEY_USER_TOKEN) {
                let loginStoryboard = UIStoryboard(name: "LoginSignup", bundle: nil)
                let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            } else {
                let loginStoryboard = UIStoryboard(name: "LoginSignup", bundle: nil)
                let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "loginNavigationController") as! UINavigationController
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc func moveBack() {
        if let _ = self.presentingViewController {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
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
