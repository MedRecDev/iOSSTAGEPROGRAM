//
//  ClipsDataManager.swift
//  StageProgram
//
//  Created by RajeevSingh on 16/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON

class ClipsDataManager: NSObject {
    
    var pageSize: Int = 15
    var pageNumber: Int = -1
    var hasMoreList : Bool = true
    var clipFeeds: [SPClipFeed] = []
    var selectedFeed: SPClipFeed?
    
    func fetchClipFeeds(completion:@escaping (Bool, String?) -> Void) {
        if !self.hasMoreList {
            return
        }
        self.pageNumber += 1
        NetworkAdapter().fetchClipFeeds(pageSize: pageSize, pageNumber: pageNumber) { (_clipFeeds, errorMessage) in
            if let clips = _clipFeeds {
                self.clipFeeds.append(contentsOf: clips)
                if clips.count < self.pageSize {
                    self.hasMoreList = false
                }
                completion(true, nil)
            } else {
                completion(false, errorMessage)
            }
        }
    }
    
    func increaseViewCountForClip(clip: SPClipFeed) {
        NetworkAdapter().increaseViewCountForClip(feedSourceId: clip.feedSourceId) { (success, message) in
            print("Video count increased")
        }
    }
    
    func feedLike(clip: SPClipFeed, completion:@escaping ([String:JSON]?, String?) -> Void) {
        let feedSourceId : Int = clip.feedSourceId
        var token = ""
        if let uToken = UserDataManager.shared.currentUser?.userToken {
            token = uToken
        } else if let uToken = UserDefaults.standard.value(forKey: KEY_USER_TOKEN) as? String {
            token = uToken
        }
        NetworkAdapter().feedLike(feedSourceId: feedSourceId, userToken: token) { (likeDict, errorMessage) in
            completion(likeDict, errorMessage)
        }
    }
    
    func reportFeedSpam(clip: SPClipFeed, reason: String, completion: @escaping (String?, String?) -> Void) {
        let feedSourceId : Int = clip.feedSourceId
        var token = ""
        if let uToken = UserDataManager.shared.currentUser?.userToken {
            token = uToken
        } else if let uToken = UserDefaults.standard.value(forKey: KEY_USER_TOKEN) as? String {
            token = uToken
        }
        NetworkAdapter().reportFeedSpam(feedSourceId: feedSourceId, userToken: token, reason: reason) { (success, errorMsg) in
            completion(success, errorMsg)
        }
    }
}

extension ClipsDataManager {
    func indexForSelectedFeed() -> Int? {
        guard let _ = selectedFeed else {
            return nil
        }
        let index = self.clipFeeds.firstIndex { (clip) -> Bool in
            return clip.feedSourceId == selectedFeed!.feedSourceId
        }
        return index
    }
    
    func updateLikeCount(likes: Int, unlikes: Int, feedSourceId: Int, completion: @escaping (Int) -> Void) {
        if let feed: SPClipFeed = self.clipFeeds.filter({ (feed) -> Bool in
            return feed.feedSourceId == feedSourceId
        }).first {
            if likes == 1 {
                feed.totalLike += 1
            } else if feed.totalLike > 0 {
                feed.totalLike -= 1
            }
            if unlikes == 1 {
                feed.totalDislike += 1
            } else if feed.totalDislike > 0 {
                feed.totalDislike -= 1
            }
            completion(feed.totalLike)
        }
    }
    
    func updateViewCounts(feedSourceId: Int) {
        if let feed: SPClipFeed = self.clipFeeds.filter({ (feed) -> Bool in
            return feed.feedSourceId == feedSourceId
        }).first {
            feed.totalViews += 1
        }
    }
}
