//
//  VideoDataManager.swift
//  StageProgram
//
//  Created by RajeevSingh on 22/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class VideoDataManager: NSObject {
    
    var pageNumber: Int = 0
    var pageSize: Int = 15
    var stateId : Int = 0
    var hasMoreList : Bool = true
    var videos : [SPVideoDetail]?
    
    func fetchVideoList(completion:@escaping (Bool, String?) -> Void) {
        NetworkAdapter().fetchVideoList(pageNumber: pageNumber, pageSize: pageSize, stateId: stateId) { (videoList, errorMessage) in
            if let videoList = videoList {
                self.videos = videoList
                completion(true, nil)
            } else {
                completion(false, errorMessage)
            }
        }
    }
}
