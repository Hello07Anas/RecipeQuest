//
//  APIParameters.swift
//  RecipeQuest
//
//  Created by Anas Salah on 15/08/2024.
//

import Foundation


struct APIParameters {
    static let all: [String: [String]] = [
        "diet": [
            "balanced",
            "high-fiber",
            "high-protein",
            "low-carb",
            "low-fat",
            "low-sodium"
        ],
        "health": [
            "alcohol-cocktail",
            "alcohol-free",
            "celery-free",
            "crustacean-free",
            "dairy-free",
            "DASH",
            "egg-free",
            "fish-free",
            "fodmap-free",
            "gluten-free",
            "immuno-supportive",
            "keto-friendly",
            "kidney-friendly",
            "kosher",
            "low-fat-abs",
            "low-potassium",
            "low-sugar",
            "lupine-free",
            "Mediterranean",
            "mollusk-free",
            "mustard-free",
            "no-oil-added",
            "paleo",
            "peanut-free",
            "pescatarian",
            "pork-free",
            "red-meat-free",
            "sesame-free",
            "shellfish-free",
            "soy-free",
            "sugar-conscious",
            "sulfite-free",
            "tree-nut-free",
            "vegan",
            "vegetarian",
            "wheat-free"
        ],
        "cuisineType": [
            "American",
            "Asian",
            "British",
            "Caribbean",
            "Central Europe",
            "Chinese",
            "Eastern Europe",
            "French",
            "Indian",
            "Italian",
            "Japanese",
            "Kosher",
            "Mediterranean",
            "Mexican",
            "Middle Eastern",
            "Nordic",
            "South American",
            "South East Asian"
        ],
        "mealType": [
            "Breakfast",
            "Dinner",
            "Lunch",
            "Snack",
            "Teatime"
        ],
        "dishType": [
            "Biscuits and cookies",
            "Bread",
            "Cereals",
            "Condiments and sauces",
            "Desserts",
            "Drinks",
            "Main course",
            "Pancake",
            "Preps",
            "Preserve",
            "Salad",
            "Sandwiches",
            "Side dish",
            "Soup",
            "Starter",
            "Sweets"
        ]
    ]
}
