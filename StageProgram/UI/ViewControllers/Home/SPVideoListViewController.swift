//
//  SPVideoListViewController.swift
//  StageProgram
//
//  Created by Rohit Sharma on 20/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import FirebaseAnalytics

protocol VideoListControllerDelegate {
    func videoTapped(video: SPVideoDetail)
}

class SPVideoListViewController: SPBaseViewController, UICollectionViewDelegateFlowLayout, VideoListCRViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
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
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.videoManager.stateId = state!.stateId
        self.fetchVideoList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let stateName = state?.stateName {
            Analytics.setScreenName(stateName   , screenClass: "SPVideoListViewController")
        }
        self.collectionView.reloadData()
    }
    
    func setUpUI() {
        let nib = UINib(nibName: "VideoListCRView", bundle: nil)
        self.collectionView.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "VideoListCRView")
        self.collectionView.register(UINib(nibName: "VideoCVCell", bundle: nil), forCellWithReuseIdentifier: "VideoCVCell")
        self.collectionView.collectionViewLayout = columnLayout
        self.collectionView.contentInsetAdjustmentBehavior = .always
        
        self.refreshControl.tintColor = UIColor(hexString: "#971D24")
        self.refreshControl.addTarget(self, action: #selector(refreshVideoList), for: .valueChanged)
        self.collectionView.addSubview(self.refreshControl)
    }
        
    func fetchVideoList() {
        self.showProgressHUD()
        self.videoManager.fetchVideoList(completion: { (success, errorMessage) in
            self.hideProgressHUD()
            self.refreshControl.endRefreshing()
            if success {
                self.collectionView.reloadData()
                print("Success in Video list fetch")
            } else {
                print(errorMessage!)
            }
        })
    }
    
    @objc func refreshVideoList() {
        self.videoManager.hasMoreList = true
        self.videoManager.pageNumber = -1
        self.fetchVideoList()
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true;
            self.videoManager.fetchVideoList(completion: { (success, errorMessage) in
                if success {
                    self.collectionView.reloadData()
                    self.isLoading = false
                }
            })
        }
    }
    
    //MARK: IBActions
    func didTapSupplementaryViewWith(videoDetail: SPVideoDetail) {
        if self.state?.stateId == 0 {
            self.delegate?.videoTapped(video: videoDetail)
        }
    }
}

extension SPVideoListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let state = self.state, let stateId = state.stateId, stateId == 0 {
            return CGSize(width: collectionView.frame.size.width, height: 220.0)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "VideoListCRView", for: indexPath) as! VideoListCRView
        if let videoDetail = self.videoManager.videos.first, self.state?.stateId == 0 {
            reusableView.updateUI(videoDetail: videoDetail)
            reusableView.delegate = self
        }
        return reusableView
    }
    
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
