//
//  API.swift
//  RecipeQuest
//
//  Created by Anas Salah on 13/08/2024.
//


import Foundation

struct API {
    
    static func searchURL(query: String, mainFilter: String?, subFilter: String?) -> String {
        var url = "\(K.API.BASE_URL)?type=\(K.API.TYPE)&q=\(query)&app_id=\(K.API.APP_ID)&app_key=\(K.API.APP_KEY)" // this the defult will retuen all
        
        if let mainFilter = mainFilter, let subFilter = subFilter, mainFilter != K.HealthFilters.all {
            url += "&\(mainFilter)=\(subFilter)"
        }
        
        return url
    }

    static func recipeURL(by hash: String) -> String {
        return "\(K.API.BASE_URL)/\(hash)?type=\(K.API.TYPE)&app_id=\(K.API.APP_ID)&app_key=\(K.API.APP_KEY)"
    }
    
}
