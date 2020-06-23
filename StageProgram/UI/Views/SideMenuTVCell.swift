//
//  SideMenuTVCell.swift
//  StageProgram
//
//  Created by RajeevSingh on 23/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class SideMenuTVCell: UITableViewCell {
    
    @IBOutlet weak var imgvLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(imageName: String, title: String) {
        self.imgvLogo.image = UIImage(named: imageName)
        self.lblTitle.text = title
    }
}
