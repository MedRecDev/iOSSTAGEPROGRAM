//
//  SPUser.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on June 25, 2020

import Foundation
import SwiftyJSON


class SPUser : NSObject, NSCoding{

    var contactNo : String!
    var email : String!
    var firstName : String!
    var lastName : String!
    var userToken : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        contactNo = json["contact_no"].stringValue
        email = json["email"].stringValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        userToken = json["user_token"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if contactNo != nil{
        	dictionary["contact_no"] = contactNo
        }
        if email != nil{
        	dictionary["email"] = email
        }
        if firstName != nil{
        	dictionary["first_name"] = firstName
        }
        if lastName != nil{
        	dictionary["last_name"] = lastName
        }
        if userToken != nil{
        	dictionary["user_token"] = userToken
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		contactNo = aDecoder.decodeObject(forKey: "contact_no") as? String
		email = aDecoder.decodeObject(forKey: "email") as? String
		firstName = aDecoder.decodeObject(forKey: "first_name") as? String
		lastName = aDecoder.decodeObject(forKey: "last_name") as? String
		userToken = aDecoder.decodeObject(forKey: "user_token") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if contactNo != nil{
			aCoder.encode(contactNo, forKey: "contact_no")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if firstName != nil{
			aCoder.encode(firstName, forKey: "first_name")
		}
		if lastName != nil{
			aCoder.encode(lastName, forKey: "last_name")
		}
		if userToken != nil{
			aCoder.encode(userToken, forKey: "user_token")
		}

	}

}
