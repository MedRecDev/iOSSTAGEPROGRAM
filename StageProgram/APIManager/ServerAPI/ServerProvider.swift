//
//  ServerProvider.swift
//  AppTutor
//
//  Created by Rohit Sharma on 11/07/19.
//  Copyright © 2019 Vismedia Agency. All rights reserved.
//

import Foundation
import Moya

enum GenderType : String {
    case Male = "M"
    case Female = "FM"
}

enum AppTutorService {
    case TokenCreate(username: String, password: String, client_id: String, grantType : String)
    case login(email:String, password: String)
    case sendOTP(phoneNo:String, dialingCode: String)
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
        case .login:
            return "auth/login"
        case .sendOTP:
            return "LogIn/SendOtp"
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
        case .TokenCreate(let username, let password, let client_id, let grantType):
            return ["grant_type" : grantType, "username" : username, "password" : password, "client_id" : client_id]
        case .login(let email, let password):
            return ["PhoneNo":email, "Otp":password]
        case .sendOTP(let phoneNo, let dialingCode):
            return ["PhoneNo":phoneNo, "DialingCode":dialingCode]
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .TokenCreate , .login, .sendOTP:
            return .post
            //        case .getPaymentEarning:
            //            return .get
        }
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        switch self {
            
        //Post API
        case  .TokenCreate , .login, .sendOTP:
            return .requestCompositeParameters(bodyParameters: self.parameters!,
                                               bodyEncoding: JSONEncoding.default,
                                               urlParameters: [:])
            // Get API with Parameters
            //        case .getPaymentEarning:
            //                return .requestParameters(parameters: self.parameters!, encoding: URLEncoding.queryString)
            
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
