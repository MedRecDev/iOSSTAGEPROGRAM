//
//  HomeViewController.swift
//  StageProgram
//
//  Created by Rohit Sharma on 11/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import Parchment

class SPHomeViewController: SPBaseViewController {

    var pagingViewController : PagingViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "STAGE PROGRAM"
        self.handleLeftBarButtonItem(leftButtonType: .Menu)
        self.handleRightBarButtonItem(rightButtonTypes: [.Profile, .Upload])
        self.fetchStateList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let videoDetailVC = segue.destination as? SPVideoDetailViewController, let videoDetail = sender as? SPVideoDetail  {
            videoDetailVC.videoDetail = videoDetail
        }
    }
    
    func fetchStateList() {
        self.showProgressHUD()
        StatesDataManager.shared.fetchStateList { (succsess, errorMessage) in
            self.hideProgressHUD()
            if succsess {
                self.setUpHorizontalMenu()
            } else {
                self.showAlert(withMessage: "Error occured while fetching states list")
            }
        }
    }
    
    func setUpHorizontalMenu() {
        self.pagingViewController = PagingViewController()
        self.pagingViewController?.dataSource = self
        self.pagingViewController?.menuItemSize = .selfSizing(estimatedWidth: 100, height: 40)
        self.pagingViewController?.backgroundColor = UIColor(red: 164/255, green: 0, blue: 29/255, alpha: 1.0)
        self.pagingViewController?.selectedBackgroundColor = UIColor(red: 164/255, green: 0, blue: 29/255, alpha: 1.0)
        self.pagingViewController?.indicatorColor = UIColor(red: 238/255, green: 102/255, blue: 61/255, alpha: 1.0)
        self.pagingViewController?.textColor = UIColor.white
        self.pagingViewController?.selectedTextColor = UIColor.white
        self.pagingViewController?.font = UIFont(name: "Montserrat-SemiBold", size: 14.0)!
        self.pagingViewController?.selectedFont = UIFont(name: "Montserrat-SemiBold", size: 14.0)!

        self.addChild(self.pagingViewController!)
        self.view.addSubview(self.pagingViewController!.view)
        self.pagingViewController?.view.layout.pinHorizontalEdgesToSuperView()
        self.pagingViewController?.view.layout.pinVerticalEdgesToSuperView()
        self.pagingViewController!.didMove(toParent: self)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
}

extension SPHomeViewController : PagingViewControllerDataSource {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        if let states = StatesDataManager.shared.states {
            return states.count
        }
        return 0
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let state = StatesDataManager.shared.states![index]
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let videoListController = storyboard.instantiateViewController(withIdentifier: "VideoListViewController") as! SPVideoListViewController
        videoListController.state = state
        videoListController.delegate = self
        return videoListController
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        let state = StatesDataManager.shared.states![index]
        return PagingIndexItem(index: index, title: state.stateName.uppercased())
    }
}

extension SPHomeViewController : VideoListControllerDelegate {
    func videoTapped(video: SPVideoDetail) {
        print("Video Tapped with id : \(video.videoSourceId ?? 0)")
        self.performSegue(withIdentifier: "showVideoDetailSceneSegue", sender: video)
    }
}
