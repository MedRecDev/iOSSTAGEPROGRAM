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
    case UserLogin(email: String, password: String)
    case UserRegister(firstName: String, lastName: String, email: String, password: String, phoneNo: String)
    case VideoLike(videoId: Int, userToken: String)
    case VideoDisLike(videoId: Int, userToken: String)
    case UploadVideo(userToken: String, videoTitle: String, videoDescription: String, stateId: Int, videoFilePath: String)
    case NewsStates
    case NewsChannels
    case RegisterComplete(userToken: String, otp: String)
    case ResendOTP(userToken: String, tokenType: Int)
    case IncreaseVideoView(videoId: Int)
    case SendFeedback(userToken: String, title: String, description: String)
    case ClipFeed(pageSize:Int, pageNumber: Int)
    case IncreaseViewCountForClip(feedSourceId: Int)
    case FeedLike(feedSourceId: Int, userToken: String)
    case ReportFeedSpam(feedSourceId: Int, userToken: String, reason: String)
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
        case .UserLogin:
            return "account/login"
        case .UserRegister:
            return "account/register"
        case .VideoLike:
            return "videos/like"
        case .VideoDisLike:
            return "videos/unlike"
        case .UploadVideo:
            return "videos/upload"
        case .NewsStates:
            return "news/states"
        case .NewsChannels:
            return "news/channels"
        case .RegisterComplete:
            return "account/register-complete"
        case .ResendOTP:
            return "resendotp"
        case .IncreaseVideoView:
            return "videos/setviews"
        case .SendFeedback:
            return "feedback"
        case .ClipFeed:
            return "feed"
        case .IncreaseViewCountForClip:
            return "feed/setviews"
        case .FeedLike:
            return "feed/like"
        case .ReportFeedSpam:
            return "feed/report-spam"
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
        case .UserLogin(let email, let password):
            return ["email": email, "password": password]
        case .UserRegister(let firstName, let lastName, let email, let password, let phoneNo):
            return ["first_name": firstName, "last_name": lastName, "email": email, "password": password, "contact_no": phoneNo]
        case .VideoLike(let videoId, let userToken):
            return ["video_id": videoId, "user_token": userToken]
        case .VideoDisLike(let videoId, let userToken):
            return ["video_id": videoId, "user_token": userToken]
        case .UploadVideo(let userToken, let videoTitle, let videoDescription, let stateId, let videoFilePath):
            return ["user_token": userToken, "video_title": videoTitle, "video_description": videoDescription, "state_id": stateId, "video_file": videoFilePath]
        case .NewsStates:
            return [:]
        case .NewsChannels:
            return [:]
        case .RegisterComplete(let userToken, let otp):
            return ["token": userToken,"one_time_password": otp]
        case .ResendOTP(let userToken, let tokenType):
            return ["resend_token_type": tokenType, "token": userToken]
        case .IncreaseVideoView(let videoId):
            return ["video_id": videoId]
        case .SendFeedback(let userToken, let title, let description):
            return ["user_token": userToken, "feedback_title": title, "feedback_description": description]
        case .ClipFeed(let pageSize, let pageNumber):
            return ["page_size": pageSize, "page_number": pageNumber]
        case .IncreaseViewCountForClip(let feedSourceId):
            return ["feed_source_id": feedSourceId]
        case .FeedLike(let feedSourceId, let userToken):
            return ["feed_source_id": feedSourceId, "user_token": userToken]
        case .ReportFeedSpam(let feedSourceId, let userToken, let reason):
            return ["feed_source_id": feedSourceId, "user_token": userToken, "reason": reason]
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .TokenCreate, .UserLogin, .UserRegister, .UploadVideo, .RegisterComplete, .ResendOTP, .SendFeedback, .ReportFeedSpam:
            return .post
        case .VideoLike, .VideoDisLike, .IncreaseVideoView, .IncreaseViewCountForClip, .FeedLike:
            return .put
        case .StateList, .VideoList, .SuggestionList, .NewsStates, .NewsChannels, .ClipFeed:
            return .get
        }
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        switch self {
        //Post API
        case  .TokenCreate, .UserLogin, .UserRegister, .VideoLike, .VideoDisLike, .RegisterComplete, .ResendOTP, .SendFeedback, .FeedLike, .ReportFeedSpam:
            return .requestCompositeParameters(bodyParameters: self.parameters!,
                                               bodyEncoding: JSONEncoding.default,
                                               urlParameters: [:])
        case .StateList, .VideoList, .SuggestionList, .NewsStates, .NewsChannels, .IncreaseVideoView, .ClipFeed, .IncreaseViewCountForClip:
                return .requestParameters(parameters: self.parameters!, encoding: URLEncoding.queryString)
        case .UploadVideo:
            var mutDatas = [MultipartFormData]()
            for (key, value) in self.parameters! {
                if let data = (value as? String), key == "video_file" {
                    mutDatas.append(MultipartFormData(provider: .file(URL(string: data)!), name: key))
                }
                else if let data = (value as? String)?.data(using: .utf8) {
                    mutDatas.append(MultipartFormData(provider: .data(data), name: key))
                }
                else if let intValue = value as? Int, let data = String(intValue).data(using: .utf8) {
                    mutDatas.append(MultipartFormData(provider: .data(data), name: key))
                }
            }
//            return .uploadMultipart(mutDatas)
            return .uploadCompositeMultipart(mutDatas, urlParameters: [:])
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
