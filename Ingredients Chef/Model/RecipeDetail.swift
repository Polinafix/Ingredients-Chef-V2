//
//  RecipeDetail.swift
//  Ingredients Chef
//
//  Created by Polina Fiksson on 04/04/2018.
//  Copyright © 2018 PolinaFiksson. All rights reserved.
//

import Foundation

class RecipeDetail {
    
    var ingredients:[String]?
    var readyInMinutes:Int?
    var instructions:String?
    
    init(ingredients: [String], readyInMinutes:Int, instructions:String) {
        self.ingredients = ingredients
        self.readyInMinutes = readyInMinutes
        self.instructions = instructions
        
    }
}

