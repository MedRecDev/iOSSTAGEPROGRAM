//
//  VideoListCRView.swift
//  StageProgram
//
//  Created by RajeevSingh on 14/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

protocol VideoListCRViewDelegate {
    func didTapSupplementaryViewWith(videoDetail: SPVideoDetail)
}

class VideoListCRView: UICollectionReusableView {

    @IBOutlet weak var imgvThumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblViewsCount: UILabel!
    
    var videoDetail: SPVideoDetail?
    var delegate: VideoListCRViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(videoDetail: SPVideoDetail) {
        self.videoDetail = videoDetail
        self.imgvThumbnail.sd_setImage(with: URL(string: videoDetail.standardThumbnailUrl), placeholderImage: UIImage(named: "placeholder_rectangle"), options: []) { (image, error, cacheType, url) in
            self.imgvThumbnail.image = image
        }
        self.lblTitle.text = videoDetail.videoTitle
        self.lblDescription.text = videoDetail.videoDescription
        self.lblViewsCount.text = "\(videoDetail.totalViews ?? 0)"
    }
    
    @IBAction func selectVideoFromHeaderView(_ sender: Any) {
        if let video = self.videoDetail {
            self.delegate?.didTapSupplementaryViewWith(videoDetail: video)
        }
    }
}
