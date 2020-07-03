//
//  VideoUploadViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 02/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class VideoUploadViewController: SPBaseViewController {

    @IBOutlet weak var txtfDescription: UITextField!
    @IBOutlet weak var txtfTitle: UITextField!
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnTypeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnCategoryWidthConstraint: NSLayoutConstraint!
    
    var videoUrl : URL?
    var videoFeedOptions = ["Stage Show", "Video Feed"]
    var categories : [SPState]? = StatesDataManager.shared.states
    var fileUrlData: Data?
    let uploadVideoManager : UploadVideoDataManager = UploadVideoDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor(red: 164/255, green: 0, blue: 29/255, alpha: 1.0)
        self.navigationController?.navigationBar.isHidden = true
        
        self.btnType.layer.borderColor = UIColor(hexString: "d6d6d6").cgColor
        self.btnType.layer.borderWidth = 1.0
        self.btnType.layer.cornerRadius = 5.0
        
        self.btnCategory.layer.borderColor = UIColor(hexString: "d6d6d6").cgColor
        self.btnCategory.layer.borderWidth = 1.0
        self.btnCategory.layer.cornerRadius = 5.0
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 1136 {
            self.btnTypeWidthConstraint.constant = 130
            self.btnCategoryWidthConstraint.constant = 130
        }
        
        self.btnUpload.layer.cornerRadius = 20.0
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectVideo(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func updateVideoFeed(_ sender: Any) {
        RPicker.selectOption(title: "Select Type", hideCancel: false, dataArray: videoFeedOptions, selectedIndex: 0) { (type, selectIndex) in
            self.btnType.setTitle(type, for: .normal)
        }
    }
    
    @IBAction func updateCategory(_ sender: Any) {
        if let categories = self.categories {
            var categoryNames : [String] = []
            for category in categories {
                if category.stateId != 0 {
                    categoryNames.append(category.stateName)
                }
            }
            RPicker.selectOption(title: "Select Category", hideCancel: false, dataArray: categoryNames, selectedIndex: 0) { (category, selectIndex) in
                self.btnCategory.setTitle(category, for: .normal)
            }
        }
    }
    
    @IBAction func uploadTapped(_ sender: Any) {
        var message : String?
        if self.btnCategory.title(for: .normal) == "Category" {
            message = "Please select a category"
        } else if self.txtfTitle.text!.count <= 0 {
            message = "Please enter a title for the video"
        } else if self.txtfDescription.text!.count <= 0 {
            message = "Please enter a category for the video"
        } else if self.fileUrlData == nil {
            message = "Please select a video file"
        }
        if message != nil {
            let alertController = UIAlertController(title: "Stage Program", message: message, preferredStyle: .alert)
            let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(oKAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let stateName = self.btnCategory.title(for: .normal)
            let state = self.categories?.filter({ (state) -> Bool in
                return state.stateName == stateName
                }).first
            self.showProgressHUD()
            self.uploadVideoManager.uploadVideo(videoTitle: self.txtfTitle.text!, videoDescription: self.txtfDescription.text!, stateId: state!.stateId, videoFilePath: self.fileUrlData!) { (successMessage, errorMessage) in
                self.hideProgressHUD()
                if let successMsg = successMessage {
                    let alertController = UIAlertController(title: "Stage Program", message: successMsg, preferredStyle: .alert)
                    let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(oKAction)
                    self.present(alertController, animated: true, completion: nil)
                } else if let errorMsg = errorMessage {
                    let alertController = UIAlertController(title: "Stage Program", message: errorMsg, preferredStyle: .alert)
                    let oKAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(oKAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension VideoUploadViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let fileUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            do {
                let data = try Data(contentsOf: fileUrl)
                self.fileUrlData = data
            } catch {
                print("Error occurred")
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension VideoUploadViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
