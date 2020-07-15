//
//  OTPViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 07/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class OTPViewController: SPBaseViewController {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var textFieldWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtfFirst: UITextField!
    @IBOutlet weak var txtSecond: UITextField!
    @IBOutlet weak var txtfThird: UITextField!
    @IBOutlet weak var txtfFourth: UITextField!
    @IBOutlet weak var txtfFifth: UITextField!
    @IBOutlet weak var txtfSixth: UITextField!
    @IBOutlet weak var btnResendOtp: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    var userToken : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnLogin.layer.cornerRadius = 20.0
        
        self.updateTextFieldBorder(textfield: self.txtfFirst)
        self.updateTextFieldBorder(textfield: self.txtSecond)
        self.updateTextFieldBorder(textfield: self.txtfThird)
        self.updateTextFieldBorder(textfield: self.txtfFourth)
        self.updateTextFieldBorder(textfield: self.txtfFifth)
        self.updateTextFieldBorder(textfield: self.txtfSixth)
        
        self.txtfFirst.textAlignment = .center
        self.txtSecond.textAlignment = .center
        self.txtfThird.textAlignment = .center
        self.txtfFourth.textAlignment = .center
        self.txtfFifth.textAlignment = .center
        self.txtfSixth.textAlignment = .center
        
        self.txtfFirst.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.txtSecond.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.txtfThird.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.txtfFourth.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.txtfFifth.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        self.txtfSixth.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        let mutMessageAttrText = NSMutableAttributedString(string: "Please enter the OTP below to verify your email address. if you can't see the email in your ", attributes: [NSAttributedString.Key.font : UIFont(name: "Montserrat-Regular", size: 14.0), NSAttributedString.Key.foregroundColor : UIColor(red: 164/255, green: 0, blue: 29/255, alpha: 1.0)])
        mutMessageAttrText.append(NSAttributedString(string: "inbox", attributes: [NSAttributedString.Key.font : UIFont(name: "Montserrat-SemiBold", size: 14.0), NSAttributedString.Key.foregroundColor : UIColor(red: 164/255, green: 0, blue: 29/255, alpha: 1.0)]))
        mutMessageAttrText.append(NSAttributedString(string: " then please make sure to check on your ", attributes: [NSAttributedString.Key.font : UIFont(name: "Montserrat-Regular", size: 14.0), NSAttributedString.Key.foregroundColor : UIColor(red: 164/255, green: 0, blue: 29/255, alpha: 1.0)]))
        mutMessageAttrText.append(NSAttributedString(string: "spam", attributes: [NSAttributedString.Key.font : UIFont(name: "Montserrat-SemiBold", size: 14.0), NSAttributedString.Key.foregroundColor : UIColor(red: 164/255, green: 0, blue: 29/255, alpha: 1.0)]))
        self.lblMessage.attributedText = mutMessageAttrText
    }
    
    func updateTextFieldBorder(textfield: UITextField) {
        textfield.layer.cornerRadius = 10
        textfield.layer.borderColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).cgColor
        textfield.layer.borderWidth = 1.0
        
        textfield.layer.shadowOpacity = 1
        textfield.layer.shadowRadius = 5
        textfield.layer.shadowColor = UIColor.lightGray.cgColor
        textfield.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    @IBAction func resendOtpTapped(_ sender: Any) {
        self.showProgressHUD()
        UserDataManager.shared.resendOTP { (success, errorMessage) in
            self.hideProgressHUD()
            if success {
                self.showAlert(withMessage: "OTP has been send to your registered email id.")
            } else if let msg = errorMessage {
                self.showAlert(withMessage: msg)
            }
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let first = self.txtfFirst.text, let second = self.txtSecond.text, let third = self.txtfThird.text, let fourth = self.txtfFourth.text, let fifth = self.txtfFifth.text, let sixth = self.txtfSixth.text else {
            self.showAlert(withMessage: "Please enter a valid OTP")
            return
        }
        let otp = "\(first)\(second)\(third)\(fourth)\(fifth)\(sixth)"
        self.showProgressHUD()
        UserDataManager.shared.completeRegistrationWithOTP(otp: otp) { (success, errorMessage) in
            self.hideProgressHUD()
            if success {
                self.dismiss(animated: true, completion: nil)
            } else if let msg = errorMessage {
                self.showAlert(withMessage: msg)
            }
        }
    }
    
    @IBAction func moveBack(_ sender: Any) {
        if let navCtrl = self.navigationController {
            navCtrl.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension OTPViewController : UITextFieldDelegate {
    
    @objc func textFieldDidChange(textField: UITextField){
        if let text = textField.text, text.count >= 1{
            switch textField {
                case txtfFirst:
                    txtSecond.becomeFirstResponder()
                case txtSecond:
                    txtfThird.becomeFirstResponder()
                case txtfThird:
                    txtfFourth.becomeFirstResponder()
                case txtfFourth:
                    txtfFifth.becomeFirstResponder()
                case txtfFifth:
                    txtfSixth.becomeFirstResponder()
                case txtfSixth:
                    txtfSixth.resignFirstResponder()
                default:
                    break
            }
        }
    }
}
