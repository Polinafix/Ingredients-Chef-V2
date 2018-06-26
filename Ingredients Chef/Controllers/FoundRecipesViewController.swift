//
//  FoundRecipesViewController.swift
//  Ingredients Chef
//
//  Created by Polina Fiksson on 04/04/2018.
//  Copyright © 2018 PolinaFiksson. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CollectionCell"

class FoundRecipesViewController: UICollectionViewController {
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    var chosenIngredients:String = ""
    var recipesArray = [TheRecipe]()
    var dataController:DataController!

    fileprivate func editCollectionLayout() {
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 2.0
        collectionLayout.minimumInteritemSpacing = space
        collectionLayout.minimumLineSpacing = space
        collectionLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRecipes()
        editCollectionLayout()
    }
    
    @IBAction func cancelClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    //MARK: Networking
    func loadRecipes() {

        SpoonacularAPIManager.sharedInstance().findRecipes(chosenIngredients) { (results, error) in
            guard error == nil else {
                self.showAlert(title: "Error", message: "\(error!.localizedDescription)")
                return
            }
            if let theResults = results {
                self.recipesArray = theResults
                print("\(self.recipesArray.count) recipes fetched")
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            } else {
                self.showAlert(title: "No Recipes Found", message: "No recipes found for these ingredients")
                print("no recipes for these ingredients")
            }
        }
    }
    
    func showAlert(title:String, message:String?) {
        if let message = message {
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetail") {
            let indexPaths: [Any]? = collectionView?.indexPathsForSelectedItems
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! RecipeDetailsViewController
            
            let indexPath = indexPaths?[0] as? IndexPath ?? IndexPath()
            let recipe = recipesArray[indexPath.row]
            controller.recipeId = recipe.id!
            controller.imageUrl = recipe.imageURL
            controller.recipe = recipe
            controller.dataController = dataController
            collectionView?.deselectItem(at: indexPath, animated: false)
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RecipeCell
        let recipe = recipesArray[indexPath.row]
        cell?.imageView.image = UIImage(named:"default")
        cell?.activityIndicator.startAnimating()
        
        if recipe.data != nil {
            DispatchQueue.main.async {
                cell?.activityIndicator.stopAnimating()
                cell?.activityIndicator.hidesWhenStopped = true
            }
            cell?.imageView.image = UIImage(data: recipe.data!)
        } else {
            SpoonacularAPIManager.sharedInstance().fromUrlToData(recipe.imageURL, { (data, error) in
                if let returnedData = data {
                    DispatchQueue.main.async {
                        recipe.data = returnedData
                        cell?.imageView.image = UIImage(data: recipe.data!)
                        cell?.recipeName.text = recipe.title
                        cell?.activityIndicator.stopAnimating()
                        cell?.activityIndicator.hidesWhenStopped = true
                    }
                } else {
                    print("Data error: \(String(describing: error))")
                }
            })
        }
        return cell!
    }
}
