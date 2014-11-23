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
	
	@IBOutlet weak var drinkName: UILabel!
	@IBOutlet weak var drinkMatch: UILabel!
	@IBOutlet weak var icon: UIImageView!
	@IBOutlet var drink: Drink? {
		didSet {
            if (drink != nil){
                drinkName.text = drink!.name
                drinkMatch.text = "\(matchAccuracyForDrink(drink!))% match"
                icon.image = UIImage(data: drink!.image)
            } else {
                println("drink is nil!")
            }
	
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
}
