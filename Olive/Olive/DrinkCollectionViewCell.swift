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
	
    var drinkName: UILabel
    var drinkMatch: UILabel
    var icon: UIImageView
    var drink : Drink!

    override init(frame: CGRect) {
        drinkName = UILabel()
        drinkMatch = UILabel()
        icon = UIImageView()
        super.init(frame: frame)
        
        icon = UIImageView(frame: CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, contentView.frame.width, contentView.frame.height))
        contentView.addSubview(icon)
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, contentView.frame.width, 40)
        contentView.addSubview(blurView)
        drinkName = UILabel(frame: CGRectMake(0, 0, contentView.frame.width, 20))
        drinkName.textAlignment = NSTextAlignment.Center
        contentView.addSubview(drinkName)
        drinkMatch = UILabel(frame: CGRectMake(0, 20, contentView.frame.width, 20))
        drinkMatch.textAlignment = NSTextAlignment.Center
        contentView.addSubview(drinkMatch)
    }
    
    required init(coder aDecoder: NSCoder) {
        drinkName = UILabel()
        drinkMatch = UILabel()
        icon = UIImageView()
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
}
