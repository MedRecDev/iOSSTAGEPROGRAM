//
//  SPVideoListViewController.swift
//  StageProgram
//
//  Created by Rohit Sharma on 20/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

protocol VideoListControllerDelegate {
    func videoTapped(video: SPVideoDetail)
}

class SPVideoListViewController: SPBaseViewController {

    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgvThumbnail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblViewsCount: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    var state: SPState?
    var videoManager : VideoDataManager = VideoDataManager()
    var delegate : VideoListControllerDelegate?
    var isLoading : Bool = false
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 2,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.videoManager.stateId = state!.stateId
        self.fetchVideoList()
    }
    
    func setUpUI() {
        if let state = self.state, let stateId = state.stateId, stateId == 0 {
            self.topViewHeightConstraint.constant = 220
        } else {
            self.topViewHeightConstraint.constant = 0
        }
        self.collectionView.register(UINib(nibName: "VideoCVCell", bundle: nil), forCellWithReuseIdentifier: "VideoCVCell")
        self.collectionView.collectionViewLayout = columnLayout
        self.collectionView.contentInsetAdjustmentBehavior = .always
        self.gradientView.setGradientBackground(topColor: UIColor(red: 164/255, green: 0, blue: 29/255, alpha: 0.55), bottomColor: UIColor(red: 82/255, green: 0, blue: 15/255, alpha: 0.55))
    }
        
    func fetchVideoList() {
        self.showProgressHUD()
        self.videoManager.fetchVideoList(completion: { (success, errorMessage) in
            self.hideProgressHUD()
            if success {
                self.updateTopView()
                self.collectionView.reloadData()
                print("Success in Video list fetch")
            } else {
                print(errorMessage!)
            }
        })
    }
    
    func updateTopView() {
        if let videoDetail = self.videoManager.videos.first, self.state?.stateId == 0 {
            self.topView.isHidden = false
            self.imgvThumbnail.sd_setImage(with: URL(string: videoDetail.mainThumbnailUrl)) { (image, error, cacheType, url) in
                self.imgvThumbnail.image = image
            }
            self.lblTitle.text = videoDetail.videoTitle
            self.lblDescription.text = videoDetail.videoDescription
            self.lblViewsCount.text = "\(videoDetail.totalViews ?? 0)"
        }
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true;
            self.videoManager.fetchVideoList(completion: { (success, errorMessage) in
                if success {
                    self.updateTopView()
                    self.collectionView.reloadData()
                    self.isLoading = false
                }
            })
        }
    }
    
    //MARK: IBActions
    @IBAction func topViewTapped(_ sender: Any) {
        if let videoDetail = self.videoManager.videos.first, self.state?.stateId == 0 {
            self.delegate?.videoTapped(video: videoDetail)
        }
    }
    
}

extension SPVideoListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.state?.stateId != 0 {
            return self.videoManager.videos.count
        } else if self.state?.stateId == 0 {
            return self.videoManager.videos.count - 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCVCell", for: indexPath) as! VideoCVCell
        if self.state?.stateId == 0 {
            let videoDetail = self.videoManager.videos[indexPath.item + 1]
            cell.updateUI(video: videoDetail)
        } else {
            let videoDetail = self.videoManager.videos[indexPath.item]
            cell.updateUI(video: videoDetail)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var videoDetail : SPVideoDetail!
        if self.state?.stateId == 0 {
            videoDetail = self.videoManager.videos[indexPath.item + 1]
        } else {
            videoDetail = self.videoManager.videos[indexPath.item]
        }
        self.delegate?.videoTapped(video: videoDetail)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= self.videoManager.videos.count - 4 && !self.isLoading  {
            self.loadMoreData()
        }
    }
}

//extension SPVideoListViewController : UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//
//        if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading {
//            loadMoreData()
//        }
//    }
//}
