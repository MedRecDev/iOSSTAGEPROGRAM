//
//  SPVideoDetailViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 24/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAnalytics
import BMPlayer
import SwiftyJSON

class SPVideoDetailViewController: SPBaseViewController {

    @IBOutlet weak var playerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    @IBOutlet weak var lblPublishedDate: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblDislikeCount: UILabel!
    @IBOutlet weak var lblShareCount: UILabel!
    
    var player: BMPlayer!
    var videoDetail : SPVideoDetail!
    var videoDetailDM : VideoDetailDataManager = VideoDetailDataManager()
    var videoTumbnailImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor(red: 164/255, green: 0, blue: 29/255, alpha: 1.0)
        self.navigationController?.navigationBar.isHidden = true
        
        self.tableView.register(UINib(nibName: "SuggestedVideoTVCell", bundle: nil), forCellReuseIdentifier: "SuggestedVideoTVCell")
        self.tableView.separatorStyle = .none
        
        self.setupBMPlayer()
        
        self.updatePlayerConfiguration()
        
        self.videoDetail.totalViews += 1
        self.videoDetailDM.videoDetail = self.videoDetail
        self.increaseViewCount()
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
    }
    
    func setupBMPlayer() {
        let controlView = BMPlayerControlView()
        controlView.backButton.isHidden = true
        player = BMPlayer(customControllView: controlView)
        self.playerContainer.addSubview(player)
        player.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.playerContainer)
            make.left.right.equalTo(self.playerContainer)
            make.height.equalTo(self.playerContainer)
            make.width.equalTo(self.playerContainer)
        }
        // Back button event
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true { return }
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func updatePlayerConfiguration() {
        BMPlayerConf.enablePlaytimeGestures = true
        BMPlayerConf.enableVolumeGestures = true
        self.player.delegate = self
    }
    
    func updateUI() {
        if let encodedURL = self.videoDetail.mediaUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedURL) {
            let asset = BMPlayerResource(url: url)
            self.player.setVideo(resource: asset)
            self.player.play()
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
    
    func increaseViewCount() {
        self.videoDetailDM.increaseVideoViews { (success, errorMsg) in
            print("Video view count increased")
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
            self.videoDetailDM.videoLike { (dict, errorMessage) in
                self.hideProgressHUD()
                    if let countDict = dict {
                    if let unlikeCount = countDict["unlike_count"]?.intValue {
                        self.lblDislikeCount.text = "\(String(describing: unlikeCount))"
                    }
                    if let likeCount = countDict["like_count"]?.intValue {
                        self.lblLikeCount.text = "\(String(describing:likeCount))"
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
    
    @IBAction func dislikeTapped(_ sender: Any) {
        let isRegistrationComplete = UserDefaults.standard.bool(forKey: KEY_REGISTRATION_COMPLETED)
        if let _ = UserDefaults.standard.value(forKey: KEY_USER_TOKEN), isRegistrationComplete {
            self.showProgressHUD()
            self.videoDetailDM.videoDisLike { (dict, errorMessage) in
                self.hideProgressHUD()
                if let countDict = dict {
                    if let unlikeCount = countDict["unlike_count"]?.intValue {
                        self.lblDislikeCount.text = "\(String(describing: unlikeCount))"
                    }
                    if let likeCount = countDict["like_count"]?.intValue {
                        self.lblLikeCount.text = "\(String(describing:likeCount))"
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
    
    func changeNextVideo(video: SPVideoDetail) {
        self.videoDetail = video
        self.videoDetail.totalViews += 1
        self.videoDetailDM.videoDetail = self.videoDetail
        self.fetchSuggestedVideos()
        self.updateUI()
        self.increaseViewCount()
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
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = self.videoDetailDM.suggestedVideos![indexPath.row]
        self.changeNextVideo(video: video)
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

extension SPVideoDetailViewController : BMPlayerDelegate {
    func bmPlayer(player: BMPlayer ,playerStateDidChange state: BMPlayerState) {
        print("playerStateDidChange")
        if state == .playedToTheEnd {
            if let video = self.videoDetailDM.suggestedVideos?.first {
                self.changeNextVideo(video: video)
            }
        }
    }
    
    func bmPlayer(player: BMPlayer ,loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval)  {
//        print("loadedTimeDidChange")
    }
    
    func bmPlayer(player: BMPlayer ,playTimeDidChange currentTime : TimeInterval, totalTime: TimeInterval)  {
//        print("playTimeDidChange")
    }
    
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
//        print("playerIsPlaying")
    }
    
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        if isFullscreen {
            self.playerHeightConstraint.constant = self.view.frame.size.height + 20
            UIApplication.shared.statusBarUIView?.isHidden = true
        } else {
            self.playerHeightConstraint.constant = 250
        }
    }
}
