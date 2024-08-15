//
//  RecipeDetailViewController.swift
//  RecipeQuest
//
//  Created by Anas Salah on 13/08/2024.
//

import UIKit
import Kingfisher
 
class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var recipeNameOT: UILabel!
    @IBOutlet weak var recipeCaloriesOT: UILabel!
    @IBOutlet weak var recipeTotalWeightOT: UILabel!
    @IBOutlet weak var recipeTotalTimeOT: UILabel!
    
    var viewModel: RecipeDetailViewModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    @IBAction func backBtnTaped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI() {
        guard let viewModel = viewModel else { return }
        
        recipeNameOT.text = viewModel.recipeName
        recipeCaloriesOT.text = viewModel.caloriesText
        recipeTotalWeightOT.text = viewModel.totalWeightText
        recipeTotalTimeOT.text = viewModel.totalTimeText
        
        if let imageURL = viewModel.imageURL {
            recipeImg.kf.setImage(with: imageURL, placeholder: UIImage(named: "recipeImgPlaceholder"))
        } else {
            recipeImg.image = UIImage(named: "recipeImgPlaceholder")
        }
    }
}
