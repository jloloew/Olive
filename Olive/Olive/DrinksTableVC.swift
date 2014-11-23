//
//  DrinksTableViewController.swift
//  Olive
//
//  Created by Justin Loew on 11/22/14.
//  Copyright (c) 2014 edu.illinois. All rights reserved.
//

import UIKit
import CoreData

class DrinksTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
	
	var fetchedResultsController = NSFetchedResultsController()
	let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let fetchRequest = NSFetchRequest(entityName: "Drink")
		let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
		fetchedResultsController.delegate = self
		
		let error = NSErrorPointer()
		fetchedResultsController.performFetch(error)
		if error != nil {
			println("\(__FUNCTION__) \(__LINE__) \(error)")
		}
    }
	
	func matchAccuracyForDrink(drink: Drink) -> Float {
		
	}

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("drink", forIndexPath: indexPath) as UITableViewCell
		
		let drink = fetchedResultsController.fetchedObjects?[indexPath.item] as Drink
		cell.textLabel.text = drink.name
		cell.detailTextLabel?.text = "\(matchAccuracyForDrink(drink))% match"
		
        return cell
    }
	
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
		let drink = fetchedResultsController.fetchedObjects?[indexPath.row] as Drink
		return drink.userAdded.boolValue
    }
	
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */
	
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
