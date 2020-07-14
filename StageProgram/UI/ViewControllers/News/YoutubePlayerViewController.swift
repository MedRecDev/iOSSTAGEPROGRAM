//
//  YoutubePlayerViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 06/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import YouTubePlayer

class YoutubePlayerViewController: SPBaseViewController {

    @IBOutlet weak var youtubePlayer: YouTubePlayerView!
    @IBOutlet weak var playButton: UIButton!
    
    var channel : SPNewsChannel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youtubePlayer.playerVars = [
            "playsinline": "1",
            "controls": "1",
            "showinfo": "0"
            ] as YouTubePlayerView.YouTubePlayerParameters
        if let channel = self.channel {
            youtubePlayer.loadVideoURL(URL(string: channel.newsFeedUrl)!)
        }
        youtubePlayer.delegate = self
        self.playButton.isHidden = true
        self.handleLeftBarButtonItem(leftButtonType: .WhiteBack)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = channel?.newsChannelName
        
        UIApplication.shared.statusBarUIView?.isHidden = true
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        youtubePlayer.pause()
    }

    @IBAction func btnPlayTapped(_ sender: Any) {
        if youtubePlayer.ready {
            if youtubePlayer.playerState != YouTubePlayerState.Playing {
                youtubePlayer.play()
                playButton.setImage(UIImage(named: "pause_icon"), for: .normal)
            } else {
                youtubePlayer.pause()
                playButton.setImage(UIImage(named: "play_icon"), for: .normal)
            }
        }
    }
}

extension YoutubePlayerViewController : YouTubePlayerDelegate {
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        if playerState == .Ended {
//            self.playerHeightConstraint.constant = self.view.frame.size.height + 20
//            UIApplication.shared.statusBarUIView?.isHidden = true
        }
    }
}
