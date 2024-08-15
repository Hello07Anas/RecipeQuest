//
//  Constants.swift
//  RecipeQuest
//
//  Created by Anas Salah on 13/08/2024.
//

import Foundation

struct K {
    struct API {
        static let APP_KEY = "38056447e90f5a82c86af092dc01936b"
        static let APP_ID = "201f33d7"
        static let BASE_URL = "https://api.edamam.com/api/recipes/v2"
        static let TYPE = "public"
    }
    
    struct Types {
        static let all = "all"
    }
    
    struct Strings {
        static let noResults = "No results found."
        static let loading = "Loading..."
    }
}

//https://api.edamam.com/api/recipes/v2?type=public&app_id=201f33d7&app_key=38056447e90f5a82c86af092dc01936b&q=cake&health=low-sugar
