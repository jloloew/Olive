//
//  Ingredient.swift
//  Olive
//
//  Created by Justin Loew on 11/22/14.
//  Copyright (c) 2014 edu.illinois. All rights reserved.
//

import Foundation
import CoreData

@objc(Ingredient)
class Ingredient: NSManagedObject {

    @NSManaged var importance: NSNumber
    @NSManaged var name: String
    @NSManaged var quantityPosessed: NSNumber
    @NSManaged var quantityRequired: NSNumber
    @NSManaged var drink: Drink

}

func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
	return lhs.name == rhs.name
}
