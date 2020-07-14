//
//  NewsListViewController.swift
//  StageProgram
//
//  Created by RajeevSingh on 06/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class NewsListViewController: SPBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleLeftBarButtonItem(leftButtonType: .Menu)
        self.handleRightBarButtonItem(rightButtonTypes: [.Profile])
        self.tableView.register(UINib(nibName: "NewsChannelsTVCell", bundle: nil), forCellReuseIdentifier: "NewsChannelsTVCell")
        self.tableView.separatorStyle = .none
        self.fetchNewsStates()
        self.title = "NEWS CHANNELS"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? YoutubePlayerViewController {
            dest.channel = sender as? SPNewsChannel
        }
    }
    
    func fetchNewsStates() {
        self.showProgressHUD()
        SPNewsDataManager.shared.fetchNewsStates { (success, statesErrorMessage) in
            if success {
                SPNewsDataManager.shared.fetchNewsChannels { (success, channelsErrorMessage) in
                    self.hideProgressHUD()
                    if success {
                        self.tableView.reloadData()
                    } else if let errorMsg = channelsErrorMessage {
                        self.showAlert(withMessage: errorMsg)
                    }
                }
            } else if let errorMsg = statesErrorMessage {
                self.hideProgressHUD()
                self.showAlert(withMessage: errorMsg)
            }
        }
    }
}

extension NewsListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let newsStates = SPNewsDataManager.shared.newsStates {
            return newsStates.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsChannelsTVCell", for: indexPath) as! NewsChannelsTVCell
        let newsState = SPNewsDataManager.shared.newsStates![indexPath.row]
        let channels = self.fetchNewsChannels(for: newsState.newsStateId)
        cell.updateUI(state: newsState, channels: channels)
        cell.delegate = self
        return cell
    }
}

extension NewsListViewController {
    func fetchNewsChannels(for stateId: Int) -> [SPNewsChannel] {
        let channels = SPNewsDataManager.shared.newsChannels?.filter({ (newsChannel) -> Bool in
            return newsChannel.newsStateId == stateId
        })
        return channels!
    }
}

extension NewsListViewController : NewsChannelCellDelegate {
    func newsChannelSelected(newsChannel: SPNewsChannel) {
//        YoutubePlayerViewController
//        let
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let youtubeVC = storyboard.instantiateViewController(withIdentifier: "YoutubePlayerViewController") as! YoutubePlayerViewController
        youtubeVC.channel = newsChannel
        let navController = UINavigationController(rootViewController: youtubeVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
//        self.performSegue(withIdentifier: "showYoutubePlayerVideoScene", sender: newsChannel)
    }
}
