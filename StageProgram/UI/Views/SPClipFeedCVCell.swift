//
//  SPClipFeedCVCell.swift
//  StageProgram
//
//  Created by RajeevSingh on 17/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import AVFoundation

protocol SPClipFeedCVCellDelegate {
    func sendLikeEvent(clipFeed: SPClipFeed, isLiked:Bool)
    func sendShareEvent(clipFeed: SPClipFeed)
    func sendCommentEvent(clipFeed: SPClipFeed)
    func sendReportEvent(clipFeed: SPClipFeed)
}

class SPClipFeedCVCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblUserId: UILabel!
    @IBOutlet weak var lblViewCount: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblCommentsCount: UILabel!
    @IBOutlet weak var lblShareCount: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    
    var player: AVPlayer?
    var playerItem: AVPlayerItem!
    var playerLayer: AVPlayerLayer!
    var clipFeed: SPClipFeed?
    var delegate: SPClipFeedCVCellDelegate?
    var isLiked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func playVideo(clipFeed: SPClipFeed) {
        self.clipFeed = clipFeed
        if let urlString = clipFeed.mediaUrl, let url = URL(string: urlString) {
            NotificationCenter.default.removeObserver(self)
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            self.playerItem = AVPlayerItem(url: url)
            self.player = AVPlayer(playerItem: self.playerItem)
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.layer.addSublayer(self.playerLayer)
            self.playerLayer.videoGravity = .resizeAspect
            self.playerLayer.frame = CGRect(x: 0, y: 0, width: self.layer.frame.size.width, height: self.layer.frame.size.height)
            self.player?.play()
            
            if let title = clipFeed.feedTitle {
                self.lblTitle.text = title
            } else {
                self.lblTitle.text = ""
            }
            self.lblDescription.text = clipFeed.feedDescription
            self.lblDescription.text = "@userid"
            if let views = clipFeed.totalViews {
                self.lblViewCount.text = "\(views)"
            } else {
                self.lblViewCount.text = "0"
            }
            if let likes = clipFeed.totalLike {
                self.lblLikeCount.text = "\(likes)"
            } else {
                self.lblLikeCount.text = "0"
            }
            self.lblShareCount.text = "0"
            self.lblCommentsCount.text = "0"
        }
    }
    
    func pause() {
        self.player?.pause()
        self.player = nil
        self.playerLayer.removeFromSuperlayer()
    }
    
    @objc func playerDidFinishPlaying() {
        self.player?.seek(to: CMTime.zero)
        self.player?.play()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.playerLayer.removeFromSuperlayer()
    }
    
    @IBAction func btnLikeTapped(_ sender: Any) {
        if let feed = self.clipFeed {
            self.delegate?.sendLikeEvent(clipFeed: feed, isLiked: !isLiked)
        }
    }
    
    @IBAction func btnShareTapped(_ sender: Any) {
        if let feed = self.clipFeed {
            self.delegate?.sendShareEvent(clipFeed: feed)
        }
    }
    
    @IBAction func btnCommentTapped(_ sender: Any) {
        if let feed = self.clipFeed {
            self.delegate?.sendCommentEvent(clipFeed: feed)
        }
    }
    
    @IBAction func btnReportTapped(_ sender: Any) {
        if let feed = self.clipFeed {
            self.delegate?.sendReportEvent(clipFeed: feed)
        }
    }
}
