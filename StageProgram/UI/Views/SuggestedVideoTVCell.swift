//
//  SuggestedVideoTVCell.swift
//  StageProgram
//
//  Created by RajeevSingh on 24/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class SuggestedVideoTVCell: UITableViewCell {

    @IBOutlet weak var lblViewDateTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgvThumbnail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(videoDetail: SPVideoDetail) {
        self.imgvThumbnail.sd_setImage(with: URL(string: videoDetail.mainThumbnailUrl)) { (image, error, cacheType, url) in
            self.imgvThumbnail.image = image
        }
        self.lblTitle.text = videoDetail.videoTitle
        self.lblDescription.text = videoDetail.videoDescription
        var viewCount : String = "\(videoDetail.totalViews ?? 0) views"
        if let date = videoDetail.createdDate {//2020-04-11T05:48:45
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            if let dateString = dateFormat.date(from: date) {
                viewCount = "\(videoDetail.totalViews ?? 0) views \(dateString.timeAgoDisplay())"
            }
        }
        self.lblViewDateTime.text = viewCount
    }
}
