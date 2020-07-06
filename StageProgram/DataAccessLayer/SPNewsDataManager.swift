//
//  SPNewsDataManager.swift
//  StageProgram
//
//  Created by RajeevSingh on 06/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class SPNewsDataManager : NSObject {
    static let shared = SPNewsDataManager()
    
    var newsStates : [SPNewsStates]?
    var newsChannels : [SPNewsChannel]?
    var pageNumber : Int = 0
    var pageSize : Int = 100
    var stateId : Int = 0
    private override init() {
        //  Private init
    }
    
    func fetchNewsStates(completion:@escaping (Bool, String?) -> Void) {
        NetworkAdapter().fetchNewsState { (newsStates, errorMessage) in
            if let newsStatesList = newsStates {
                self.newsStates = newsStatesList
                completion(true, nil)
            } else {
                completion(false, errorMessage)
            }
        }
    }
    
    func fetchNewsChannels(completion:@escaping (Bool, String?) -> Void) {
        NetworkAdapter().fetchNewsChannels { (newsChannels, errorMessage) in
            if let newsChannelList = newsChannels {
                self.newsChannels = newsChannelList
                completion(true, nil)
            } else {
                completion(false, errorMessage)
            }
        }
    }
}
