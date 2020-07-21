//
//  ClipsViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 16/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class ClipsViewController: SPBaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var clipsDataManager: ClipsDataManager = ClipsDataManager()
    var isLoading : Bool = false
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 2,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10),
        isForClipFeed: true
    )
    let cellsPerRow = 2
    let minimumLineSpacing: CGFloat = 20
    let minimumInteritemSpacing: CGFloat = 20
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleLeftBarButtonItem(leftButtonType: .Menu)
        self.handleRightBarButtonItem(rightButtonTypes: [.Profile, .Upload])
        self.navigationItem.title = "STAGE PROGRAM"
        self.collectionView.register(UINib(nibName: "VideoClipCVCell", bundle: nil), forCellWithReuseIdentifier: "VideoClipCVCell")
        self.collectionView.collectionViewLayout = columnLayout
        self.collectionView.contentInsetAdjustmentBehavior = .always
        self.fetchClipVideos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor(red: 164/255, green: 0, blue: 29/255, alpha: 1.0)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SPClipVideoListViewController {
            destination.clipDataManager = self.clipsDataManager
        }
    }
    
    func fetchClipVideos() {
        self.showProgressHUD()
        self.clipsDataManager.fetchClipFeeds { (success, message) in
            self.hideProgressHUD()
            if success {
                self.collectionView.reloadData()
            } else if let msg = message {
                self.showAlert(withMessage: msg)
            }
        }
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true;
            self.clipsDataManager.fetchClipFeeds(completion: { (success, errorMessage) in
                if success {
                    self.collectionView.reloadData()
                    self.isLoading = false
                }
            })
        }
    }
}

extension ClipsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let clipFeeds = self.clipsDataManager.clipFeeds
        return clipFeeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoClipCVCell", for: indexPath) as! VideoClipCVCell
        let videoDetail = self.clipsDataManager.clipFeeds[indexPath.item]
        cell.updateUI(videoClip: videoDetail)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= self.clipsDataManager.clipFeeds.count - 4 && !self.isLoading  {
            self.loadMoreData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feed = self.clipsDataManager.clipFeeds[indexPath.item]
        self.clipsDataManager.selectedFeed = feed
        self.performSegue(withIdentifier: "showClipFeedsScene", sender: feed)
        //TODO: Move on to next screen
    }
}
