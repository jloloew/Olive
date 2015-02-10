//
//  IngredientsTableViewController.swift
//  Olive
//
//  Created by Justin Loew on 11/22/14.
//  Copyright (c) 2014 edu.illinois. All rights reserved.
//

import UIKit
import CoreData

class IngredientsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
	
	var fetchedResultsController = NSFetchedResultsController()
	let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
	
//	@IBOutlet var searchDisplayController: UISearchDisplayController!
	@IBOutlet var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
		fuckItShipIt_generateData()
		
		let fetchRequest = NSFetchRequest(entityName: "Ingredient")
		let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		fetchedResultsController.delegate = self
		
		let error = NSErrorPointer()
		fetchedResultsController.performFetch(error)
		if error != nil {
			println("\(__FUNCTION__) \(__LINE__) \(error)")
		}
		
		self.tableView.reloadData()
    }
	
	func fuckItShipIt_generateData() {
		let defaults = NSUserDefaults.standardUserDefaults()
		if defaults.boolForKey("fuck it ship it data") {
			return
		}
		
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		let entityDescription = NSEntityDescription.entityForName("Ingredient", inManagedObjectContext: self.managedObjectContext)
		var newIngredient: Ingredient
		
		// vodka
		newIngredient = Ingredient(entity: entityDescription!, insertIntoManagedObjectContext: self.managedObjectContext)
		newIngredient.quantityPosessed = 3.6
		newIngredient.quantityRequired = 1.8
		newIngredient.name = "Vodka"
		newIngredient.importance = 1.0
		
		// tonic
		newIngredient = Ingredient(entity: entityDescription!, insertIntoManagedObjectContext: self.managedObjectContext)
		newIngredient.quantityPosessed = 7.2
		newIngredient.quantityRequired = 3.6
		newIngredient.name = "Tonic"
		newIngredient.importance = 1.0
		
		// lime
		newIngredient = Ingredient(entity: entityDescription!, insertIntoManagedObjectContext: self.managedObjectContext)
		newIngredient.quantityPosessed = 2.0
		newIngredient.quantityRequired = 1.0
		newIngredient.name = "Lime"
		newIngredient.importance = 0.33
		
		// save the new ingredients
		let error = NSErrorPointer()
		managedObjectContext.save(error)
		if error != nil {
			println("\(__FUNCTION__) \(__LINE__) \(error)")
		}
		
		defaults.setBool(true, forKey: "fuck it ship it data")
		
		self.tableView.reloadData()
	}
	
    // MARK: - Table view data source
	
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let retVal = (UIApplication.sharedApplication().delegate as! AppDelegate).fetchAllIngredients().count
		return retVal
    }

     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IngredientCell", forIndexPath: indexPath) as! UITableViewCell
		
		let ingredient = (UIApplication.sharedApplication().delegate as! AppDelegate).fetchAllIngredients()[indexPath.item] as Ingredient
        cell.textLabel?.text = ingredient.name
		cell.detailTextLabel?.text = "\(ingredient.quantityPosessed) oz."
		
		// add checkmark if necessary
		if ingredient.quantityPosessed.floatValue >= 0.1 {
			cell.accessoryType = .Checkmark
		} else {
			cell.accessoryType = .None
		}
		
        return cell
    }
	
//	func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
//		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		/*
		let moc = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
		let fetchRequest = NSFetchRequest(entityName: "Ingredient")
		let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		let error = NSErrorPointer()
		fetchedResultsController.performFetch(error)
		if error != nil {
			println("\(__FUNCTION__) \(__LINE__) \(error)")
			return
		}
		
		let ingredient = frc.fetchedObjects?[indexPath.row] as Ingredient
		*/
		
		let cell: UITableViewCell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
		if cell.accessoryType  == .Checkmark {
			cell.accessoryType = .None
		} else  {
			cell.accessoryType = .Checkmark
		}
//		
//		let ingredient = (UIApplication.sharedApplication().delegate as AppDelegate).fetchAllIngredients()[indexPath.row]
//		
//		// toggle
//		if ingredient.quantityPosessed.floatValue >= 0.1 {
//			ingredient.quantityPosessed = 0.0
//		} else {
//			ingredient.quantityPosessed = 2.0
//		}
//		cell.detailTextLabel?.text = "\(ingredient.quantityPosessed) oz."
//		
//		// save change
//		let error = NSErrorPointer()
//		(UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext?.save(error)
//		if error != nil {
//			println("\(__FUNCTION__) \(__LINE__) \(error)")
//		}
//		
//		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
//	func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//		let cell: UITableViewCell = tableView(tableView, cellForRowAtIndexPath: indexPath)
//		cell.accessoryView
//		
//		return indexPath
//	}
	
	
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */
	
    // Override to support editing the table view.
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
			let entityDescription = NSEntityDescription.entityForName("Ingredient", inManagedObjectContext: self.managedObjectContext)
			var newIngredient = Ingredient(entity: entityDescription!, insertIntoManagedObjectContext: self.managedObjectContext)
			newIngredient.quantityPosessed = 0
			newIngredient.quantityRequired = 0
			newIngredient.name = ""
			newIngredient.importance = 0.5
			
			// save the new ingredient
			let error = NSErrorPointer()
			managedObjectContext.save(error)
			if error != nil {
				println("\(__FUNCTION__) \(__LINE__) \(error)")
			}
        }    
    }
	
	/*
    // Override to support rearranging the table view.
     func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
		
    }
	*/
	
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
	
    /*
    // MARK: - Navigation
	
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
	
}
