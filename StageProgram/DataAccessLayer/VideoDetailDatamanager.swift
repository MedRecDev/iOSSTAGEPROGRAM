//
//  VideoSuggestionsDataManager.swift
//  StageProgram
//
//  Created by RajeevSingh on 24/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class VideoDetailDataManager: NSObject {
    
    var videoDetail : SPVideoDetail!
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
}
