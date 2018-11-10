//
//  JsonUtil.swift
//  ComicApp
//
//  Created by GuJinYi on 16/8/30.
//  Copyright © 2016年 Genesis. All rights reserved.
//

import UIKit

class JsonUtil {
    static func retrieveJsonFromData(data: NSData) -> AnyObject {
        
        /* Now try to deserialize the JSON object into a dictionary */
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data,
                                                                        options: .AllowFragments)
            
            print("Successfully deserialized...")
            
            /*
            if jsonObject is NSDictionary{
                let deserializedDictionary = jsonObject as! NSDictionary
                print("Deserialized JSON Dictionary = \(deserializedDictionary)")
            }
            else if jsonObject is NSArray{
                let deserializedArray = jsonObject as! NSArray
                print("Deserialized JSON Array = \(deserializedArray)")
            }
            else {
                /* Some other object was returned. We don't know how to
                 deal with this situation as the deserializer only
                 returns dictionaries or arrays */
            }
            */
            return jsonObject
        } catch {
            print("An error happened while deserializing the JSON data.")
            return ""
        }
    }
}





