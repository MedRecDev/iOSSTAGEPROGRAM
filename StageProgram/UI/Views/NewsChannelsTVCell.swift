//
//  NewsChannelsTVCell.swift
//  StageProgram
//
//  Created by RajeevSingh on 06/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

protocol NewsChannelCellDelegate {
    func newsChannelSelected(newsChannel: SPNewsChannel)
}

class NewsChannelsTVCell: UITableViewCell {
    @IBOutlet weak var lblStateName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var newsState : SPNewsStates?
    var newsChannels : [SPNewsChannel]?
    var delegate : NewsChannelCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(UINib(nibName: "NewLiveTVCVCell", bundle: nil), forCellWithReuseIdentifier: "NewLiveTVCVCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(state: SPNewsStates, channels: [SPNewsChannel]) {
        self.newsState = state
        self.newsChannels = channels
        self.lblStateName.text = state.newsState
        self.collectionView.reloadData()
    }
}

extension NewsChannelsTVCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let channels = self.newsChannels {
            return channels.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewLiveTVCVCell", for: indexPath) as! NewLiveTVCVCell
        let newsChannel = self.newsChannels![indexPath.row];
        cell.updateUI(newsChannel: newsChannel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newsChannel = self.newsChannels![indexPath.row];
        self.delegate?.newsChannelSelected(newsChannel: newsChannel)
    }
}
