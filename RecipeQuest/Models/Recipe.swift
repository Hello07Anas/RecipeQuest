//
//  Recipe.swift
//  RecipeQuest
//
//  Created by Anas Salah on 13/08/2024.
//

import Foundation

struct RecipeSearchResponse: Decodable {
    let hits: [Hit]
    let _links: Links
}

struct Hit: Decodable {
    let recipe: Recipe
}

struct Recipe: Decodable {
    let label: String
    let image: String
    let source: String
    let calories: Double
    let totalWeight: Double
    let totalTime: Int
    let healthLabels: [String]
}

struct Filter: Codable {
    let name: String
}

struct Links: Decodable {
    let next: NextLink
}

struct NextLink: Decodable {
    let href: String
}
