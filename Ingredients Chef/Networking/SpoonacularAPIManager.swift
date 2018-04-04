//
//  SpoonacularAPIManager.swift
//  Ingredients Chef
//
//  Created by Polina Fiksson on 04/04/2018.
//  Copyright © 2018 PolinaFiksson. All rights reserved.
//

import Foundation

class SpoonacularAPIManager {
    
    // MARK: Shared Instance
    class func sharedInstance() -> SpoonacularAPIManager {
        struct Singleton {
            static var sharedInstance = SpoonacularAPIManager()
        }
        return Singleton.sharedInstance
    }
    
    //MARK: API Methods
    
    func findRecipes(_ ingredientsList:String, _ completionHandler: @escaping(_ result:[TheRecipe]?,_ error:NSError?) -> Void) {
        
        /* 1. Set the parameters - the required once */
        
        let methodParameters = [Constants.ParameterKeys.FillIngredients : Constants.ParameterValues.FillIngredients, Constants.ParameterKeys.Ingredients : ingredientsList,Constants.ParameterKeys.LimitLicense : Constants.ParameterValues.LimitLicense,Constants.ParameterKeys.Number : Constants.ParameterValues.Number, Constants.ParameterKeys.Ranking:Constants.ParameterValues.Ranking] as [String : Any]
        
        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: urlFromParameters(methodParameters as [String:AnyObject], withPathExtension: "/findByIngredients"))
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("ACvWBPBcf2mshImXqGrthiSO9p2dp1B1SUajsnc62mal2cISWC", forHTTPHeaderField: "X-Mashape-Key")
        /* 4. Make the request */
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            //if an error occurs, print it
            func displayError(_ error: String){
                print(error)
            }
            
            //was there an error?
            guard (error == nil) else{
                displayError("There was an error with your request: \(error!)")
                completionHandler(nil,error! as NSError?)
                return
            }
            //Did we get a successful 2xx response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                
                return
            }
            
            //was there any data returned?
            guard let data = data else{
                displayError("No data was returned by the request")
                return
            }
            
            /* 5. Parse the data */
            let parsedResult:[[String:AnyObject]]
            do{
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:AnyObject]]
            }catch{
                displayError("Unable to parse the data as JSON")
                return
            }
            
            var arrayOfRecipes = [TheRecipe]()
            
            for recipe in parsedResult {
                
                guard let recipeId = recipe["id"] as? Int else {
                    print("Cannot find key id in \(parsedResult)")
                    return
                }
                guard let recipeName = recipe["title"] as? String else {
                    print("Cannot find key title in \(parsedResult)")
                    return
                }
                guard let urlString = recipe["image"] as? String else {
                    print("Cannot find key image in \(parsedResult)")
                    return
                }
                let recipe = TheRecipe(id: recipeId, title: recipeName, imageURL: urlString, details: nil)
                arrayOfRecipes.append(recipe)
                
            }
            
            completionHandler(arrayOfRecipes,nil)
            
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    func showDetailedRecipe(_ id:Int, _ completionHandler: @escaping(_ result:RecipeDetail?,_ error:NSError?) -> Void){
        
        /* 1. Set the parameters - the required once */
        
        let methodParameters = [Constants.ParameterKeys.IncludeNutrition:false] as [String : Any]
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: urlFromParameters(methodParameters as [String:AnyObject], withPathExtension: "/\(id)/information"))
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("ACvWBPBcf2mshImXqGrthiSO9p2dp1B1SUajsnc62mal2cISWC", forHTTPHeaderField: "X-Mashape-Key")
        
        /* 4. Make the request */
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            //if an error occurs, print it and re-enable the UI
            func displayError(_ error: String){
                print(error)
            }
            
            //was there an error?
            guard (error == nil) else{
                displayError("There was an error with your request: \(String(describing: error))")
                completionHandler(nil, error! as NSError?)
                return
            }
            //Did we get a successful 2xx response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                //completionHandler(nil, error! as NSError?)
                return
            }
            
            //was there any data returned?
            guard let data = data else{
                displayError("No data was returned by the request")
                return
            }
            
            /* 5. Parse the data */
            let parsedResult:[String:AnyObject]
            do{
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            }catch{
                displayError("Unable to parse the data as JSON")
                return
            }
            
            var listOfIngr = [String]()
            
            if let ingrArray = parsedResult["extendedIngredients"] as? [[String:AnyObject]]{
                for ingr in ingrArray {
                    guard let fullIngr = ingr["originalString"] as? String else{
                        print("Cannot find key originalString in \(ingr)")
                        return
                    }
                    listOfIngr.append(fullIngr)
                }
            }
            guard let readyIn = parsedResult["readyInMinutes"] as? Int else {
                print("Cannot find key readyInMinutes in \(parsedResult)")
                return
            }
            guard let instructions = parsedResult["instructions"] as? String else {
                print("Cannot find key instructions in \(parsedResult)")
                return
            }
  
            let detailedRecipe = RecipeDetail(ingredients: listOfIngr, readyInMinutes: readyIn, instructions: instructions)
            
            completionHandler(detailedRecipe, nil)
            
            
        }
        
        /* 7. Start the request */
        task.resume()
        
        
    }
    
    //MARK: Helper methods
    
    func urlFromParameters(_ parameters: [String:AnyObject],withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Spoonacular.ApiScheme
        components.host = Constants.Spoonacular.ApiHost
        components.path = Constants.Spoonacular.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    
    
}
