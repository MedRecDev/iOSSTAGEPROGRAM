//
//  SPVideoDetailViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 24/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import VersaPlayer
import SDWebImage
import FirebaseAnalytics

class SPVideoDetailViewController: SPBaseViewController {

    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var versaPlayerControls: VersaPlayerControls!
    @IBOutlet weak var versaPlayer: VersaPlayerView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    @IBOutlet weak var lblPublishedDate: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblDislikeCount: UILabel!
    @IBOutlet weak var lblShareCount: UILabel!
    var videoDetail : SPVideoDetail!
    var videoDetailDM : VideoDetailDataManager = VideoDetailDataManager()
    var videoTumbnailImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor(red: 164/255, green: 0, blue: 29/255, alpha: 1.0)
        self.navigationController?.navigationBar.isHidden = true
        
        self.tableView.register(UINib(nibName: "SuggestedVideoTVCell", bundle: nil), forCellReuseIdentifier: "SuggestedVideoTVCell")
        self.tableView.separatorStyle = .none
        
        self.videoDetailDM.videoDetail = self.videoDetail
        self.fetchSuggestedVideos()
        self.updateUI()
        SDWebImageManager.shared.loadImage(with: URL(string: self.videoDetail!.mainThumbnailUrl), options: [], progress: nil) { (image, data, error, cacheType, success, url) in
            self.videoTumbnailImage = image
        }
        if let videoTitle = self.videoDetail.videoTitle {
            Analytics.setScreenName(videoTitle, screenClass: "SPVideoDetailViewController")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.versaPlayer.pause()
    }
    
    func updateUI() {
        if let url = URL(string: self.videoDetail.mediaUrl) {
            self.versaPlayer.use(controls: self.versaPlayerControls)
            let playerItem = VersaPlayerItem(url: url)
            self.versaPlayer.set(item: playerItem)
        }
        
        self.lblTitle.text = self.videoDetail.videoTitle
        self.lblDescription.text = self.videoDetail.videoDescription
        self.viewCount.text = "\(self.videoDetail.totalViews ?? 0) views"
        if let date = self.videoDetail.createdDate {//2020-04-11T05:48:45
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            if let dateString = dateFormat.date(from: date) {
                self.lblPublishedDate.text = dateString.timeAgoDisplay()
            }
        }
        self.lblLikeCount.text = "\(self.videoDetail.totalLike ?? 0)"
        self.lblDislikeCount.text = "\(self.videoDetail.totalDislike ?? 0)"
        self.lblShareCount.text = "Share"
    }
    
    func fetchSuggestedVideos() {
        self.showProgressHUD()
        self.videoDetailDM.fetchSuggestedVideos { (success, errorMessage) in
            self.hideProgressHUD()
            if success {
                if let videos = self.videoDetailDM.suggestedVideos {
                    self.tableViewHeightConstraint.constant = CGFloat(videos.count) * 110
                    self.view.layoutIfNeeded()
                    self.view.setNeedsLayout()
                }
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: IBActions
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func likeTapped(_ sender: Any) {
        let isRegistrationComplete = UserDefaults.standard.bool(forKey: KEY_REGISTRATION_COMPLETED)
        if let _ = UserDefaults.standard.value(forKey: KEY_USER_TOKEN), isRegistrationComplete {
            self.showProgressHUD()
            self.videoDetailDM.videoLike { (likeCount, errorMessage) in
                self.hideProgressHUD()
                if let likeCount = likeCount {
                    self.lblLikeCount.text = "\(likeCount)"
                } else if let msg = errorMessage {
                    self.showAlert(withMessage: msg)
                }
            }
        } else {
            let loginStoryboard = UIStoryboard(name: "LoginSignup", bundle: nil)
            let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "loginNavigationController") as! UINavigationController
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func dislikeTapped(_ sender: Any) {
        let isRegistrationComplete = UserDefaults.standard.bool(forKey: KEY_REGISTRATION_COMPLETED)
        if let _ = UserDefaults.standard.value(forKey: KEY_USER_TOKEN), isRegistrationComplete {
            self.showProgressHUD()
            self.videoDetailDM.videoDisLike { (likeCount, errorMessage) in
                self.hideProgressHUD()
                if let unLikeCount = likeCount {
                    self.lblDislikeCount.text = "\(unLikeCount)"
                } else if let msg = errorMessage {
                    self.showAlert(withMessage: msg)
                }
            }
        } else {
            let loginStoryboard = UIStoryboard(name: "LoginSignup", bundle: nil)
            let loginVC = loginStoryboard.instantiateViewController(withIdentifier: "loginNavigationController") as! UINavigationController
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        let card = FlashCard()
        card.news = "Download App :- https://bit.ly/3ePhhqM #stageprogram #stageprograms #stageshow #stagedance #shortvideo #india"
        card.url = self.videoDetail.videoShareUrl
        card.thumbnailUrl = self.videoDetail.mainThumbnailUrl
        var imageItem : UIImage? = videoTumbnailImage
        if let image = videoTumbnailImage {
            imageItem = image
        } else {
            imageItem = UIImage(named: "placeholder_rectangle")
        }
        let activityVC = UIActivityViewController(activityItems: [card, imageItem!], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
}

extension SPVideoDetailViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let videos = self.videoDetailDM.suggestedVideos {
            return videos.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestedVideoTVCell", for: indexPath) as! SuggestedVideoTVCell
        let video = self.videoDetailDM.suggestedVideos![indexPath.row]
        cell.updateUI(videoDetail: video)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = self.videoDetailDM.suggestedVideos![indexPath.row]
        self.videoDetail = video
        self.videoDetailDM.videoDetail = video
        self.fetchSuggestedVideos()
        self.updateUI()
    }
}

class FlashCard: NSObject, UIActivityItemSource {
    var news: String = ""
    var url : String = ""
    var thumbnailUrl : String = ""
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return news;
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if activityType == UIActivity.ActivityType.postToTwitter {
            return news + url
        } else {
            return url
        }
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return thumbnailUrl
    }
}
