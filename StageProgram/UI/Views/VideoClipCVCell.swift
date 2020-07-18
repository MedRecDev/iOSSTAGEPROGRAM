//
//  VideoClipCVCell.swift
//  StageProgram
//
//  Created by RajeevSingh on 17/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import SDWebImage

class VideoClipCVCell: UICollectionViewCell {

    @IBOutlet weak var gradientView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgvVideo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
//        self.contentView.layer.borderColor = UIColor(red: 164/255, green: 0, blue: 29/255, alpha: 1.0).cgColor
//        self.contentView.layer.borderWidth = 1.0
//        self.gradientView.backgroundColor = UIColor.red
        self.gradientView.setGradientBackground(topColor: UIColor(red: 164/255, green: 0, blue: 29/255, alpha: 0.30), bottomColor: UIColor(red: 164/255, green: 0, blue: 29/255, alpha: 1.0))
    }

    func updateUI(videoClip: SPClipFeed) {
        self.imgvVideo.sd_setImage(with: URL(string: videoClip.standardThumbnailUrl), placeholderImage: UIImage(named: "placeholder_square"), options: []) { (image, error, cacheType, url) in
            self.imgvVideo.image = image
            self.imgvVideo.contentMode = .scaleAspectFill
        }
        self.lblTitle.text = videoClip.feedDescription
    }
    
}
