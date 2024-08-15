//
//  RecipeService.swift
//  RecipeQuest
//
//  Created by Anas Salah on 13/08/2024.
//

import Foundation
import Alamofire

enum RecipeServiceError: Error {
    case requestFailed
    case decodingError
}

class RecipeService {
    
    func searchRecipes(query: String, mainFilter: String?, subFilter: String?, completion: @escaping (Result<[Recipe], RecipeServiceError>) -> Void) {
        let url = API.searchURL(query: query, mainFilter: mainFilter, subFilter: subFilter)
        
        AF.request(url).validate().responseDecodable(of: RecipeSearchResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.hits.map { $0.recipe }))
            case .failure:
                completion(.failure(.requestFailed))
            }
        }
    }

    func fetchRecipe(by hash: String, completion: @escaping (Result<Recipe, RecipeServiceError>) -> Void) {
        let url = API.recipeURL(by: hash)
        
        AF.request(url).validate().responseDecodable(of: Recipe.self) { response in
            switch response.result {
            case .success(let recipe):
                completion(.success(recipe))
            case .failure:
                completion(.failure(.requestFailed))
            }
        }
    }
}
