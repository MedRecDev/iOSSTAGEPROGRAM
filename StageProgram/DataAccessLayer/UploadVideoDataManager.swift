//
//  UploadVideoDataManager.swift
//  StageProgram
//
//  Created by RajeevSingh on 02/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import Foundation

class UploadVideoDataManager: NSObject {
    
    func uploadVideo(videoTitle: String, videoDescription: String, stateId: Int, videoFilePath: Data, completion:@escaping (String?, String?) -> Void) {
        if let userToken = UserDataManager.shared.currentUser?.userToken {
            NetworkAdapter().uploadVideo(userToken: userToken, videoTitle: videoTitle, videoDescription: videoDescription, stateId: stateId, videoFilePath: videoFilePath) { (successMsg, errorMsg) in
                completion(successMsg, errorMsg)
            }
        }
    }
}
