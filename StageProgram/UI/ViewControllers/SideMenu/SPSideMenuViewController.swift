//
//  SideMenuViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 23/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class SPSideMenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var sideMenuTitles = ["Profile", "Privacy Policy", "Share", "Feedback", "About us", "Contact us"]
    var sideMenuImages = ["ic_person", "ic_lock", "ic_share", "ic_feedback", "ic_info", "ic_phone"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "SideMenuTVCell", bundle: nil), forCellReuseIdentifier: "SideMenuTVCell")
        self.tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
}

extension SPSideMenuViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sideMenuImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTVCell", for: indexPath) as! SideMenuTVCell
        cell.updateUI(imageName: sideMenuImages[indexPath.row], title: sideMenuTitles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let isRegistrationComplete = UserDefaults.standard.bool(forKey: KEY_REGISTRATION_COMPLETED)
            if let _ = UserDefaults.standard.value(forKey: KEY_USER_TOKEN), isRegistrationComplete {
                //  Will show Profile screen
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
        } else if indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let webVC = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
            webVC.type = .PrivacyPolicy
            let navController = UINavigationController(rootViewController: webVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
        else if indexPath.row == 2 {
            let news = "Download App :- https://bit.ly/3ePhhqM #stageprogram #stageprograms #stageshow #stagedance #shortvideo #india"
            let image = UIImage(named: "featuregraphic")
            let activityVC = UIActivityViewController(activityItems: [image, news], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
        else if indexPath.row == 3 {
            //  Feedback
        }
        else if indexPath.row == 4 {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let webVC = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
            webVC.type = .AboutUs
            let navController = UINavigationController(rootViewController: webVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
        else if indexPath.row == 5 {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let webVC = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
            webVC.type = .ContactUs
            let navController = UINavigationController(rootViewController: webVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
}
