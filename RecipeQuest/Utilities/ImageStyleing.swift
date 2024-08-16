//
//  ImageStyleing.swift
//  RecipeQuest
//
//  Created by Anas Salah on 16/08/2024.
//

import UIKit

struct ImageStyling {
    static func style(image: UIImageView,
                      cornerRadius: CGFloat = 1.0,
                      borderWidth: CGFloat = 1.0,
                      borderColor: UIColor = .systemCyan) {
        
        image.layer.cornerRadius = cornerRadius
        image.layer.borderWidth = borderWidth
        image.layer.borderColor = borderColor.cgColor
        image.layer.masksToBounds = true
    }
}

