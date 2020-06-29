//
//  VideoDataManager.swift
//  StageProgram
//
//  Created by RajeevSingh on 22/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.r
//

import UIKit

class VideoDataManager: NSObject {
    
    var pageNumber: Int = -1
    var pageSize: Int = 15
    var stateId : Int = 0
    var hasMoreList : Bool = true
    var videos : [SPVideoDetail] = []
    
    func fetchVideoList(completion:@escaping (Bool, String?) -> Void) {
        if !self.hasMoreList {
            return
        }
        self.pageNumber += 1
        NetworkAdapter().fetchVideoList(pageNumber: pageNumber, pageSize: pageSize, stateId: stateId) { (videoList, errorMessage) in
            if let videoList = videoList {
                self.videos.append(contentsOf: videoList)
                if videoList.count < self.pageSize {
                    self.hasMoreList = false
                }
                completion(true, nil)
            } else {
                completion(false, errorMessage)
            }
        }
    }
}
