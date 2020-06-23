//
//  VideoCVCell.swift
//  StageProgram
//
//  Created by RajeevSingh on 22/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import SDWebImage

class VideoCVCell: UICollectionViewCell {

    @IBOutlet weak var imgvThmbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblViewCount: UILabel!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(video: SPVideoDetail?) {
        if let videoDetail = video {
            self.imgvThmbnail.sd_setImage(with: URL(string: videoDetail.mainThumbnailUrl)) { (image, error, cacheType, url) in
                self.imgvThmbnail.image = image
            }
            self.lblTitle.text = videoDetail.videoTitle
            self.lblViewCount.text = "Views \(videoDetail.totalViews ?? 0)"
        }
    }
}
