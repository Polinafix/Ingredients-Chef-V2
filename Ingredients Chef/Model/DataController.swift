//
//  DataController.swift
//  Ingredients Chef
//
//  Created by Polina Fiksson on 26/03/2018.
//  Copyright © 2018 PolinaFiksson. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    //hold a persistant container instance
    let persistentContainer:NSPersistentContainer
    
    //convenience property to access the context
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    //Load the persistant store
    func load(completion:(() -> Void)? = nil){
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            //if there is an error loading the store
            guard error == nil else{
                fatalError("MY ERROR:\(error!.localizedDescription)")
            }
            //we may want to pass in a function to get called after loading the store
            completion?()
        }
    }
}
