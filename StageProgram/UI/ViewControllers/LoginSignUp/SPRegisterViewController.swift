//
//  RegisterViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 25/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class SPRegisterViewController: SPBaseViewController {

    @IBOutlet weak var txtfName: UITextField!
    @IBOutlet weak var txtfEmail: UITextField!
    @IBOutlet weak var txtfPassword: UITextField!
    @IBOutlet weak var txtfConfirmPassword: UITextField!
    @IBOutlet weak var txtfPhone: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        self.txtfEmail.layer.cornerRadius = 20.0
        self.txtfName.layer.cornerRadius = 20.0
        self.txtfConfirmPassword.layer.cornerRadius = 20.0
        self.txtfPhone.layer.cornerRadius = 20.0
        self.txtfPassword.layer.cornerRadius = 20.0
        self.btnRegister.layer.cornerRadius = 20.0
        
        self.txtfEmail.layer.borderColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).cgColor
        self.txtfEmail.layer.borderWidth = 1.0
        self.txtfPassword.layer.borderColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).cgColor
        self.txtfPassword.layer.borderWidth = 1.0
        self.txtfName.layer.borderColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).cgColor
        self.txtfName.layer.borderWidth = 1.0
        self.txtfConfirmPassword.layer.borderColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).cgColor
        self.txtfConfirmPassword.layer.borderWidth = 1.0
        self.txtfPhone.layer.borderColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).cgColor
        self.txtfPhone.layer.borderWidth = 1.0
        
        let leftViewEmail = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtfEmail.frame.size.height))
        self.txtfEmail.leftView = leftViewEmail
        self.txtfEmail.leftViewMode = .always
        
        let leftViewPass = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtfEmail.frame.size.height))
        self.txtfPassword.leftView = leftViewPass
        self.txtfPassword.leftViewMode = .always
        
        let leftViewName = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtfEmail.frame.size.height))
        self.txtfName.leftView = leftViewName
        self.txtfName.leftViewMode = .always
        
        let leftViewConfirmPass = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtfEmail.frame.size.height))
        self.txtfConfirmPassword.leftView = leftViewConfirmPass
        self.txtfConfirmPassword.leftViewMode = .always
        
        let leftViewPhone = UIView(frame: CGRect(x: 0, y: 0, width: 67, height: self.txtfEmail.frame.size.height))
        let flag = UIImageView(image: UIImage(named: "India_flag"))
        flag.contentMode = .scaleAspectFit
        flag.frame = CGRect(x: 20, y: 0, width: 21, height: leftViewPhone.frame.size.height)
        leftViewPhone.addSubview(flag)
        
        let arrowDown = UIImageView(image: UIImage(named: "ic_arrow_down"))
        arrowDown.contentMode = .scaleAspectFit
        arrowDown.frame = CGRect(x: 45, y: 0, width: 7, height: leftViewPhone.frame.size.height)
        leftViewPhone.addSubview(arrowDown)
        
        let separator = UIView(frame: CGRect(x: 58, y: 0, width: 2, height: leftViewPhone.frame.size.height))
        separator.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0)
        leftViewPhone.addSubview(separator)
        
        self.txtfPhone.leftView = leftViewPhone
        self.txtfPhone.leftViewMode = .always
    }
    
    //MARK: IBActions
    @IBAction func btnLoginTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}