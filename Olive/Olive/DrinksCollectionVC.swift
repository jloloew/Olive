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

class DrinksCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
//    @IBOutlet var collectionView: UICollectionView!
    
	var fetchedResultsController = NSFetchedResultsController()
	let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        DrinkRecipesParser().hitIt()
        
        // Register cell classes
        self.collectionView.registerClass(DrinkCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 90)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(DrinkCollectionViewCell.self, forCellWithReuseIdentifier: "DrinkCells")
        collectionView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(collectionView)
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

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DrinkRecipesParser().hitIt()
        var ret = fetchedResultsController.fetchedObjects?.count ?? 0
        println(ret)
        return ret
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        DrinkRecipesParser().hitIt()

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DrinkCells", forIndexPath: indexPath) as DrinkCollectionViewCell
        
        
        var data = (fetchedResultsController.fetchedObjects?[indexPath.item] as Drink).icon
        cell.icon.image = UIImage(data:data)!
        println(cell.icon.image)

        cell.drinkName.text = (fetchedResultsController.fetchedObjects?[indexPath.item] as Drink).name
        cell.drinkName.textColor = UIColor.whiteColor()
        cell.drinkMatch.text = "\(matchAccuracyForDrink(fetchedResultsController.fetchedObjects?[indexPath.item] as Drink))% match"
        println("\([indexPath.item]) contains \(cell.drinkName.text)")
        cell.backgroundColor = UIColor.redColor()
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView,  indexPath: NSIndexPath) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//            collectionViewLayout.invalidateLayout()
           return CGSizeMake((self.view.frame.width/3)-7.0, (self.view.frame.width/3)-7.0)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//            collectionViewLayout.invalidateLayout()
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
