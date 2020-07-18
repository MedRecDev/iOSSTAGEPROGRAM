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
    
    fileprivate var provider = MoyaProvider<AppTutorService>(endpointClosure: MoyaProvider.defaultEndpointMapping, requestClosure: MoyaProvider<AppTutorService>.defaultRequestMapping, stubClosure: MoyaProvider.neverStub, callbackQueue: nil, session: DefaultAlamofireManager.sharedManager, plugins: [NetworkLoggerPlugin(),  AccessTokenPlugin(tokenClosure: { (authType) -> String in
        return authToken ?? ""
    })], trackInflights: false)
//    fileprivate var provider = MoyaProvider<AppTutorService>(manager: DefaultAlamofireManager.sharedManager, plugins: [NetworkLoggerPlugin(),  AccessTokenPlugin(tokenClosure: { (authType) -> String in
//        return authToken ?? ""
//    })])
    
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
    
    func fetchStateList(pageNumber: Int, stateId: Int, pageSize: Int, completion: @escaping (_ response: [SPState]?, _ errorMessage: String?) -> Void) {
        self.provider.request(.StateList(page_number: pageNumber, state_id: stateId, page_size: pageSize)) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                do {
                    let responseJson = try JSON(data: data)
                    let dict = responseJson["data"]
                    let arrState = dict["data"]
                    var states: [SPState] = []
                    for json in arrState.arrayValue {
                        let state = SPState(fromJson: json)
                        states.append(state)
                    }
                    completion(states, nil)
                } catch {
                    completion(nil, "Error occured while fetching state list")
                }
            case .failure(let _):
                completion(nil, "Error occured while fetching state list")
            }
        }
    }
    
    func fetchVideoList(pageNumber: Int, pageSize: Int, stateId: Int, completion: @escaping (_ response: [SPVideoDetail]?, _ errorMessage: String?) -> Void) {
        self.provider.request(.VideoList(pageNumber: pageNumber, stateId: stateId, pageSize: pageSize)) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                do {
                    let responseJson = try JSON(data: data)
                    let dict = responseJson["data"]
                    let arrVideos = dict["data"]
                    var videos: [SPVideoDetail] = []
                    for json in arrVideos.arrayValue {
                        let state = SPVideoDetail(fromJson: json)
                        videos.append(state)
                    }
                    completion(videos, nil)
                } catch {
                    completion(nil, "Error occured while fetching state list")
                }
            case .failure(let _):
                completion(nil, "Error occured while fetching video list")
            }
        }
    }
    
    func fetchSuggestionsList(videoId: Int, completion: @escaping (_ response: [SPVideoDetail]?, _ errorMessage: String?) -> Void) {
        self.provider.request(.SuggestionList(videoId: videoId)) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                do {
                    let responseJson = try JSON(data: data)
                    let arrVideos = responseJson["data"]
                    var videos: [SPVideoDetail] = []
                    for json in arrVideos.arrayValue {
                        let state = SPVideoDetail(fromJson: json)
                        videos.append(state)
                    }
                    completion(videos, nil)
                } catch {
                    completion(nil, "Error occured while fetching state list")
                }
            case .failure(let _):
                completion(nil, "Error occured while fetching video list")
            }
        }
    }
    
    func userLogin(email: String, password: String, completion: @escaping (_ response: SPUser?, _ errorMessage: String?) -> Void) {
        self.provider.request(.UserLogin(email: email, password: password)) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                do {
                    let responseJson = try JSON(data: data)
                    if let _ = responseJson["data"].dictionary {
                        let userJson = responseJson["data"]
                        let user = SPUser(fromJson: userJson)
                        completion(user, nil)
                    } else {
                        let errorMessage = responseJson["message"].string
                        completion(nil, errorMessage)
                    }
                } catch {
                    completion(nil, "Error occured while user login")
                }
            case .failure(let _):
                completion(nil, "Error occured while user login")
            }
        }
    }
    
    func userRegister(email: String, password: String, firstName: String, lastName: String, phoneNo: String, completion: @escaping (_ response: Any?, _ errorMessage: String?) -> Void) {
        self.provider.request(.UserRegister(firstName: firstName, lastName: lastName, email: email, password: password, phoneNo: phoneNo)) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                do {
                    let responseJson = try JSON(data: data)
                    if let _ = responseJson["data"].dictionary {
                        let userJson = responseJson["data"]
                        let user = SPUser(fromJson: userJson)
                        completion(user, nil)
                    } else if let _ = responseJson["data"].string {
                        let userToken = responseJson["data"].stringValue
                        completion(userToken, nil)
                    } else {
                        let errorMessage = responseJson["message"].string
                        completion(nil, errorMessage)
                    }
                } catch {
                    completion(nil, "Error occured while user register")
                }
            case .failure(let _):
                completion(nil, "Error occured while user register")
            }
        }
    }
    
    func completeRegisterFlowWithOTP(userToken: String, otp: String, completion: @escaping (_ response: SPUser?, _ errorMessage: String?) -> Void) {
        self.provider.request(.RegisterComplete(userToken: userToken, otp: otp)) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                do {
                    let responseJson = try JSON(data: data)
                    if let _ = responseJson["data"].dictionary {
                        let userJson = responseJson["data"]
                        let user = SPUser(fromJson: userJson)
                        completion(user, nil)
                    } else {
                        let errorMessage = responseJson["message"].string
                        completion(nil, errorMessage)
                    }
                } catch {
                    completion(nil, "Error occured while user register")
                }
            case .failure(let _):
                completion(nil, "Error occured while user register")
            }
        }
    }
    
    func resendOTP(userToken: String, tokenType: Int, completion: @escaping (_ response: Bool, _ errorMessage: String?) -> Void) {
        self.provider.request(.ResendOTP(userToken: userToken, tokenType: tokenType)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let data = response.data
                    let responseJson = try JSON(data: data)
                    let errorMessage = responseJson["message"].string
                    completion(true, errorMessage)
                }
                catch {
                    completion(false, "Error occured while re-sending OTP")
                }
            case .failure(_):
                completion(false, "Error occured while re-sending OTP")
            }
        }
    }
    
    func videoLike(videoId: Int, userToken: String, completion: @escaping (_ response: [String:JSON]?, _ errorMessage: String?) -> Void) {
        self.provider.request(.VideoLike(videoId: videoId, userToken: userToken)) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                do {
                    let responseJson = try JSON(data: data)
                    if let data = responseJson["data"].dictionary {
                        completion(data, nil)
                    } else {
                        let errorMessage = responseJson["message"].string
                        completion(nil, errorMessage)
                    }
                } catch {
                    completion(nil, "Error occured while video like")
                }
            case .failure(let _):
                completion(nil, "Error occured while video like")
            }
        }
    }
    
    func videoUnLike(videoId: Int, userToken: String, completion: @escaping (_ response: [String:JSON]?, _ errorMessage: String?) -> Void) {
        self.provider.request(.VideoDisLike(videoId: videoId, userToken: userToken)) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                do {
                    let responseJson = try JSON(data: data)
                    if let data = responseJson["data"].dictionary {
                        completion(data, nil)
                    } else {
                        let errorMessage = responseJson["message"].string
                        completion(nil, errorMessage)
                    }
                } catch {
                    completion(nil, "Error occured while video unlike")
                }
            case .failure(let _):
                completion(nil, "Error occured while video unlike")
            }
        }
    }
    
    func increaseVideoViews(videoId: Int, completion: @escaping (_ response: Bool, _ errorMessage: String?) -> Void) {
        self.provider.request(.IncreaseVideoView(videoId: videoId)) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                completion(true, nil)
            case .failure(let _):
                completion(false, "Error occured while video unlike")
            }
        }
    }
    
    func uploadVideo(userToken: String, videoTitle: String, videoDescription: String, stateId: Int, videoFilePath: String, completion: @escaping (_ response: String?, _ errorMessage: String?) -> Void) {
        self.provider.request(.UploadVideo(userToken: userToken, videoTitle: videoTitle, videoDescription: videoDescription, stateId: stateId, videoFilePath: videoFilePath)) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                do {
                    let responseJson = try JSON(data: data)
                    if let message = responseJson["message"].string {
                        completion(nil, message)
                    } else {
                        completion(nil, "Error occured while uploading a video.")
                    }
                } catch {
                    completion(nil, "Error occured while uploading a video.")
                }
            case .failure(let _):
                completion(nil, "Error occured while uploading a video.")
            }
        }
    }
    
    func fetchNewsState(completion: @escaping (_ response: [SPNewsStates]?, _ errorMessage: String?) -> Void) {
        self.provider.request(.NewsStates) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                do {
                    let responseJson = try JSON(data: data)
                    let dict = responseJson["data"]
                    var newsStates: [SPNewsStates] = []
                    for json in dict.arrayValue {
                        let newsState = SPNewsStates(fromJson: json)
                        newsStates.append(newsState)
                    }
                    completion(newsStates, nil)
                } catch {
                    completion(nil, "Error occured while fetching news state list")
                }
            case .failure(let _):
                completion(nil, "Error occured while fetching news state list")
            }
        }
    }
    
    func fetchNewsChannels(completion: @escaping (_ response: [SPNewsChannel]?, _ errorMessage: String?) -> Void) {
        self.provider.request(.NewsChannels) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                do {
                    let responseJson = try JSON(data: data)
                    let dict = responseJson["data"]
                    var newsChannels: [SPNewsChannel] = []
                    for json in dict.arrayValue {
                        let newsChannel = SPNewsChannel(fromJson: json)
                        newsChannels.append(newsChannel)
                    }
                    completion(newsChannels, nil)
                } catch {
                    completion(nil, "Error occured while fetching news channels list")
                }
            case .failure(let _):
                completion(nil, "Error occured while fetching news channels list")
            }
        }
    }
    
    func sendFeedback(userToken: String, title: String, description: String, completion: @escaping (_ response: String?, _ errorMessage: String?) -> Void) {
        self.provider.request(.SendFeedback(userToken: userToken, title: title, description: description)) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                do {
                    let responseJson = try JSON(data: data)
                    if let message = responseJson["message"].string {
                        completion(message, nil)
                    } else {
                        completion(nil, "Error occured while sending user feedback.")
                    }
                } catch {
                    completion(nil, "Error occured while sending user feedback.")
                }
            case .failure(let error):
                completion(nil, "Error occured while sending user feedback.")
            }
        }
    }
    
    func fetchClipFeeds(pageSize: Int, pageNumber: Int, completion: @escaping (_ response: [SPClipFeed]?, _ errorMessage: String?) -> Void) {
        self.provider.request(.ClipFeed(pageSize: pageSize, pageNumber: pageNumber)) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                do {
                    let responseJson = try JSON(data: data)
                    let videosJson = responseJson["data"]
                    let arrVideos = videosJson["data"].arrayValue
                    var videos: [SPClipFeed] = []
                    for json in arrVideos {
                        let state = SPClipFeed(fromJson: json)
                        videos.append(state)
                    }
                    completion(videos, nil)
                } catch {
                    completion(nil, "Error occured while fetching clip feed.")
                }
            case .failure(let error):
                completion(nil, "Error occured while fetching clip feed.")
            }
        }
    }
}

class DefaultAlamofireManager: Alamofire.Session {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 120 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 120 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}
