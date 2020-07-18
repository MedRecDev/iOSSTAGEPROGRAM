//
//  SPClipVideoListViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 17/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class SPClipVideoListViewController: SPBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var clipDataManager: ClipsDataManager!
    let columnLayout = CustomClipFeedFlowlayout(
        cellsPerRow: 2,
        minimumInteritemSpacing: 0  ,
        minimumLineSpacing: 0,
        sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.isHidden = true
        self.collectionView.collectionViewLayout = columnLayout
        self.collectionView.contentInsetAdjustmentBehavior = .always
        self.collectionView.register(UINib(nibName: "SPClipFeedCVCell", bundle: nil), forCellWithReuseIdentifier: "SPClipFeedCVCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let index = self.clipDataManager.indexForSelectedFeed() {
            self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .top, animated: false)
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension SPClipVideoListViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.clipDataManager.clipFeeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPClipFeedCVCell", for: indexPath) as! SPClipFeedCVCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let lastCell = cell as? SPClipFeedCVCell {
            NSLog(">>>>>>>>>>>>>> Displayed IndexPath Row : \(indexPath.row)")
            let clip = self.clipDataManager.clipFeeds[indexPath.row]
            lastCell.playVideo(clipFeed: clip)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let lastCell = cell as? SPClipFeedCVCell {
            NSLog("<<<<<<<<<<<<<<< Removed IndexPath Row : \(indexPath.row)")
            lastCell.pause()
        }
    }
}
