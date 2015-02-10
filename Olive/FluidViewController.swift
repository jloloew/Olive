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

class FluidViewController : UIViewController, UICollisionBehaviorDelegate, UIAccelerometerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var DrinkImage: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var textView: UITextView!
    var drink : Drink!
    
    var animator : UIDynamicAnimator!
    var gravityBehavior : UIGravityBehavior!
    var collisionBehavior : UICollisionBehavior!
    var bubbles : Array<UIView>!
    var manager : CMMotionManager!
    var prevPushBehavior : UIPushBehavior?
    var otherPrevPushBehavior : UIPushBehavior?
    var panGestureRecognizer : UIPanGestureRecognizer!
    var negativeGravity : Double?
    var i = 0
    var j = 0
    var pushBehavior : UIPushBehavior!
    var dimmed : Array<UIView>!
    var halfBubbles : [UIView]!
    var image : UIImage!
    var colorA : UIColor!
    var colorB : UIColor!
    var colorC : UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image = UIImage(data:drink.icon)
        findColorsForImage(image)
        var blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.frame
        self.view.addSubview(blurView)
        self.view.sendSubviewToBack(blurView)
        
        view.backgroundColor = colorA
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panned:")
        self.view.addGestureRecognizer(panGestureRecognizer)
        animator = UIDynamicAnimator(referenceView: self.view)
        gravityBehavior = UIGravityBehavior()
        pushBehavior = UIPushBehavior(items: [], mode: UIPushBehaviorMode.Continuous)
        gravityBehavior.magnitude = 0.02
        manager = CMMotionManager()
        dimmed = Array()
        if manager.accelerometerAvailable {
            manager.accelerometerUpdateInterval = 0.1
            let queue = NSOperationQueue()
            manager.startAccelerometerUpdatesToQueue(queue) {
                (data, error) in dispatch_async(dispatch_get_main_queue()) {
                    var xx = data.acceleration.x
                    var yy = -data.acceleration.y
                    var gravityangle = atan2(yy, xx)
                    self.gravityBehavior.angle = CGFloat(gravityangle)
                    self.negativeGravity = gravityangle - M_PI
                }
            }
        }
        
        collisionBehavior = UICollisionBehavior()
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionDelegate = self
        bubbles = Array()
        
        let numBubbles : Int = 15
        for i in 0...numBubbles{
            let width = CGFloat(arc4random_uniform(10))+40
            bubbles.append(UIView(frame: CGRectMake(CGFloat(arc4random_uniform(UInt32(view.frame.width))), CGFloat(arc4random_uniform(UInt32(view.frame.height))), width, width)))
            bubbles[i].backgroundColor = colorB
            self.view.addSubview(bubbles[i])
            self.view.sendSubviewToBack(bubbles[i])
            collisionBehavior.addItem(bubbles[i])
            gravityBehavior.addItem(bubbles[i])
        }
        animator.addBehavior(gravityBehavior)
        animator.addBehavior(collisionBehavior)
        
        let myTimer = NSTimer(timeInterval: 0.7, target: self, selector: "timerDidFire:", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(myTimer, forMode: NSRunLoopCommonModes)
        let alphaTimer = NSTimer(timeInterval: 1.5, target: self, selector: "alphaTimerDidFire:", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(alphaTimer, forMode: NSRunLoopCommonModes)
        
        halfBubbles = Array()
        var k = 0
        for k = 0; k < (bubbles.count/2); k++ {
            halfBubbles.append(bubbles[k])
        }
        self.DrinkImage.image = image
//        self.titleLabel.text = drink.name
//        for i in drink.ingredients {
//            println(i)
//        }
        
    }
    
    func findColorsForImage(image: UIImage){
        var colorCluster : ColorCluster = ColorCluster()
        var topThree : NSMutableArray = kMean(image)
        colorA = topThree[0] as! UIColor
        colorB = topThree[1] as! UIColor
        colorC = topThree[2] as! UIColor
    }
    
    
    func panned(gestureRecognizer: UIPanGestureRecognizer){
        let velocityX : CGFloat = gestureRecognizer.velocityInView(self.view).x as CGFloat
        let velocityY : CGFloat = gestureRecognizer.velocityInView(self.view).y as CGFloat
        var push : UIPushBehavior = UIPushBehavior(items:halfBubbles, mode: UIPushBehaviorMode.Instantaneous)
        let magnitude : CGFloat = 0.02
        push.pushDirection = CGVectorMake((velocityX / 1000) , (velocityY / 1000))
        push.magnitude = magnitude
        if(otherPrevPushBehavior != nil){
            animator.removeBehavior(otherPrevPushBehavior)
        }
        animator.addBehavior(push)
        otherPrevPushBehavior = push
    }
    
    func alphaTimerDidFire(timer: NSTimer){
        if(dimmed.count > 4){
            var item = dimmed[0]
            dimmed.removeAtIndex(0)
            UIView.animateWithDuration(3.0, animations: {
                item.alpha = 1.0
            })
        }
        dimmed.append(bubbles[j])
        UIView.animateWithDuration(3.0, animations: {
            self.bubbles[self.j].alpha = 0.2
        })
        j = (j+1)%bubbles.count
    }
    
    func timerDidFire(timer: NSTimer){
        let item : UIView = bubbles[i]
        var pushBehavior = UIPushBehavior(items: [item], mode: UIPushBehaviorMode.Instantaneous)
        
        let mag = CGFloat(arc4random_uniform(50)/UInt32(100.0))+0.2
        if(negativeGravity != nil){
            pushBehavior.setAngle(CGFloat(negativeGravity!), magnitude:mag)
        }

        animator.addBehavior(pushBehavior)
        if (prevPushBehavior != nil){
            animator.removeBehavior(prevPushBehavior)
        }
        prevPushBehavior = pushBehavior
        i = (i+1)%bubbles.count
    }
    
    func kMean(image:UIImage) -> NSMutableArray {
        var cgImage : CGImageRef = image.CGImage
        var provider : CGDataProviderRef = CGImageGetDataProvider(cgImage)
        var bitmapData : CFDataRef = CGDataProviderCopyData(provider)
        var data : UnsafePointer<UInt8> = CFDataGetBytePtr(bitmapData)
        var bytesPerRow : UInt = CGImageGetBytesPerRow(cgImage)
        var width : UInt = CGImageGetWidth(cgImage)
        var height : UInt = CGImageGetHeight(cgImage)
        var colorCluster = ColorCluster()
        colorCluster.centers = NSMutableArray()
        
        var n = 0
        for n = 0; n < 15; n++ {
            colorCluster.centers[n] = ColorCluster()
            (colorCluster.centers[n] as! ColorCluster).clusterCenter = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            (colorCluster.centers[n] as! ColorCluster).colorPoints = NSMutableArray()
        }
        var dif : Float = 10000000000.0
        var smallestDif : Float = 1000000000.0
        var tempCluster = ColorCluster()
        var index = 0
        var pixelColor : UIColor;
        while(dif > 0.15){
            for var m : UInt = 0; UInt(m) < width; m+=20 {
                for var n : UInt = 0; UInt(n) < height; n+=20 {
                    var ptr = UnsafeMutablePointer<UInt8>(data)
                    let offset = Int((m*bytesPerRow)+(n*4))
                    ptr = ptr.advancedBy(offset)
                    var pixel : UnsafeMutablePointer<UInt8> = ptr
                    if(pixel != nil){
                        pixelColor = UIColor(red: CGFloat(pixel[0])/255.0, green: CGFloat(pixel[1])/255.0, blue: CGFloat(pixel[2])/255.0, alpha: 1.0)
                        smallestDif = 10000.0
                        for var c = 0; c < 15; c++ {
                            tempCluster = colorCluster.centers[c] as! ColorCluster
                            var distance : Float = colorCluster.calculateEuclideanDistance(pixelColor, newCenter: tempCluster.clusterCenter)
                            if (distance < smallestDif){
                                smallestDif = distance
                                index = c
                            }
                        }
                        (colorCluster.centers[index] as! ColorCluster).colorPoints.addObject(pixelColor)
                        dif = (colorCluster.centers[index] as! ColorCluster).updateClusterCenter()
                    }
                }
            }
        }
        return colorCluster.getTopThreeColors()
    }
}

class ColorCluster {
    var clusterCenter : UIColor!
    var colorPoints : NSMutableArray!
    var k = 15
    var centers : NSMutableArray!
    
    func updateClusterCenter() -> Float {
        var oldClusterCenter = self.clusterCenter
        
        var centerRed : CGFloat = 0.0
        var centerGreen : CGFloat = 0.0
        var centerBlue : CGFloat = 0.0
        var pointRed : CGFloat = 0.0
        var pointGreen : CGFloat = 0.0
        var pointBlue : CGFloat = 0.0
        
        var l = 0
        for (l = 0; l < self.colorPoints.count; l++) {
            self.colorPoints[l].getRed(&pointRed, green: &pointGreen, blue: &pointBlue, alpha: nil)
            //red
            centerRed = centerRed + pointRed
            //green
            centerGreen = centerGreen + pointGreen
            //blue
            centerBlue = centerBlue + pointBlue
            
        }
        centerRed = centerRed/CGFloat(self.colorPoints.count)
        centerGreen = centerGreen/CGFloat(self.colorPoints.count)
        centerBlue = centerBlue/CGFloat(self.colorPoints.count)
        clusterCenter = UIColor(red: centerRed, green: centerGreen, blue: centerBlue, alpha: 1.0)
        return calculateEuclideanDistance(oldClusterCenter, newCenter: clusterCenter)
    }
    
    func calculateEuclideanDistance(oldCenter:UIColor, newCenter:UIColor) -> Float {
        var distance : Float = 0.0
        var redA : CGFloat = 0.0
        var greenA : CGFloat = 0.0
        var blueA : CGFloat = 0.0
        var redB : CGFloat = 0.0
        var greenB : CGFloat = 0.0
        var blueB : CGFloat = 0.0
        
        oldCenter.getRed(&redA, green: &greenA, blue: &blueA, alpha: nil)
        newCenter.getRed(&redB, green: &greenB, blue: &blueB, alpha: nil)
        
        let difR : Float = Float(redA - redB)
        let difG : Float = Float(greenA - greenB)
        let difB : Float = Float(blueA - blueB)
        distance = sqrt(pow(difR, 2) + pow(difG, 2) + pow(difB, 2))
        
        return distance
    }
    
    func getNumberOfColorPoints() -> Int {
        return colorPoints.count
    }
    
    func getTopThreeColors() -> NSMutableArray {
        var topThree : NSMutableArray = NSMutableArray(capacity: 3)
        var currentCluster : ColorCluster = ColorCluster()
        var numberOfDataPointsInCluster : Int = 0
        var one : Int = 0
        var two : Int = 0
        var three : Int = 0
        var l : Int
        var m : Int
        
        for l = 0; l < 3; l++ {
            topThree.addObject(UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0))
        }
        for m = 0; m < k; m++ {
            numberOfDataPointsInCluster = (centers[m] as! ColorCluster).colorPoints.count
            currentCluster = centers[m] as! ColorCluster
            if(numberOfDataPointsInCluster > one) {
                three = two
                topThree[2] = topThree[1]
                two = one
                topThree[1] = topThree[0]
                one = numberOfDataPointsInCluster
                topThree[0] = currentCluster.clusterCenter
            }
            if(numberOfDataPointsInCluster < one && numberOfDataPointsInCluster > two){
                three = two
                topThree[2] = topThree[1]
                two = numberOfDataPointsInCluster
                topThree[1] = currentCluster.clusterCenter
            }
            if(numberOfDataPointsInCluster < two && numberOfDataPointsInCluster > three) {
                three = two
                topThree[2] = topThree[1]
                three = numberOfDataPointsInCluster
                topThree[2] = currentCluster.clusterCenter
            }
        }
        return topThree
    }
    
}