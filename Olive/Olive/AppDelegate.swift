//
//  AppDelegate.swift
//  Olive
//
//  Created by Bri Chapman on 11/22/14.
//  Copyright (c) 2014 edu.illinois. All rights reserved.
//

import UIKit
import CoreData
import Dispatch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
//			sleep(1) // fuck it ship it
//			DrinkRecipesParser().hitIt() // add coredata filler
//            //notification
//		}
		
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Olive.Olive" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Olive", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Olive.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
			var dict = [NSObject : AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
			error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
	
	// MARK: - CoreData helper stuff
	
	
	
	func fetchIngredientsPosessed() -> [Ingredient] {
		let fetchRequest = NSFetchRequest(entityName: "Ingredient")
		let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
		let error = NSErrorPointer()
		frc.performFetch(error)
		if error != nil {
			println("\(__FUNCTION__) \(__LINE__) \(error)")
			return [Ingredient]()
		}
		
		// filter out the ingredients we don't have
		var ingredients = NSMutableSet(array: frc.fetchedObjects! as! [Ingredient])
		ingredients.enumerateObjectsUsingBlock { (ingredient, shouldStopPtr) -> Void in
			if let ing = ingredient as? Ingredient {
				if ing.quantityPosessed.floatValue < 0.01 {
					ingredients.removeObject(ing)
				}
			}
		}
		
		return ingredients.allObjects as! [Ingredient]
	}
	
	func fetchAllIngredients() -> [Ingredient] {
		let fetchRequest = NSFetchRequest(entityName: "Ingredient")
		let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
		let error = NSErrorPointer()
		frc.performFetch(error)
		if error != nil {
			println("\(__FUNCTION__) \(__LINE__) \(error)")
			return [Ingredient]()
		}
		
		return frc.fetchedObjects! as! [Ingredient]
	}
}

func matchAccuracyForDrink(drink: Drink) -> Float {
		// get the total value of the importances all the ingredients needed
		var sumNeeded = Float(0.0)
		var sumPosessed = Float(0.0)
		let ourIngredients = (UIApplication.sharedApplication().delegate as! AppDelegate).fetchIngredientsPosessed()
		for i in drink.ingredients {
			let ingredient = i as! Ingredient
			
			sumNeeded += ingredient.importance.floatValue
			
			// see if we possess this ingredient
			for j in ourIngredients {
				if j.name == ingredient.name {
					sumPosessed += j.importance.floatValue

				}
			}
		}
    if(sumNeeded != 0){
        return sumPosessed/sumNeeded
    } else {
        return 0
    }
//        var float = sumPosessed / sumNeeded
//        println("\(float)")
//		return float

	}
	
//	return sumPosessed / sumNeeded
//}

//func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
//	return lhs.name == rhs.name
//}
