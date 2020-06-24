//
//  SPVideoDetailViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 24/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import VersaPlayer

class SPVideoDetailViewController: SPBaseViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor(red: 164/255, green: 0, blue: 29/255, alpha: 1.0)
        self.navigationController?.navigationBar.isHidden = true
        
        self.tableView.register(UINib(nibName: "SuggestedVideoTVCell", bundle: nil), forCellReuseIdentifier: "SuggestedVideoTVCell")
        
        self.videoDetailDM.videoDetail = self.videoDetail
        self.fetchSuggestedVideos()
        self.updateUI()
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
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: IBActions
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func likeTapped(_ sender: Any) {
        
    }
    
    @IBAction func dislikeTapped(_ sender: Any) {
        
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        
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
}
