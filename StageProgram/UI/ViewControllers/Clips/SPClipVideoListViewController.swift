//
//  SPClipVideoListViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 17/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class SPClipVideoListViewController: SPBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var clipDataManager: ClipsDataManager!
    var canSetOffset: Bool = true
    let columnLayout = CustomClipFeedFlowlayout(
        cellsPerRow: 2,
        minimumInteritemSpacing: 0,
        minimumLineSpacing: 0,
        sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.isHidden = true
        self.collectionView.collectionViewLayout = columnLayout
        self.collectionView.register(UINib(nibName: "SPClipFeedCVCell", bundle: nil), forCellWithReuseIdentifier: "SPClipFeedCVCell")
    }
    
    deinit {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if canSetOffset {
            if let index = self.clipDataManager.indexForSelectedFeed() {
                self.collectionView.contentOffset = CGPoint(x: 0, y: (CGFloat(index) * CGFloat(self.collectionView.frame.size.height)))
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension SPClipVideoListViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.clipDataManager.clipFeeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPClipFeedCVCell", for: indexPath) as! SPClipFeedCVCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let lastCell = cell as? SPClipFeedCVCell {
            NSLog(">>>>>>>>>>>>>> Displayed IndexPath Row : \(indexPath.row)")
            let clip = self.clipDataManager.clipFeeds[indexPath.row]
            self.increaseViewsCount(clip: clip)
            lastCell.playVideo(clipFeed: clip)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let lastCell = cell as? SPClipFeedCVCell {
            NSLog("<<<<<<<<<<<<<<< Removed IndexPath Row : \(indexPath.row)")
            canSetOffset = false
            lastCell.pause()
        }
    }
}

extension SPClipVideoListViewController: SPClipFeedCVCellDelegate {
    func sendLikeEvent(clipFeed: SPClipFeed, cell: SPClipFeedCVCell) {
        let isRegistrationComplete = UserDefaults.standard.bool(forKey: KEY_REGISTRATION_COMPLETED)
        if let _ = UserDefaults.standard.value(forKey: KEY_USER_TOKEN), isRegistrationComplete {
            self.showProgressHUD()
            self.clipDataManager.feedLike(clip: clipFeed) { (dict, errorMessage) in
                self.hideProgressHUD()
                if let countDict = dict {
                    if let likeCount = countDict["like_count"]?.intValue, let unlikeCount = countDict["unlike_count"]?.intValue {
                        self.clipDataManager.updateLikeCount(likes: likeCount, unlikes: unlikeCount, feedSourceId: clipFeed.feedSourceId) { (likes) in
                            cell.lblLikeCount.text = "\(likes)"
                        }
                        if likeCount == 0 {
                            cell.btnLike.isSelected = false
                        } else {
                            cell.btnLike.isSelected = true
                        }
                    }
                } else if let msg = errorMessage {
                    self.showAlert(withMessage: msg)
                }
            }
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
    
    func sendShareEvent(clipFeed: SPClipFeed) {
        
    }
    
    func sendReportEvent(clipFeed: SPClipFeed) {
        self.showProgressHUD()
        self.clipDataManager.reportFeedSpam(clip: clipFeed, reason: "Spam") { (successMsg, errorMsg) in
            self.hideProgressHUD()
            if let success = successMsg {
                self.showAlert(withMessage: success)
            }
        }
    }
    
    func sendCommentEvent(clipFeed: SPClipFeed) {
        
    }
    
    func increaseViewsCount(clip: SPClipFeed) {
        self.clipDataManager.increaseViewCountForClip(clip: clip)
        self.clipDataManager.updateViewCounts(feedSourceId: clip.feedSourceId)
    }
}
