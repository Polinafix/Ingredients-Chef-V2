//
//  TheRecipe.swift
//  Ingredients Chef
//
//  Created by Polina Fiksson on 04/04/2018.
//  Copyright © 2018 PolinaFiksson. All rights reserved.
//

import Foundation

class TheRecipe {
    
    var id:Int?
    var title = ""
    var imageURL = ""
    var data:Data?
    var details:RecipeDetail?
    
    init(id:Int, title:String, imageURL:String,details:RecipeDetail?) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.details = details
    }
}
