//
//  ServerProvider.swift
//  AppTutor
//
//  Created by Rohit Sharma on 11/07/19.
//  Copyright © 2019 Vismedia Agency. All rights reserved.
//

import Foundation
import Moya

enum AppTutorService {
    case TokenCreate(username: String, password: String, client_id: String, grantType : String)
    case StateList(page_number: Int, state_id: Int, page_size: Int)
    case VideoList(pageNumber: Int, stateId: Int, pageSize: Int)
    case SuggestionList(videoId: Int)
}

extension AppTutorService : TargetType, AccessTokenAuthorizable {    
    /// The target's base `URL`.
    var baseURL: URL {
        return URL(string: "https://stageprogram.com/api/")!
    }
    
    var path: String {
        switch self {
        //Post
        case .TokenCreate:
            return "token/create"
        case .StateList:
            return "state"
        case .VideoList:
            return "videos"
        case .SuggestionList:
            return "videos/suggestion"
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
        case .TokenCreate(let username, let password, let client_id, let grantType):
            return ["grant_type" : grantType, "username" : username, "password" : password, "client_id" : client_id]
        case .StateList(let pageNumber, let stateId, let pageSize):
            return ["page_number" : pageNumber, "state_id" : stateId, "page_size" : pageSize]
        case .VideoList(let pageNumber, let stateId, let pageSize):
            return ["page_number" : pageNumber, "state_id" : stateId, "page_size" : pageSize]
        case .SuggestionList(let videoId):
            return ["video_id": videoId]
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .TokenCreate:
            return .post
        case .StateList, .VideoList, .SuggestionList:
            return .get
        }
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        switch self {
            
        //Post API
        case  .TokenCreate:
            return .requestCompositeParameters(bodyParameters: self.parameters!,
                                               bodyEncoding: JSONEncoding.default,
                                               urlParameters: [:])
        case .StateList, .VideoList, .SuggestionList:
                return .requestParameters(parameters: self.parameters!, encoding: URLEncoding.queryString)
        //Get WithOut Parameters
        default :
            return .requestPlain
        }
    }
    
    /// The headers to be used in the request.
    var headers: [String: String]? {
        return [ "Content-Type" : "application/json"]
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return Data()
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .TokenCreate:
            return nil
        default:
            return .bearer
        }
    }
}
