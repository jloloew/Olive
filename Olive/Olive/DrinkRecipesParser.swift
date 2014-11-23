//
//  DrinkRecipesParser.swift
//  Olive
//
//  Created by Justin Loew on 11/23/14.
//  Copyright (c) 2014 edu.illinois. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DrinkRecipesParser {
	
	let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
	
	func hitIt() {
		// make sure we only parse and add data once
		let defaults = NSUserDefaults.standardUserDefaults()
		if defaults.boolForKey("parsedRecipesOnceOnly") {
			return
		}
		
		
		// open the file for parsing
		let recipesFilePath = NSBundle.mainBundle().pathForResource("drinkrecipes", ofType: "txt")
		let error = NSErrorPointer()
		let recipes: String! = String(contentsOfFile: recipesFilePath!, encoding: NSUTF8StringEncoding, error: error)
		if error != nil {
			println("\(__FUNCTION__) \(__LINE__) \(error)")
			return
		}
		
		// parse the string
		var currentDrink: Drink! = nil
		var currentIngredient: Ingredient! = nil
        var currentIngredients : NSMutableSet = NSMutableSet()
		var inIngredient: Bool = false
		
		// break it up into lines
		let lines = recipes.componentsSeparatedByString("\n")
		for lineNum in 0..<lines.count {
			var line = lines[lineNum] as NSString
			// remove comments
			let poundLoc = line.rangeOfString("#").location
			if poundLoc != NSNotFound {
				line = line.substringToIndex(poundLoc)
			}
			
			// trim whitespace
			line = line.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
			
			// get the value of the rest of the line
			let colonLoc = line.rangeOfString(":").location
			var key = line
			var value = "" as NSString
			if colonLoc != NSNotFound {
				key = line.substringToIndex(colonLoc)
				value = line.substringFromIndex(colonLoc + 1)
			}
			
			switch key {
			case "":
				break
			case "NewDrink":
				currentDrink = newDrink()
			case "name":
				if inIngredient {
					currentIngredient.name = value
				} else {
					currentDrink.name = value
				}
			case "icon":
				if inIngredient {
					//TODO: add icons to ingredients
				} else {
                    println(value)
                    var image = UIImage(named: value)
                    if(image != nil){
                        currentDrink.icon = UIImagePNGRepresentation(image)
                    } else {
                        currentDrink.icon = UIImagePNGRepresentation(UIImage(named: "GinAndTonic.jpg"))
                    }
				}
			case "ingredients":
				inIngredient = true
			case "Ingredient":
                inIngredient = true
				currentIngredient = newIngredient()
			case "importance":
				currentIngredient.importance = value.floatValue
			case "quantityRequired":
				currentIngredient.quantityRequired = value.floatValue
			case "unit":
				break
				//TODO: add units to ingredients
			case "EndIngredient":
				inIngredient = false
                currentIngredients.addObject(currentIngredient)
                save()
				//TODO: save the ingredient
				currentIngredient = nil
			case "EndDrink":
				//TODO: save the drink
                currentDrink.ingredients = currentIngredients.copy() as NSSet
				currentDrink = nil
			default:
				println("Unknown key while parsing recipes file: \(key)")
			}
		}
		
		println("Successfully parsed recipes file!")
		
		defaults.setBool(true, forKey: "parsedRecipesOnceOnly")
        save()
        
	}
	
	func newIngredient() -> Ingredient {
		let entityDescription = NSEntityDescription.entityForName("Ingredient", inManagedObjectContext: self.managedObjectContext)
		return Ingredient(entity: entityDescription!, insertIntoManagedObjectContext: self.managedObjectContext)
	}
	
	func newDrink() -> Drink {
		let entityDescription = NSEntityDescription.entityForName("Drink", inManagedObjectContext: self.managedObjectContext)
		return Drink(entity: entityDescription!, insertIntoManagedObjectContext: self.managedObjectContext)
	}
	
	func save() {
		let error = NSErrorPointer()
		managedObjectContext.save(error)
		if error != nil {
			println("\(__FUNCTION__) \(__LINE__) \(error)")
		}
	}
	
	func imageNamed(name: String) -> NSData {
		let image = UIImage(named: name)
		return image != nil ? UIImagePNGRepresentation(image) : NSData()
	}
	
}
