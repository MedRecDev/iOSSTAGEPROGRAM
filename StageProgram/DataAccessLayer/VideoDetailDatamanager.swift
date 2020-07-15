//
//  VideoSuggestionsDataManager.swift
//  StageProgram
//
//  Created by RajeevSingh on 24/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON

class VideoDetailDataManager: NSObject {
    
    weak var videoDetail : SPVideoDetail!
    var suggestedVideos : [SPVideoDetail]?
    
    func fetchSuggestedVideos(completion:@escaping (Bool, String?) -> Void) {
        let videoId : Int = self.videoDetail.videoSourceId
        NetworkAdapter().fetchSuggestionsList(videoId: videoId) { (videoList, errorMessage) in
            if let videoList = videoList {
                self.suggestedVideos = videoList
                completion(true, nil)
            } else {
                completion(false, errorMessage)
            }
        }
    }
    
    func videoLike(completion:@escaping ([String:JSON]?, String?) -> Void) {
        let videoId : Int = self.videoDetail.videoSourceId
        var token = ""
        if let uToken = UserDataManager.shared.currentUser?.userToken {
            token = uToken
        } else if let uToken = UserDefaults.standard.value(forKey: KEY_USER_TOKEN) as? String {
            token = uToken
        }
        NetworkAdapter().videoLike(videoId: videoId, userToken: token) { (likeDict, errorMessage) in
            completion(likeDict, errorMessage)
        }
    }
    
    func videoDisLike(completion:@escaping ([String:JSON]?, String?) -> Void) {
        let videoId : Int = self.videoDetail.videoSourceId
        var token = ""
        if let uToken = UserDataManager.shared.currentUser?.userToken {
            token = uToken
        } else if let uToken = UserDefaults.standard.value(forKey: KEY_USER_TOKEN) as? String {
            token = uToken
        }
        NetworkAdapter().videoUnLike(videoId: videoId, userToken: token) { (unlikeDict, errorMessage) in
            completion(unlikeDict, errorMessage)
        }
    }
    
    func increaseVideoViews(completion: @escaping (Bool, String?) -> Void) {
        let videoId : Int = self.videoDetail.videoSourceId
        NetworkAdapter().increaseVideoViews(videoId: videoId) { (success, errorMessage) in
            completion(success, errorMessage)
        }
    }
}
