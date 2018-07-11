# Ingredients Chef

The Ingredients Chef is an application that allows you to search for recipes that include ingredients that you have in store!

### Description

Network API used in the application is [Spoonacular](https://spoonacular.com/).

1) When opening the application for the first time the user is prompted to add ingredients.
    User needs to click on the (+) button to add ingredients. Keep the checkmark only on those ingredients that you would like to have included in the recipe.
As soon as at least one ingredient is added, the arrow button for moving to another view with suggested recipes appears on the screen.
Ingredients can be deleted from the list.


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   ![img1](https://media.giphy.com/media/QeRmu3Gb7Im1mvY4dm/giphy.gif)

2)  The next screen will show a collection view of the found recipes, that are downloaded from the network.
 While results are loading, a placeholder image and activity indicator are being shown.
  Clicking on any of the cells will take the user to the next screen with the details for the recipe.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;![img2](https://i.imgur.com/X1TSAII.png)

3) The view contains information about the cooking time, ingredients and detailed instructions for cooking and a larger picture. 
Clicking on the heart button will save the current recipe to the core data and will be shown in the Favorites. If the current recipe already exists in the favourites list, a red heart button will be shown and will be disabled.
Once the user clicks on the heart button the alert message is shown, stating that the recipe has been saved to the favorites. The image of the button changes to a red heart and becomes disabled.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;![img3](https://i.imgur.com/nVcHcvQ.gif)

4) Favorites screen contains a table of recipes that were previously liked by the user. The information on this screen and the following (detailed screen) is persistent and can be deleted.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;![img3](https://i.imgur.com/a4obSKb.png)

The app displays an alert view if error occurs while downloading the info from the Web.

### During development of this app the following areas were covered:
##### 1) UI features

* More than one view controller
* Table and collection views
* Tab View
* Navigation and modal presentation

##### 2)Networking
* The app incorporates data from a networked source
* Feedback around network activity is provided
* Networking code is encapsulated in a class to reduce detail in View Controllers

##### 3)Persistence

* The app incorporates data that needs to be persisted between runs of the app
* An object graph that can be persisted in Core Data is included
* The Core Data Stack is managed outside of view controllers, in a separate Core Data Stack manager class

### Todos

 - Work more on thr logic of the interface
 - .....

### License
This project is licensed under the MIT License - see the [MIT](https://choosealicense.com/licenses/mit/) for details

