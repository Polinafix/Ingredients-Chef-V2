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
    func loadRecipes(){
        
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
                
            }else {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return recipesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RecipeCell
    
        // Configure the cell
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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
