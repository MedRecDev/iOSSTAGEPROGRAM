//
//  UserDataManager.swift
//  StageProgram
//
//  Created by RajeevSingh on 20/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserDataManager: NSObject {
    static let shared = UserDataManager()
    
    private override init() {
        //  Private init
    }
    
    func createToken(completion:@escaping (Bool, String?) -> Void) {
        NetworkAdapter().createToken(username: "appdefaultuser", password: "?28uR3&p@5kh+JBC", grantType: "password", clientId: "9a85bff3-40dd-45f5-8e51-7921cea126aa") { (accessToken, errorMessage) in
            if let _ = accessToken {
                completion(true, errorMessage)
            } else {
                completion(false, errorMessage)
            }
        }
    }
}
