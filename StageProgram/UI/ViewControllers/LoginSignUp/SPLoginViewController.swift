//
//  LoginViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 25/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class SPLoginViewController: SPBaseViewController {

    @IBOutlet weak var txtfPassword: UITextField!
    @IBOutlet weak var txtfEmail: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.txtfEmail.layer.cornerRadius = 20.0
        self.txtfPassword.layer.cornerRadius = 20.0
        self.btnLogin.layer.cornerRadius = 20.0
        
        self.txtfEmail.layer.borderColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).cgColor
        self.txtfEmail.layer.borderWidth = 1.0
        self.txtfPassword.layer.borderColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).cgColor
        self.txtfPassword.layer.borderWidth = 1.0
        
        let leftViewEmail = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtfEmail.frame.size.height))
        self.txtfEmail.leftView = leftViewEmail
        self.txtfEmail.leftViewMode = .always
        
        let leftViewPass = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtfEmail.frame.size.height))
        self.txtfPassword.leftView = leftViewPass
        self.txtfPassword.leftViewMode = .always
    }
    
    //MARK: IBActions
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showForgotPasswordSegue", sender: nil)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        self.showProgressHUD()
        UserDataManager.shared.userLogin(email: self.txtfEmail.text!, password: self.txtfPassword.text!) { (success, errorMessage) in
            self.hideProgressHUD()
            if success {
                self.dismiss(animated: true, completion: nil)
            } else if let msg = errorMessage{
                self.showAlert(withMessage: msg)
            }
        }
    }
    
    @IBAction func registerNowTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showRegisterSegue", sender: nil)
    }
}


