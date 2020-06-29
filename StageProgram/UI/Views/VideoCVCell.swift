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
    @IBOutlet weak var gradientView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.gradientView.setGradientBackground(topColor: UIColor(red: 164/255, green: 0, blue: 29/255, alpha: 0.55), bottomColor: UIColor(red: 82/255, green: 0, blue: 15/255, alpha: 0.55))
    }
    
    func updateUI(video: SPVideoDetail?) {
        if let videoDetail = video {
            self.imgvThmbnail.sd_setImage(with: URL(string: videoDetail.mainThumbnailUrl), placeholderImage: UIImage(named: "placeholder_square"), options: []) { (image, error, cacheType, url) in
                self.imgvThmbnail.image = image
            }
            self.lblTitle.text = videoDetail.videoTitle
            self.lblViewCount.text = "Views   \(videoDetail.totalViews ?? 0)"
        }
    }
}
