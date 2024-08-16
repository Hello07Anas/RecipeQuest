//
//  RecipeDetailViewModel.swift
//  RecipeQuest
//
//  Created by Anas Salah on 13/08/2024.
//

import Foundation

protocol RecipeDetailViewModelProtocol {
    var recipeName: String { get }
    var caloriesPerGramText: String { get }
    var totalWeightText: String { get }
    var totalTimeText: String { get }
    var imageURL: URL? { get }
}

struct RecipeDetailViewModel: RecipeDetailViewModelProtocol {
    
    private let recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    var recipeName: String {
        return recipe.label
    }
    
    var caloriesPerGramText: String {
        guard recipe.totalWeight > 0 else { return "N/A" }
        let caloriesPerUnit = recipe.calories / recipe.totalWeight
        return String(format: "%.1f per gram", caloriesPerUnit)
    }
    
    var totalWeightText: String {
        return String(format: "%.1f g", recipe.totalWeight)
    }
    
    var totalTimeText: String {
        return "\(recipe.totalTime) min"
    }
    
    var imageURL: URL? {
        return URL(string: recipe.image)
    }
}
