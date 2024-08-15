//
//  API.swift
//  RecipeQuest
//
//  Created by Anas Salah on 13/08/2024.
//


import Foundation

struct API {
    
    static func searchURL(query: String, endPoint: String?) -> String {
        // this the defult will retuen filters
        var url = "\(K.API.BASE_URL)?type=\(K.API.TYPE)&q=\(query)&app_id=\(K.API.APP_ID)&app_key=\(K.API.APP_KEY)"
        if let endPoint {
            url += "&\(endPoint)"
        }
        
        
        return url
    }

    static func recipeURL(by hash: String) -> String {
        return "\(K.API.BASE_URL)/\(hash)?type=\(K.API.TYPE)&app_id=\(K.API.APP_ID)&app_key=\(K.API.APP_KEY)"
    }
    
}
