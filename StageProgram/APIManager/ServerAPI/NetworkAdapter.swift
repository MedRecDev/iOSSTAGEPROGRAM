//
//  NetworkAdapter.swift
//  AppTutor
//
//  Created by Rohit Sharma on 11/07/19.
//  Copyright © 2019 Vismedia Agency. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON

var authToken :String? {
    get {
        return UserDefaults.standard.string(forKey: KEY_LOGIN_TOKEN)
    }
    set {
        if newValue == nil {
            UserDefaults.standard.removeObject(forKey: KEY_LOGIN_TOKEN)
        } else {
            UserDefaults.standard.set(newValue, forKey: KEY_LOGIN_TOKEN)
        }
        UserDefaults.standard.synchronize()
    }
}

// MARK: Common APIs
class NetworkAdapter {
    
    fileprivate var provider = MoyaProvider<AppTutorService>(plugins: [NetworkLoggerPlugin(), AccessTokenPlugin(tokenClosure: { (authType) -> String in
        return authToken ?? ""
    })])
    
    func createToken(username: String, password: String, grantType: String, clientId: String, completion: @escaping (_ response: String?, _ errorMessage: String?) -> Void) {
        self.provider.request(.TokenCreate(username: username, password: password, client_id: clientId, grantType: grantType)) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                do {
                    let responseJson = try JSON(data: data)
                    defaults.setValue(responseJson["data"]["access_token"].stringValue, forKey: KEY_LOGIN_TOKEN)
                    defaults.setValue(responseJson["data"]["refresh_token"].stringValue, forKey: KEY_LOGIN_REFRESH_TOKEN)
                    completion(authToken, nil)
                } catch {
                    completion(nil, "Error occured while fetching access token")
                }
            case .failure(let error):
                completion(nil, "Error occured while fetching access token")
            }
        }
    }
}
