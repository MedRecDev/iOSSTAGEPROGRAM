//
//  VideoUploadViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 02/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class VideoUploadViewController: SPBaseViewController {

    @IBOutlet weak var txtvDescription: UITextView!
    @IBOutlet weak var txtfTitle: UITextField!
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnTypeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnCategoryWidthConstraint: NSLayoutConstraint!
    
    var videoUrl : URL?
    var videoFeedOptions = ["Stage Show", "Video Feed"]
    var categories : [SPState]? = StatesDataManager.shared.states
    var fileUrlData: String?
    let uploadVideoManager : UploadVideoDataManager = UploadVideoDataManager()
    var finalOutputUrl: URL?
    
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
        
        self.txtvDescription.layer.borderColor = UIColor(hexString: "#D6D6D6").cgColor
        self.txtvDescription.layer.borderWidth = 1.0
        self.txtvDescription.layer.cornerRadius = 5.0
        
        
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 1136 {
            self.btnTypeWidthConstraint.constant = 130
            self.btnCategoryWidthConstraint.constant = 130
        }
        
        self.btnUpload.layer.cornerRadius = 20.0
    }
    
    func resetAllFields() {
        self.txtfTitle.text = ""
        self.txtvDescription.text = ""
        self.fileUrlData = nil
        self.btnCategory.setTitle("Category", for: .normal)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectVideo(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
//        imagePickerController.mediaTypes = [kUTTypeMPEG4 as String]
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
        } else if self.txtvDescription.text!.count <= 0 {
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
            self.uploadVideoManager.uploadVideo(videoTitle: self.txtfTitle.text!, videoDescription: self.txtvDescription.text!, stateId: state!.stateId, videoFilePath: self.fileUrlData!) { (successMessage, errorMessage) in
                self.hideProgressHUD()
                self.resetAllFields()
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
                self.encodeVideo(videoUrl: fileUrl) { (url) in
                    self.fileUrlData = self.finalOutputUrl?.absoluteString
                }
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

extension VideoUploadViewController {
    func encodeVideo(videoUrl: URL, outputUrl: URL? = nil, resultClosure: @escaping (URL?) -> Void ) {

        self.finalOutputUrl = outputUrl

        if finalOutputUrl == nil {
            var url = videoUrl
            url.deletePathExtension()
            url.appendPathExtension("mp4")
            finalOutputUrl = url
        }

        if FileManager.default.fileExists(atPath: finalOutputUrl!.path) {
            print("Converted file already exists \(finalOutputUrl!.path)")
            resultClosure(finalOutputUrl)
            return
        }

        let asset = AVURLAsset(url: videoUrl)
        if let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough) {
            exportSession.outputURL = finalOutputUrl!
            exportSession.outputFileType = AVFileType.mp4
            let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
            let range = CMTimeRangeMake(start: start, duration: asset.duration)
            exportSession.timeRange = range
            exportSession.shouldOptimizeForNetworkUse = true
            exportSession.exportAsynchronously() {

                switch exportSession.status {
                case .failed:
                    print("Export failed: \(exportSession.error != nil ? exportSession.error!.localizedDescription : "No Error Info")")
                case .cancelled:
                    print("Export canceled")
                case .completed:
                    resultClosure(self.finalOutputUrl!)
                default:
                    break
                }
            }
        } else {
            resultClosure(nil)
        }
    }
}
