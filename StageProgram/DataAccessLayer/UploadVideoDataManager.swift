//
//  UploadVideoDataManager.swift
//  StageProgram
//
//  Created by RajeevSingh on 02/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import Foundation

class UploadVideoDataManager: NSObject {
    
    func uploadVideo(videoTitle: String, videoDescription: String, stateId: Int, videoFilePath: String, completion:@escaping (String?, String?) -> Void) {
        var token = ""
        if let uToken = UserDataManager.shared.currentUser?.userToken {
            token = uToken
        } else if let uToken = UserDefaults.standard.value(forKey: KEY_USER_TOKEN) as? String {
            token = uToken
        }
        NetworkAdapter().uploadVideo(userToken: token, videoTitle: videoTitle, videoDescription: videoDescription, stateId: stateId, videoFilePath: videoFilePath) { (successMsg, errorMsg) in
            completion(successMsg, errorMsg)
        }
    }
}
