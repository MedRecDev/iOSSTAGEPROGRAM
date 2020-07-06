//
//  SPNewsStates.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 6, 2020

import Foundation
import SwiftyJSON


class SPNewsStates : NSObject, NSCoding{

    var activeStatus : String!
    var createddate : String!
    var isdeleted : Bool!
    var modifieddate : String!
    var newsState : String!
    var newsStateId : Int!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        activeStatus = json["active_status"].stringValue
        createddate = json["createddate"].stringValue
        isdeleted = json["isdeleted"].boolValue
        modifieddate = json["modifieddate"].stringValue
        newsState = json["news_state"].stringValue
        newsStateId = json["news_state_id"].intValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if activeStatus != nil{
        	dictionary["active_status"] = activeStatus
        }
        if createddate != nil{
        	dictionary["createddate"] = createddate
        }
        if isdeleted != nil{
        	dictionary["isdeleted"] = isdeleted
        }
        if modifieddate != nil{
        	dictionary["modifieddate"] = modifieddate
        }
        if newsState != nil{
        	dictionary["news_state"] = newsState
        }
        if newsStateId != nil{
        	dictionary["news_state_id"] = newsStateId
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		activeStatus = aDecoder.decodeObject(forKey: "active_status") as? String
		createddate = aDecoder.decodeObject(forKey: "createddate") as? String
		isdeleted = aDecoder.decodeObject(forKey: "isdeleted") as? Bool
		modifieddate = aDecoder.decodeObject(forKey: "modifieddate") as? String
		newsState = aDecoder.decodeObject(forKey: "news_state") as? String
		newsStateId = aDecoder.decodeObject(forKey: "news_state_id") as? Int
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if activeStatus != nil{
			aCoder.encode(activeStatus, forKey: "active_status")
		}
		if createddate != nil{
			aCoder.encode(createddate, forKey: "createddate")
		}
		if isdeleted != nil{
			aCoder.encode(isdeleted, forKey: "isdeleted")
		}
		if modifieddate != nil{
			aCoder.encode(modifieddate, forKey: "modifieddate")
		}
		if newsState != nil{
			aCoder.encode(newsState, forKey: "news_state")
		}
		if newsStateId != nil{
			aCoder.encode(newsStateId, forKey: "news_state_id")
		}

	}

}
