//
//  SPVideoDetail.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on June 22, 2020

import Foundation
import SwiftyJSON


class SPVideoDetail : NSObject, NSCoding{

    var createdBy : String!
    var createdDate : String!
    var isActive : Bool!
    var mainThumbnailUrl : String!
    var mediaUrl : String!
    var modifiedBy : String!
    var modifiedDate : String!
    var shouldDisplay : Bool!
    var smallThumbnailUrl : String!
    var standardThumbnailUrl : String!
    var stateId : Int!
    var totalDislike : Int!
    var totalLike : Int!
    var totalViews : Int!
    var userIp : String!
    var videoDescription : String!
    var videoShareUrl : String!
    var videoSourceId : Int!
    var videoTitle : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        createdBy = json["createdBy"].stringValue
        createdDate = json["createdDate"].stringValue
        isActive = json["isActive"].boolValue
        mainThumbnailUrl = json["mainThumbnailUrl"].stringValue
        mediaUrl = json["mediaUrl"].stringValue
        modifiedBy = json["modifiedBy"].stringValue
        modifiedDate = json["modifiedDate"].stringValue
        shouldDisplay = json["shouldDisplay"].boolValue
        smallThumbnailUrl = json["smallThumbnailUrl"].stringValue
        standardThumbnailUrl = json["standardThumbnailUrl"].stringValue
        stateId = json["stateId"].intValue
        totalDislike = json["totalDislike"].intValue
        totalLike = json["totalLike"].intValue
        totalViews = json["totalViews"].intValue
        userIp = json["userIp"].stringValue
        videoDescription = json["videoDescription"].stringValue
        videoShareUrl = json["videoShareUrl"].stringValue
        videoSourceId = json["videoSourceId"].intValue
        videoTitle = json["videoTitle"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if createdBy != nil{
        	dictionary["createdBy"] = createdBy
        }
        if createdDate != nil{
        	dictionary["createdDate"] = createdDate
        }
        if isActive != nil{
        	dictionary["isActive"] = isActive
        }
        if mainThumbnailUrl != nil{
        	dictionary["mainThumbnailUrl"] = mainThumbnailUrl
        }
        if mediaUrl != nil{
        	dictionary["mediaUrl"] = mediaUrl
        }
        if modifiedBy != nil{
        	dictionary["modifiedBy"] = modifiedBy
        }
        if modifiedDate != nil{
        	dictionary["modifiedDate"] = modifiedDate
        }
        if shouldDisplay != nil{
        	dictionary["shouldDisplay"] = shouldDisplay
        }
        if smallThumbnailUrl != nil{
        	dictionary["smallThumbnailUrl"] = smallThumbnailUrl
        }
        if standardThumbnailUrl != nil{
        	dictionary["standardThumbnailUrl"] = standardThumbnailUrl
        }
        if stateId != nil{
        	dictionary["stateId"] = stateId
        }
        if totalDislike != nil{
        	dictionary["totalDislike"] = totalDislike
        }
        if totalLike != nil{
        	dictionary["totalLike"] = totalLike
        }
        if totalViews != nil{
        	dictionary["totalViews"] = totalViews
        }
        if userIp != nil{
        	dictionary["userIp"] = userIp
        }
        if videoDescription != nil{
        	dictionary["videoDescription"] = videoDescription
        }
        if videoShareUrl != nil{
        	dictionary["videoShareUrl"] = videoShareUrl
        }
        if videoSourceId != nil{
        	dictionary["videoSourceId"] = videoSourceId
        }
        if videoTitle != nil{
        	dictionary["videoTitle"] = videoTitle
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		createdBy = aDecoder.decodeObject(forKey: "createdBy") as? String
		createdDate = aDecoder.decodeObject(forKey: "createdDate") as? String
		isActive = aDecoder.decodeObject(forKey: "isActive") as? Bool
		mainThumbnailUrl = aDecoder.decodeObject(forKey: "mainThumbnailUrl") as? String
		mediaUrl = aDecoder.decodeObject(forKey: "mediaUrl") as? String
		modifiedBy = aDecoder.decodeObject(forKey: "modifiedBy") as? String
		modifiedDate = aDecoder.decodeObject(forKey: "modifiedDate") as? String
		shouldDisplay = aDecoder.decodeObject(forKey: "shouldDisplay") as? Bool
		smallThumbnailUrl = aDecoder.decodeObject(forKey: "smallThumbnailUrl") as? String
		standardThumbnailUrl = aDecoder.decodeObject(forKey: "standardThumbnailUrl") as? String
		stateId = aDecoder.decodeObject(forKey: "stateId") as? Int
		totalDislike = aDecoder.decodeObject(forKey: "totalDislike") as? Int
		totalLike = aDecoder.decodeObject(forKey: "totalLike") as? Int
		totalViews = aDecoder.decodeObject(forKey: "totalViews") as? Int
		userIp = aDecoder.decodeObject(forKey: "userIp") as? String
		videoDescription = aDecoder.decodeObject(forKey: "videoDescription") as? String
		videoShareUrl = aDecoder.decodeObject(forKey: "videoShareUrl") as? String
		videoSourceId = aDecoder.decodeObject(forKey: "videoSourceId") as? Int
		videoTitle = aDecoder.decodeObject(forKey: "videoTitle") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if createdBy != nil{
			aCoder.encode(createdBy, forKey: "createdBy")
		}
		if createdDate != nil{
			aCoder.encode(createdDate, forKey: "createdDate")
		}
		if isActive != nil{
			aCoder.encode(isActive, forKey: "isActive")
		}
		if mainThumbnailUrl != nil{
			aCoder.encode(mainThumbnailUrl, forKey: "mainThumbnailUrl")
		}
		if mediaUrl != nil{
			aCoder.encode(mediaUrl, forKey: "mediaUrl")
		}
		if modifiedBy != nil{
			aCoder.encode(modifiedBy, forKey: "modifiedBy")
		}
		if modifiedDate != nil{
			aCoder.encode(modifiedDate, forKey: "modifiedDate")
		}
		if shouldDisplay != nil{
			aCoder.encode(shouldDisplay, forKey: "shouldDisplay")
		}
		if smallThumbnailUrl != nil{
			aCoder.encode(smallThumbnailUrl, forKey: "smallThumbnailUrl")
		}
		if standardThumbnailUrl != nil{
			aCoder.encode(standardThumbnailUrl, forKey: "standardThumbnailUrl")
		}
		if stateId != nil{
			aCoder.encode(stateId, forKey: "stateId")
		}
		if totalDislike != nil{
			aCoder.encode(totalDislike, forKey: "totalDislike")
		}
		if totalLike != nil{
			aCoder.encode(totalLike, forKey: "totalLike")
		}
		if totalViews != nil{
			aCoder.encode(totalViews, forKey: "totalViews")
		}
		if userIp != nil{
			aCoder.encode(userIp, forKey: "userIp")
		}
		if videoDescription != nil{
			aCoder.encode(videoDescription, forKey: "videoDescription")
		}
		if videoShareUrl != nil{
			aCoder.encode(videoShareUrl, forKey: "videoShareUrl")
		}
		if videoSourceId != nil{
			aCoder.encode(videoSourceId, forKey: "videoSourceId")
		}
		if videoTitle != nil{
			aCoder.encode(videoTitle, forKey: "videoTitle")
		}

	}

}
