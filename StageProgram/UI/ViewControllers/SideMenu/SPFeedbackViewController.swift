//
//  SPFeedbackViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 16/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class SPFeedbackViewController: SPBaseViewController {

    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtvFeedback: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Feedback"
        self.handleLeftBarButtonItem(leftButtonType: .WhiteBack)
        self.handleRightBarButtonItem(rightButtonTypes: [.FeedbackSend])
        
        self.btnSend.layer.cornerRadius = 20.0
        
        self.txtvFeedback.layer.cornerRadius = 10.0
        self.txtvFeedback.layer.borderWidth = 1.0
        self.txtvFeedback.layer.borderColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).cgColor
        
        self.txtvFeedback.layer.shadowOpacity = 1
        self.txtvFeedback.layer.shadowRadius = 5
        self.txtvFeedback.layer.shadowColor = UIColor.lightGray.cgColor
        self.txtvFeedback.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    @IBAction func sendFeedback(_ sender: Any) {
        self.sendFeedback()
    }
    
    @objc override func sendFeedback() {
        guard let feedbackDescription = self.txtvFeedback.text, feedbackDescription.count > 0 else {
            self.showAlert(withMessage: "Please enter description for feedback.")
            return
        }
        self.showProgressHUD()
        let title = "Stage Program Feedback"
        UserDataManager.shared.sendFeedback(title: title, description: feedbackDescription) { (success, message) in
            self.hideProgressHUD()
            if let msg = message {
                let alertController = UIAlertController(title: "Stage Program", message: msg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default) { (okAction) in
                    if let _ = self.presentingViewController {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
