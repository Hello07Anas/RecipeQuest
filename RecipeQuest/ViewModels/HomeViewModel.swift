//
//  HomeViewModel.swift
//  RecipeQuest
//
//  Created by Anas Salah on 13/08/2024.
//

import Combine

class HomeViewModel {
    
    @Published var recipes: [Recipe] = []
    @Published var mainFilters: [Filter] = []
    @Published var subFilters: [Filter] = []
    
    private var cancellables: Set<AnyCancellable> = []
    private let recipeService = RecipeService()
    
    func fetchRecipes(searchTerm: String?, selectedFilters: [String] = []) {
        recipeService.searchRecipes(query: searchTerm ?? "", mainFilter: "", subFilter: "") { [weak self] result in
            switch result {
            case .success(let recipes):
                self?.recipes = recipes
            case .failure(let error):
                print("Failed to fetch recipes: \(error)")
            }
        }
    }
    
    func fetchFilters() {
        self.mainFilters = [Filter(name: "Health"), Filter(name: "Cuisine")]
    }
    
    func updateSubFilters(forMainFilter mainFilter: String) {
        self.subFilters = [Filter(name: "Low Sugar"), Filter(name: "Dairy-Free"), Filter(name: "Vegan")]
    }
}
