//
//  Drink.swift
//  Olive
//
//  Created by Justin Loew on 11/22/14.
//  Copyright (c) 2014 edu.illinois. All rights reserved.
//

import Foundation
import CoreData

@objc(Drink)
class Drink: NSManagedObject {

    @NSManaged var recipe: String
    @NSManaged var tips: String
    @NSManaged var ingredients: NSSet

}
