//
//  FluidViewController.swift
//  Olive
//
//  Created by Bri Chapman on 11/22/14.
//  Copyright (c) 2014 edu.illinois. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class FluidViewController : UIViewController, UICollisionBehaviorDelegate, UIAccelerometerDelegate {
    var animator : UIDynamicAnimator!
    var gravityBehavior : UIGravityBehavior!
    var collisionBehavior : UICollisionBehavior!
    var bubbles : Array<UIView>!
    var manager : CMMotionManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: self.view)
        gravityBehavior = UIGravityBehavior()
        manager = CMMotionManager()
        if manager.accelerometerAvailable {
            manager.accelerometerUpdateInterval = 0.5
            let queue = NSOperationQueue()
            manager.startAccelerometerUpdatesToQueue(queue) {
                (data, error) in dispatch_async(dispatch_get_main_queue()) {
                    var xx = data.acceleration.x
                    var yy = -data.acceleration.y
                    var angle = atan2(yy, xx)
                    self.gravityBehavior.angle = CGFloat(angle)
                }
            }
        }

        collisionBehavior = UICollisionBehavior()
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionDelegate = self
        bubbles = Array()
        let numBubbles : Int = Int(arc4random_uniform(50))+25
        for i in 0...numBubbles{
            let width = CGFloat(arc4random_uniform(25))+25
            bubbles.append(UIView(frame: CGRectMake(50, 50, width, width)))
            bubbles[i].backgroundColor = UIColor.redColor()
            self.view.addSubview(bubbles[i])
            collisionBehavior.addItem(bubbles[i])
            gravityBehavior.addItem(bubbles[i])
        }
        animator.addBehavior(gravityBehavior)
        animator.addBehavior(collisionBehavior)
        var blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.frame
        self.view.addSubview(blurView)
        

    }
    
    
//    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint) {
//        
//    }
//    
//    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying) {
//        
//    }
}