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
    private var nextLink = ""
    private var cancellables: Set<AnyCancellable> = []
    private let recipeService = RecipeService()
    
    func fetchRecipes(query: String?, endPoint: String?) {
        recipeService.searchRecipes(query: query ?? "", endPoint: endPoint ?? "") { [weak self] result in
            switch result {
            case .success(let data):
                self?.recipes = data.hits.map { $0.recipe}
                self?.nextLink = data._links.next.href
            case .failure(let error):
                self?.recipes = []
                print("Failed to fetch recipes: \(error.localizedDescription)")
            }
        }
    }
    
    func getNextRecipes() {
        recipeService.nextRecipes(url: nextLink) { [weak self] result in
            switch result {
            case .success(let data):
                self?.recipes.append(contentsOf: data.hits.map { $0.recipe})
                self?.nextLink = data._links.next.href
            case .failure(let error):
                print("Failed to fetch recipes: \(error.localizedDescription)")
            }
        }
    }
    
    func clearRecipes() {
        recipes.removeAll()
    }
}
