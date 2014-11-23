//
//  DrinkCollectionViewCell.swift
//  Olive
//
//  Created by Justin Loew on 11/22/14.
//  Copyright (c) 2014 edu.illinois. All rights reserved.
//

import UIKit
import CoreData

class DrinkCollectionViewCell: UICollectionViewCell {
	
	var drinkName: UILabel!
	var drinkMatch: UILabel!
	var icon: UIImageView!
	var drink: Drink! {
		didSet {
			drinkName.text = drink.name
			drinkMatch.text = "\(matchAccuracyForDrink(drink))% match"
			icon.image = UIImage(data: drink.image)
		}
	}
	
}
