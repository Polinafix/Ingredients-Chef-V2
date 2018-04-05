//
//  RecipeDetailsViewController.swift
//  Ingredients Chef
//
//  Created by Polina Fiksson on 05/04/2018.
//  Copyright © 2018 PolinaFiksson. All rights reserved.
//

import UIKit




class RecipeDetailsViewController: UIViewController {

    @IBOutlet weak var favButton: DOFavoriteButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favButton.addTarget(self, action:#selector(self.tapped(sender:)), for: .touchUpInside)

        
    }
    //MARK: Helper method for the favorite button
    @objc func tapped(sender: DOFavoriteButton) {
        if sender.isSelected {
            // deselect
            sender.deselect()
        } else {
            // select with animation
            sender.select()
        }
    }

   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


