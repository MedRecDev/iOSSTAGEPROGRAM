//
//  VideoSuggestionsDataManager.swift
//  StageProgram
//
//  Created by RajeevSingh on 24/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

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
    
    func videoLike(completion:@escaping (Int?, String?) -> Void) {
        let videoId : Int = self.videoDetail.videoSourceId
        if let userToken = UserDataManager.shared.currentUser?.userToken {
            NetworkAdapter().videoLike(videoId: videoId, userToken: userToken) { (likeCount, errorMessage) in
                completion(likeCount, errorMessage)
            }
        }
    }
    
    func videoDisLike(completion:@escaping (Int?, String?) -> Void) {
        let videoId : Int = self.videoDetail.videoSourceId
        if let userToken = UserDataManager.shared.currentUser?.userToken {
            NetworkAdapter().videoUnLike(videoId: videoId, userToken: userToken) { (unlikeCount, errorMessage) in
                completion(unlikeCount, errorMessage)
            }
        }
    }
    
    func increaseVideoViews(completion: @escaping (Bool, String?) -> Void) {
        let videoId : Int = self.videoDetail.videoSourceId
        NetworkAdapter().increaseVideoViews(videoId: videoId) { (success, errorMessage) in
            completion(success, errorMessage)
        }
    }
}
