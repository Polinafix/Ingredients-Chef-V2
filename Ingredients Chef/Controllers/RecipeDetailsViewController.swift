//
//  RecipeDetailsViewController.swift
//  Ingredients Chef
//
//  Created by Polina Fiksson on 05/04/2018.
//  Copyright © 2018 PolinaFiksson. All rights reserved.
//

import UIKit
import CoreData


class RecipeDetailsViewController: UIViewController {

    @IBOutlet weak var favButton: DOFavoriteButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var prepTime: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var instructionsTextView: UITextView!

    var recipeId: Int = 0
    var recipe: TheRecipe?
    var savedRecipe: Recipe?
    var theIngredients = [String]()
    var imageUrl: String?
    var dataController:DataController!
    var isFavoriteDetail:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        favButton.addTarget(self, action:#selector(self.tapped(sender:)), for: .touchUpInside)
        if isFavoriteDetail {
            loadSavedRecipe()
        } else {
            loadImage()
            loadDetailedRecipe()
        }
    }

    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    //MARK: Helper method for the favorite button
    @objc func tapped(sender: DOFavoriteButton) {
        if sender.isSelected {
            sender.deselect()
        } else {
            sender.select()
            addFavorite()
        }
    }

    fileprivate func loadSavedRecipe() {
        favButton.isHidden = true
        activityIndicator.isHidden = true
        self.tableView.reloadData()
        theIngredients = savedRecipe?.details?.ingredientsList as! [String]
        instructionsTextView.text = savedRecipe?.details?.instructions
        prepTime.text = "\(savedRecipe?.details?.readyInMinutes ?? 0) min"
        recipeImage.image = UIImage(data: (savedRecipe?.data)! as Data)
        isFavoriteDetail = false
    }

    //MARK: Loading the recipe details from spoonacular server
    fileprivate func loadDetailedRecipe(){
        SpoonacularAPIManager.sharedInstance().showDetailedRecipe(recipeId) { (result, error) in
            if error ==  nil{
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                    self.recipe?.details = result
                    self.theIngredients = (result?.ingredients)! as [String]
                    self.instructionsTextView.text = result?.instructions
                    self.prepTime.text = "\(result?.readyInMinutes ?? 0) min"
                    self.tableView.reloadData()
                }
            } else {
                self.displayErrorAlert(title: "Error", message:"\(error!.localizedDescription)")
            }
        }
    }

    func loadImage(){
        SpoonacularAPIManager.sharedInstance().fromUrlToData(imageUrl!) { (imageData, error) in
            if let data = imageData{
                DispatchQueue.main.async {
                    self.recipe?.data = data
                    self.recipeImage.image = UIImage(data: self.recipe!.data! as Data)
                }
            } else {
                print("Data error: \(String(describing: error))")
                //self.displayAlert(title: "Error", message: error)
            }
        }
    }

    func addFavorite() {
        let managedContext = dataController.viewContext
        let detail = Detail(context: managedContext)
        detail.ingredientsList = theIngredients as NSObject
        detail.instructions = instructionsTextView.text
        if let mins = self.recipe?.details?.readyInMinutes {
            detail.readyInMinutes = Int32(mins)
        }

        let recipe = Recipe(context: managedContext)
        recipe.id = Int32(recipeId)
        recipe.title = self.recipe?.title
        recipe.data = self.recipe?.data
        recipe.details = detail
        try? dataController.viewContext.save()
    }

    func deleteFromFavorite() {
        let managedContext = dataController.viewContext
        let recipe = Recipe(context: managedContext)
        dataController.viewContext.delete(recipe)
        
    }

    //MARK: Helpers
    func displayErrorAlert(title:String, message:String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction!) in self.hideActivityIndicator()}))
        present(alert, animated: true, completion: nil)
    }
    
    func hideActivityIndicator(){
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    fileprivate func configureTableView() {
        tableView.separatorColor = UIColor(red:0.33, green:0.36, blue:0.43, alpha:1.0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
}

extension RecipeDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theIngredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        cell.textLabel?.text = theIngredients[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Palatino", size: 17)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        return cell
    }
}


