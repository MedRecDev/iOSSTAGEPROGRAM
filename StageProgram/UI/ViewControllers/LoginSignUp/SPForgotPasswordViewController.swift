//
//  SPForgotPasswordViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 25/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class SPForgotPasswordViewController: SPBaseViewController {

    @IBOutlet weak var txtfEmail: UITextField!
    @IBOutlet weak var btnSendEmail: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        self.txtfEmail.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0)])
        
        self.txtfEmail.layer.cornerRadius = 20.0
        self.btnSendEmail.layer.cornerRadius = 20.0
        
        self.txtfEmail.layer.borderColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).cgColor
        self.txtfEmail.layer.borderWidth = 1.0
        
        let leftViewEmail = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtfEmail.frame.size.height))
        self.txtfEmail.leftView = leftViewEmail
        self.txtfEmail.leftViewMode = .always
    }
    
    @IBAction func sendEmailTapped(_ sender: Any) {
        guard let email = self.txtfEmail.text else {
            self.showAlert(withMessage: "Please enter a valid email address.")
            return
        }
        guard email.isValidEmail() else {
            self.showAlert(withMessage: "Please enter a valid email address.")
            return
        }
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
