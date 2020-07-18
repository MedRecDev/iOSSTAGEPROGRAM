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
    
    func indexForSelectedFeed() -> Int? {
        guard let _ = selectedFeed else {
            return nil
        }
        let index = self.clipFeeds.firstIndex { (clip) -> Bool in
            return clip.feedSourceId == selectedFeed!.feedSourceId
        }
        return index
    }
}
