//
//  SPForgotPasswordViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 25/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class SPForgotPasswordViewController: UIViewController {

    @IBOutlet weak var txtfEmail: UITextField!
    @IBOutlet weak var btnSendEmail: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        self.txtfEmail.layer.cornerRadius = 20.0
        self.btnSendEmail.layer.cornerRadius = 20.0
        
        self.txtfEmail.layer.borderColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).cgColor
        self.txtfEmail.layer.borderWidth = 1.0
        
        let leftViewEmail = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.txtfEmail.frame.size.height))
        self.txtfEmail.leftView = leftViewEmail
        self.txtfEmail.leftViewMode = .always
    }
    
    @IBAction func sendEmailTapped(_ sender: Any) {
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
