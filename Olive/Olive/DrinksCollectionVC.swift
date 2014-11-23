//
//  DrinksCollectionViewController.swift
//  Olive
//
//  Created by Justin Loew on 11/22/14.
//  Copyright (c) 2014 edu.illinois. All rights reserved.
//

import UIKit
import CoreData

let reuseIdentifier = "DrinkCells"

class DrinksCollectionViewController: UIViewController, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
	
    @IBOutlet var collectionView: UICollectionView!
    
	var fetchedResultsController = NSFetchedResultsController()
	let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        DrinkRecipesParser().hitIt()
        
        // Register cell classes
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DrinkRecipesParser().hitIt()
        var ret = fetchedResultsController.fetchedObjects?.count ?? 0
        println(ret)
        return ret
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        DrinkRecipesParser().hitIt()

        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
    
        // Configure the cell
//		cell.drink = fetchedResultsController.fetchedObjects?[indexPath.item] as Drink
        println((fetchedResultsController.fetchedObjects?[indexPath.item] as Drink).name)
        var background = UIView(frame: CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.width, cell.frame.height))
        background.backgroundColor = UIColor.redColor()
        cell.addSubview(background)

        var image = UIImageView(frame: CGRectMake(background.frame.origin.x, background.frame.origin.y, background.frame.width, background.frame.height))
        var data = (fetchedResultsController.fetchedObjects?[indexPath.item] as Drink).icon
        image.image = UIImage(data:data)
        background.addSubview(image)
        var blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var blurView = UIVisualEffectView(effect: blur)
        blurView.frame = CGRectMake(background.frame.origin.x, background.frame.origin.y, background.frame.width, 40)
        background.addSubview(blurView)
        var titleLabel = UILabel(frame: CGRectMake(0, 0, background.frame.width, 20))
        titleLabel.text = (fetchedResultsController.fetchedObjects?[indexPath.item] as Drink).name
        titleLabel.textAlignment = NSTextAlignment.Center
        background.addSubview(titleLabel)
        var percentLabel = UILabel(frame: CGRectMake(0, 20, background.frame.width, 20))
        percentLabel.text = "\(matchAccuracyForDrink(fetchedResultsController.fetchedObjects?[indexPath.item] as Drink))%"
        percentLabel.textAlignment = NSTextAlignment.Center
        background.addSubview(percentLabel)
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView,  indexPath: NSIndexPath) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
           return CGSizeMake((self.view.frame.width/2)-50.0, (self.view.frame.width/2)-50.0)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
