//
//  RecipeDetailViewModel.swift
//  RecipeQuest
//
//  Created by Anas Salah on 13/08/2024.
//

import Foundation

struct RecipeDetailViewModel {
    private let recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    var recipeName: String {
        return recipe.label
    }
    
    var caloriesText: String {
        return String(format: "Calories: %.1f", recipe.calories)
    }
    
    var totalWeightText: String {
        return String(format: "Total Weight: %.1f g", recipe.totalWeight)
    }
    
    var totalTimeText: String {
        return recipe.totalTime > 0 ? "Total Time: \(recipe.totalTime) mins" : "Total Time: N/A"
    }
    
    var imageURL: URL? {
        return URL(string: recipe.image)
    }
}
