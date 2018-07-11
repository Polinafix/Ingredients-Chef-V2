//
//  FavoritesTableViewController.swift
//  Ingredients Chef
//
//  Created by Polina Fiksson on 6/26/18.
//  Copyright © 2018 PolinaFiksson. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {

    var fetchedResultsController:NSFetchedResultsController<Recipe>!
    var dataController:DataController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchRecipes()
        tableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        fetchedResultsController = nil
    }

    fileprivate func fetchRecipes() {
        let fetchRequest:NSFetchRequest<Recipe> = Recipe.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Fetch could not be performed: \(error.localizedDescription)")
        }
    }


    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as? FavoriteCell
        let theRecipe = fetchedResultsController.object(at: indexPath)
        cell?.recipeName.text = theRecipe.title
        let cookingTime = theRecipe.details?.readyInMinutes
        cell?.timeToCook.text = "\(cookingTime!) min"
        cell?.recipeImage.image = UIImage(data: theRecipe.data as! Data)
        cell?.recipeName.numberOfLines = 0
        cell?.recipeName.lineBreakMode = NSLineBreakMode.byWordWrapping
        return cell!
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(at: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenRecipe = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "showFavDetail", sender: chosenRecipe)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showFavDetail") {
            let navigationController = segue.destination as! UINavigationController
            let recipeVController = navigationController.topViewController as! RecipeDetailsViewController
            recipeVController.savedRecipe = sender as? Recipe
            recipeVController.isFavoriteDetail = true
        }
    }

    func deleteNote(at indexPath: IndexPath) {
        let recipeToDelete = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(recipeToDelete)
        try? dataController.viewContext.save()
    }
}

extension FavoritesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
