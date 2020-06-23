//
//  SPState.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on June 20, 2020

import Foundation
import SwiftyJSON


class SPState : NSObject, NSCoding{

    var contId : Int!
    var displayorder : Int!
    var entryDate : String!
    var entryTime : String!
    var isdeleted : Bool!
    var stateId : Int!
    var stateName : String!
    var userName : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        contId = json["cont_Id"].intValue
        displayorder = json["displayorder"].intValue
        entryDate = json["entryDate"].stringValue
        entryTime = json["entryTime"].stringValue
        isdeleted = json["isdeleted"].boolValue
        stateId = json["state_Id"].intValue
        stateName = json["state_Name"].stringValue
        userName = json["userName"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if contId != nil{
        	dictionary["cont_Id"] = contId
        }
        if displayorder != nil{
        	dictionary["displayorder"] = displayorder
        }
        if entryDate != nil{
        	dictionary["entryDate"] = entryDate
        }
        if entryTime != nil{
        	dictionary["entryTime"] = entryTime
        }
        if isdeleted != nil{
        	dictionary["isdeleted"] = isdeleted
        }
        if stateId != nil{
        	dictionary["state_Id"] = stateId
        }
        if stateName != nil{
        	dictionary["state_Name"] = stateName
        }
        if userName != nil{
        	dictionary["userName"] = userName
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		contId = aDecoder.decodeObject(forKey: "cont_Id") as? Int
		displayorder = aDecoder.decodeObject(forKey: "displayorder") as? Int
		entryDate = aDecoder.decodeObject(forKey: "entryDate") as? String
		entryTime = aDecoder.decodeObject(forKey: "entryTime") as? String
		isdeleted = aDecoder.decodeObject(forKey: "isdeleted") as? Bool
		stateId = aDecoder.decodeObject(forKey: "state_Id") as? Int
		stateName = aDecoder.decodeObject(forKey: "state_Name") as? String
		userName = aDecoder.decodeObject(forKey: "userName") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if contId != nil{
			aCoder.encode(contId, forKey: "cont_Id")
		}
		if displayorder != nil{
			aCoder.encode(displayorder, forKey: "displayorder")
		}
		if entryDate != nil{
			aCoder.encode(entryDate, forKey: "entryDate")
		}
		if entryTime != nil{
			aCoder.encode(entryTime, forKey: "entryTime")
		}
		if isdeleted != nil{
			aCoder.encode(isdeleted, forKey: "isdeleted")
		}
		if stateId != nil{
			aCoder.encode(stateId, forKey: "state_Id")
		}
		if stateName != nil{
			aCoder.encode(stateName, forKey: "state_Name")
		}
		if userName != nil{
			aCoder.encode(userName, forKey: "userName")
		}

	}

}
