//
//  IngredientsTableViewController.swift
//  Ingredients Chef
//
//  Created by Polina Fiksson on 26/03/2018.
//  Copyright © 2018 PolinaFiksson. All rights reserved.
//

import UIKit
import CoreData

class IngredientsTableViewController: UITableViewController {
    
    var dataController:DataController!
    var ingredientsList:[Ingredient] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchRequest:NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            ingredientsList = result
            tableView.reloadData()
        }else {
            print("Nothing")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addIngredient(_ sender: UIBarButtonItem) {
        presentNewIngredientAlert()
    }
    
    func presentNewIngredientAlert() {
        let alert = UIAlertController(title: "New Ingredient", message: "", preferredStyle: .alert)
        
        // Create actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            if let name = alert.textFields?.first?.text {
                self?.addIngredient(name: name)
                
            }
        }
        saveAction.isEnabled = false
        
        // Add a text field
        alert.addTextField { textField in
            textField.placeholder = "Ingredient"
            NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: textField, queue: .main) { notif in
                if let text = textField.text, !text.isEmpty {
                    saveAction.isEnabled = true
                } else {
                    saveAction.isEnabled = false
                }
            }
        }
       
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    func addIngredient(name: String) {
// create a new Ingrediet associated with the context
        let ingredient = Ingredient(context: dataController.viewContext)
        ingredient.name = name
        ingredient.checked = true
// ask the context to save the ingredient to the persistent store
        try? dataController.viewContext.save()
        
        let fetchRequest:NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            ingredientsList = result
            tableView.reloadData()
        }else {
            print("Nothing")
        }
        
    }
    
    /// Deletes the notebook at the specified index path
    func deleteIngredient(at indexPath: IndexPath) {
        //15.1 get a reference to the notebook to delete
        let ingredientToDelete = ingredient(at: indexPath)
        //15.2 call the context's delete function passing in that notebook
        dataController.viewContext.delete(ingredientToDelete)
        //15.3 try saving the change to the persistent store
        try? dataController.viewContext.save()
        ingredientsList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func ingredient(at indexPath: IndexPath) -> Ingredient {
        return ingredientsList[indexPath.row]
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ingredientsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        
        let item = ingredientsList[indexPath.row]
        cell.textLabel?.text = item.name
        cell.textLabel?.font = UIFont(name: "Palatino", size: 19)
        configureCheckmark(for: cell, with: item)
        
        return cell

        
    }
    //Helpers
    func configureCheckmark(for cell: UITableViewCell,
                            with item:Ingredient) {
        
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
   
    
    
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteIngredient(at: indexPath)
        default: () // Unsupported
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
