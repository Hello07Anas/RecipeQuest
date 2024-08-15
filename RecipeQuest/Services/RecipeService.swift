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
    func searchRecipes(query: String, endPoint: String?, completion: @escaping (Result<RecipeSearchResponse, RecipeServiceError>) -> Void) {
        let url = API.searchURL(query: query, endPoint: endPoint)
        
        AF.request(url).validate().responseDecodable(of: RecipeSearchResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                completion(.failure(.requestFailed))
            }
        }
    }
    
    func nextRecipes(url :String?, completion: @escaping (Result<RecipeSearchResponse, RecipeServiceError>) -> Void) {
        
        AF.request(url ?? "").validate().responseDecodable(of: RecipeSearchResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                completion(.failure(.requestFailed))
            }
        }
    }
}
