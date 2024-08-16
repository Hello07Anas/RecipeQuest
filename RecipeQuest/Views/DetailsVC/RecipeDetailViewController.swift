//
//  RecipeDetailViewController.swift
//  RecipeQuest
//
//  Created by Anas Salah on 13/08/2024.
//

import UIKit
import Kingfisher
 
class RecipeDetailViewController: UIViewController {

    @IBOutlet private weak var recipeImg: UIImageView!
    @IBOutlet private weak var recipeNameLabel: UILabel!
    @IBOutlet private weak var recipeCaloriesLabel: UILabel!
    @IBOutlet private weak var recipeTotalWeightLabel: UILabel!
    @IBOutlet private weak var recipeTotalTimeLabel: UILabel!
    
    var viewModel: RecipeDetailViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        guard let viewModel = viewModel else { return }
        updateRecipeDetails(with: viewModel)
    }
    
    private func updateRecipeDetails(with viewModel: RecipeDetailViewModelProtocol) {
        recipeNameLabel.text = viewModel.recipeName
        recipeCaloriesLabel.text = viewModel.caloriesPerGramText
        recipeTotalWeightLabel.text = viewModel.totalWeightText
        recipeTotalTimeLabel.text = viewModel.totalTimeText
        
        if let imageURL = viewModel.imageURL {
            recipeImg.kf.setImage(with: imageURL, placeholder: UIImage(named: "recipeImgPlaceholder"))
        } else {
            recipeImg.image = UIImage(named: "recipeImgPlaceholder")
        }
    }
}
