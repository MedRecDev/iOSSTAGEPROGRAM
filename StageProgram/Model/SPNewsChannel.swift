//
//  SPNewsChannel.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on July 6, 2020

import Foundation
import SwiftyJSON


class SPNewsChannel : NSObject, NSCoding{

    var activeStatus : String!
    var createddate : String!
    var isdeleted : Bool!
    var modifieddate : String!
    var newsChannelName : String!
    var newsEmbedUrl : String!
    var newsFeedUrl : String!
    var newsId : Int!
    var newsStateId : Int!
    var newsThumbUrl : String!

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
        newsChannelName = json["news_channel_name"].stringValue
        newsEmbedUrl = json["news_embed_url"].stringValue
        newsFeedUrl = json["news_feed_url"].stringValue
        newsId = json["news_id"].intValue
        newsStateId = json["news_state_id"].intValue
        newsThumbUrl = json["news_thumb_url"].stringValue
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
        if newsChannelName != nil{
        	dictionary["news_channel_name"] = newsChannelName
        }
        if newsEmbedUrl != nil{
        	dictionary["news_embed_url"] = newsEmbedUrl
        }
        if newsFeedUrl != nil{
        	dictionary["news_feed_url"] = newsFeedUrl
        }
        if newsId != nil{
        	dictionary["news_id"] = newsId
        }
        if newsStateId != nil{
        	dictionary["news_state_id"] = newsStateId
        }
        if newsThumbUrl != nil{
        	dictionary["news_thumb_url"] = newsThumbUrl
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
		newsChannelName = aDecoder.decodeObject(forKey: "news_channel_name") as? String
		newsEmbedUrl = aDecoder.decodeObject(forKey: "news_embed_url") as? String
		newsFeedUrl = aDecoder.decodeObject(forKey: "news_feed_url") as? String
		newsId = aDecoder.decodeObject(forKey: "news_id") as? Int
		newsStateId = aDecoder.decodeObject(forKey: "news_state_id") as? Int
		newsThumbUrl = aDecoder.decodeObject(forKey: "news_thumb_url") as? String
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
		if newsChannelName != nil{
			aCoder.encode(newsChannelName, forKey: "news_channel_name")
		}
		if newsEmbedUrl != nil{
			aCoder.encode(newsEmbedUrl, forKey: "news_embed_url")
		}
		if newsFeedUrl != nil{
			aCoder.encode(newsFeedUrl, forKey: "news_feed_url")
		}
		if newsId != nil{
			aCoder.encode(newsId, forKey: "news_id")
		}
		if newsStateId != nil{
			aCoder.encode(newsStateId, forKey: "news_state_id")
		}
		if newsThumbUrl != nil{
			aCoder.encode(newsThumbUrl, forKey: "news_thumb_url")
		}

	}

}
