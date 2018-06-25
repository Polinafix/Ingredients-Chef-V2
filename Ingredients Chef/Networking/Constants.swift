//
//  Constants.swift
//  Ingredients Chef
//
//  Created by Polina Fiksson on 04/04/2018.
//  Copyright © 2018 PolinaFiksson. All rights reserved.
//

import Foundation

struct Constants {
    
    // MARK: URL
    struct Spoonacular {
        static let ApiScheme = "https"
        static let ApiHost = "spoonacular-recipe-food-nutrition-v1.p.mashape.com"
        static let ApiPath = "/recipes"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let FillIngredients = "fillIngredients"
        static let Ingredients = "ingredients"
        static let LimitLicense = "limitLicense"
        static let Number = "number"
        static let Ranking = "ranking"
        static let ID = "id"
        static let IncludeNutrition = "includeNutrition"
        
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        static let FillIngredients = false
        static let LimitLicense = false
        static let Number = 15
        static let Ranking = 1
        
    }
    
    // MARK: Response Keys
    struct TMDBResponseKeys {
        static let Title = "title"
        static let ID = "id"
        static let PosterPath = "poster_path"
        static let StatusCode = "status_code"
        static let StatusMessage = "status_message"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Success = "success"
        static let UserID = "id"
        static let Results = "results"
    }
}
