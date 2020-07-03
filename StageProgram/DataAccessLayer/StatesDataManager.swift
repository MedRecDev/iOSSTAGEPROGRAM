//
//  GlobalDataManager.swift
//  StageProgram
//
//  Created by RajeevSingh on 22/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON

class StatesDataManager: NSObject {
    static let shared = StatesDataManager()
    
    var states : [SPState]?
    var pageNumber : Int = 0
    var pageSize : Int = 100
    var stateId : Int = 0
    private override init() {
        //  Private init
    }
    
    func fetchStateList(completion:@escaping (Bool, String?) -> Void) {
        NetworkAdapter().fetchStateList(pageNumber: pageNumber, stateId: stateId, pageSize: pageSize) { (stateList, errorMessage) in
            if let statesList = stateList {
                self.states = statesList
                completion(true, nil)
            } else {
                completion(false, errorMessage)
            }
        }
    }
}
