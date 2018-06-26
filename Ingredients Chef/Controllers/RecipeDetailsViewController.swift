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

    var recipeId:Int = 0
    var recipe:TheRecipe?
    var theIngredients = [String]()
    var imageUrl:String?
    var dataController:DataController!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        favButton.addTarget(self, action:#selector(self.tapped(sender:)), for: .touchUpInside)
        loadDetailedRecipe()
        loadImage()
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
            print("hello")
            addFavorite()

        }
    }

    //MARK: Loading the recipe details from spoonacular server
    func loadDetailedRecipe(){
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

    //MARK: Loading the image
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

        let recipe  = Recipe(context: managedContext)
        recipe.id = Int32(recipeId)
        recipe.title = self.recipe?.title
        recipe.data = self.recipe?.data
        recipe.details = detail
        try? dataController.viewContext.save()

//        let detailEntity = NSEntityDescription.entity(forEntityName: "Detail", in: managedContext)
//        let detail = NSManagedObject(entity: detailEntity!, insertInto: managedContext)
//        detail.setValue(theIngredients, forKey: "ingredientsList")
//        detail.setValue(instructionsTextView.text, forKey: "instructions")
//        detail.setValue(self.recipe?.details?.readyInMinutes, forKey: "readyInMinutes")

//        let recipeEntity = NSEntityDescription.entity(forEntityName: "Recipe", in: managedContext)
//        let recipe = NSManagedObject(entity: recipeEntity!, insertInto: managedContext)
//        recipe.setValue(recipeId, forKey: "id")
//        recipe.setValue(self.recipe?.title, forKey: "title")
//        recipe.setValue(self.recipe?.data, forKey: "data")
//        recipe.setValue(detail, forKey: "details")

    }

//     func addToFavorites() {
//
//        let favRecipe = Recipe(context: <#T##NSManagedObjectContext#>)
//
//
//
//        //let favRecipe = TheRecipe(id: recipeId, title: (recipe?.title)!, imageURL: "", details:)
//
//        if let currentArray = array,let currentMinutes = minutes, let instructions = instructionsView.text {
//
//            let details = Details(currentArray, currentMinutes, instructions, context: managedContext)
//
//            _ = Recipe(recipeId, self.recipe?.title, self.recipe?.data, details, context: managedContext)
//
//            favButton.setImage(UIImage(named:"redheart"), for: .normal)
//
//            favButton.isEnabled = false
//            CoreDataStack.saveContext(managedContext)
//
//
//        }else {
//            displayAlert(title: "Problem", message: "Unable to save the recipe to favorites")
//        }
//        //show the alert message
//        displayAlert(title: "Success!", message: "This recipe has just been added to your favorites!")
//
//    }

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


