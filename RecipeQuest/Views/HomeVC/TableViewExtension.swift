//
//  TableViewExtension.swift
//  RecipeQuest
//
//  Created by Anas Salah on 16/08/2024.
//

import UIKit

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateViewVisibility()
        return viewModel.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        let recipe = viewModel.recipes[indexPath.row]
        cell.setup(with: recipe)
        
        if indexPath.row == viewModel.recipes.count - 1 {
            viewModel.getNextRecipes()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedRecipe = viewModel.recipes[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "RecipeDetailViewController") as? RecipeDetailViewController {
            let detailViewModel = RecipeDetailViewModel(recipe: selectedRecipe)
            detailVC.viewModel = detailViewModel
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func updateViewVisibility() {
        if viewModel.recipes.isEmpty {
            emptyBackgroundImg.isHidden = false
            recipesTableView.isHidden = true
        } else {
            emptyBackgroundImg.isHidden = true
            recipesTableView.isHidden = false
        }
    }
}
