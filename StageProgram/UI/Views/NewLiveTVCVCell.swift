//
//  NewLiveTVCVCell.swift
//  StageProgram
//
//  Created by RajeevSingh on 06/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import SDWebImage

class NewLiveTVCVCell: UICollectionViewCell {
    
    @IBOutlet weak var imgvNews: UIImageView!
    @IBOutlet weak var lblChannelName: UILabel!
    @IBOutlet weak var outerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.outerView.layer.cornerRadius = 5.0
        self.outerView.layer.borderWidth = 1.0
        self.outerView.layer.borderColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).cgColor
    }
    
    func updateUI(newsChannel : SPNewsChannel) {
        self.imgvNews.sd_setImage(with: URL(string: newsChannel.newsThumbUrl), placeholderImage: UIImage(named: "placeholder_square"), options: []) { (image, error, cacheType, url) in
            self.imgvNews.image = image
        }
        self.lblChannelName.text = newsChannel.newsChannelName
    }
}
