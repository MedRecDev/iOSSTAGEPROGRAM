//
//  SPClipFeedCVCell.swift
//  StageProgram
//
//  Created by RajeevSingh on 17/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import AVFoundation

class SPClipFeedCVCell: UICollectionViewCell {

    var player: AVPlayer?
    var playerItem: AVPlayerItem!
    var playerLayer: AVPlayerLayer!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func playVideo(clipFeed: SPClipFeed) {
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
}
