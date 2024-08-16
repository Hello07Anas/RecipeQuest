//
//  RecipeTableViewCell.swift
//  RecipeQuest
//
//  Created by Anas Salah on 15/08/2024.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeSourceBtn: UIButton!
  
    func setup(with recipe: Recipe) {
        recipeName.text = recipe.label
        recipeSourceBtn.setTitle(recipe.source, for: .normal)
        
        let placeholderImage = UIImage(named: "recipeImg")
        if let imageURL = URL(string: recipe.image) {
            recipeImg.kf.setImage(with: imageURL, placeholder: placeholderImage)
        } else {
            recipeImg.image = placeholderImage
        }
    }
}
