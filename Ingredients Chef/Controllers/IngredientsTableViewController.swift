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
    
    var button = UIButton()
    var dataController:DataController!
    var ingredientList: String = ""
    var checkedIngredients:[String] = []
    var fetchedResultsController:NSFetchedResultsController<Ingredient>!
    

    fileprivate func buttonOnOrOff() {
        if fetchedResultsController.sections?[0].numberOfObjects == 0 {
            button.isHidden = true
            starterMessage(message: " Please add your Ingredients to start searching for amazing recipes! ", viewController: self,empty:true)
        }else{
            button.isHidden = false
            starterMessage(message: "", viewController: self,empty:false)
        }
    }
    
    fileprivate func setupFetchedResultsController() {
        
        let fetchRequest:NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("Fetch could not be performed: \(error.localizedDescription)")
        }
        buttonOnOrOff()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create a floating button
        createButton(160)
        setupFetchedResultsController()
        NotificationCenter.default.addObserver(self, selector: #selector(IngredientsTableViewController.orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupFetchedResultsController()
        NotificationCenter.default.addObserver(self, selector: #selector(IngredientsTableViewController.orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        fetchedResultsController = nil
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
        buttonOnOrOff()
        
    }
    
    /// Deletes the notebook at the specified index path
    func deleteIngredient(at indexPath: IndexPath) {
        let ingredientToDelete = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(ingredientToDelete)
        try? dataController.viewContext.save()
        buttonOnOrOff()
        
    }
    //MARK: - Helper methods
    func createButton(_ size:CGFloat){
        button = UIButton(frame:CGRect(origin: CGPoint(x:self.view.frame.width/1.5, y: self.view.frame.size.height - size), size: CGSize(width: 80, height: 80)))
        let image = UIImage(named: "arrow")
        button.setImage(image, for: .normal)
        self.navigationController?.view.addSubview(button)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
    }
    
    @objc func orientationChanged()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
        {
            createButton(160)
        }
    }
    
    @objc func buttonAction(sender:UIButton) {
        performSegue(withIdentifier: "showRecipes", sender: self)
        
    }
    
    func starterMessage(message:String, viewController:UITableViewController,empty:Bool) {
        let messageLabel = UILabel(frame: CGRect(x:0,y:0,width:viewController.view.bounds.size.width,height: viewController.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.gray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 20)
        messageLabel.sizeToFit()
        if empty {
            viewController.tableView.backgroundView = messageLabel;
            viewController.tableView.separatorStyle = .none;
        } else {
            viewController.tableView.backgroundView = UIView();
            viewController.tableView.separatorStyle = .singleLine
            viewController.tableView.tableFooterView?.isHidden = true
            tableView.tableFooterView = UIView()
            
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell,
                            with item:Ingredient) {
        
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        let item = fetchedResultsController.object(at: indexPath)
        //let item = ingredientsList[indexPath.row]
        cell.textLabel?.text = item.name
        cell.textLabel?.font = UIFont(name: "Palatino", size: 19)
        configureCheckmark(for: cell, with: item)
        
        return cell
     
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at:  indexPath) {
            
            let item = fetchedResultsController.object(at: indexPath)
            item.checked = !item.checked
            configureCheckmark(for: cell, with:item)
            try! dataController.viewContext.save()
            //CoreDataStack.saveContext(managedContext)
            
            
            if item.checked {
                ingredientList = item.name!
                
            }
            print(ingredientList)
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteIngredient(at: indexPath)
        default: () // Unsupported
        }
    }
 

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipes"  {
            let navController = segue.destination as! UINavigationController
            let foundController = navController.topViewController as! FoundRecipesViewController
            //create a separate array of the checked ingredients
            
            for ingr in fetchedResultsController.fetchedObjects! {
                if ingr.checked {
                    checkedIngredients.append(ingr.name!)
                }
            }
            //convert array into string
            let ingredientList: String = checkedIngredients.joined(separator: ",")
            foundController.chosenIngredients = ingredientList
        }
     }
}

extension IngredientsTableViewController:NSFetchedResultsControllerDelegate {
    
    //when the fetched object has been changed, tableview should update the effected rows
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            //newIndexPathParameter contains the index Path of the row to insert
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            //indexPath contains the index path of teh row to delete
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        default:
            break
        }
    }
    
    //These methods mark the beginning and end of a batch of updates and are used to make the corresponding UITableView calls.
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
