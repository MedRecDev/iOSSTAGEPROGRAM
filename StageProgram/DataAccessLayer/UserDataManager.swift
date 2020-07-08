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
    var currentUser : SPUser?
    var userToken : String?
    
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
    
    func userLogin(email: String, password: String, completion:@escaping (Bool, String?) -> Void) {
        NetworkAdapter().userLogin(email: email, password: password) { (user, errorMessage) in
            if let user = user {
                self.currentUser = user
                UserDefaults.standard.setValue(true, forKey: KEY_REGISTRATION_COMPLETED)
                UserDefaults.standard.setValue(self.currentUser?.userToken, forKey: KEY_USER_TOKEN)
                completion(true, nil)
            } else  {
                completion(false, errorMessage)
            }
        }
    }
    
    func userRegister(firstName: String, lastName: String, email: String, password: String, phoneNo: String, completion:@escaping (Bool, String?) -> Void) {
        NetworkAdapter().userRegister(email: email, password: password, firstName: firstName, lastName: lastName, phoneNo: phoneNo) { (response, errorMessage) in
            if let user = response as? SPUser {
                self.currentUser = user
                completion(true, nil)
            } else if let uToken = response as? String {
                self.userToken = uToken
                UserDefaults.standard.setValue(false, forKey: KEY_REGISTRATION_COMPLETED)
                UserDefaults.standard.setValue(self.currentUser?.userToken, forKey: KEY_USER_TOKEN)
                completion(true, nil)
            } else {
                completion(false, errorMessage)
            }
        }
    }
    
    func completeRegistrationWithOTP(otp: String, completion: @escaping (Bool, String?) -> Void) {
        var token = ""
        if let uToken = self.userToken {
            token = uToken
        } else if let uToken = UserDataManager.shared.userToken {
            token = uToken
        }
        NetworkAdapter().completeRegisterFlowWithOTP(userToken: token, otp: otp) { (user, errorMessage) in
            if let user = user {
                self.currentUser = user
                UserDefaults.standard.setValue(true, forKey: KEY_REGISTRATION_COMPLETED)
                UserDefaults.standard.setValue(self.currentUser?.userToken, forKey: KEY_USER_TOKEN)
                completion(true, nil)
            } else  {
                completion(false, errorMessage)
            }
        }
    }
    
    func resendOTP(completion: @escaping (Bool, String?) -> Void) {
        if let userToken = UserDataManager.shared.userToken {
            NetworkAdapter().resendOTP(userToken: userToken, tokenType: 2) { (success, errorMessage) in
                completion(success, errorMessage)
            }
        }
    }
}
