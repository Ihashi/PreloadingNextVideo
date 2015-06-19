//
//  ViewController.swift
//  PreloadingNextVideo
//
//  Created by Hai NGUYEN on 19/06/2015.
//  Copyright (c) 2015 Hai NGUYEN. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var rootContainerView: UIView!
    @IBOutlet weak var leftHorizontalConstraintStory: NSLayoutConstraint!
    @IBOutlet weak var rightHorizontalConstraintStory: NSLayoutConstraint!
    
    @IBOutlet weak var rootContainerView2: UIView!
    private var feedViewController1: FeedViewController!
    private var feedViewController2: FeedViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedViewController1 = storyboard?.instantiateViewControllerWithIdentifier("FeedView") as? FeedViewController
        feedViewController1.view.frame = rootContainerView.frame
        feedViewController1.view.backgroundColor = UIColor.redColor()
        
        feedViewController2 = storyboard?.instantiateViewControllerWithIdentifier("FeedView") as? FeedViewController
        feedViewController2.view.frame = rootContainerView.frame
        feedViewController2.view.backgroundColor = UIColor.blueColor()
        
        rootContainerView.addSubview(feedViewController1.view)
        rootContainerView2.addSubview(feedViewController2.view)
    }
    
    private struct Constants {
        static let translationScaleStory: CGFloat = 1.5
        static let minPercentOfPan: CGFloat = 0.25
        static let timeToExitStory = 0.25
        static let timeToReturnToIdentity = 0.5
    }
    
    @IBAction func swipeGesture(gesture: UIPanGestureRecognizer) {
        let viewWidth = self.view.bounds.width
        let translationX = gesture.translationInView(self.view).x
        let rightTranslation = translationX > 0
        let requiredTranslationX = viewWidth * Constants.minPercentOfPan
        let xOffsetStory = translationX * Constants.translationScaleStory
        
        switch gesture.state {
        case .Ended:
            if(abs(xOffsetStory) >= requiredTranslationX) {
                let directionExitStory = rightTranslation ? viewWidth : -viewWidth
                leftHorizontalConstraintStory.constant = directionExitStory
                rightHorizontalConstraintStory.constant = -directionExitStory
                
                view.setNeedsUpdateConstraints()
                UIView.animateWithDuration (
                    Constants.timeToExitStory,
                    delay: 0.0,
                    options: UIViewAnimationOptions.CurveEaseOut,
                    animations: {
                        self.view.layoutIfNeeded()
                    },
                    completion: { (result:Bool) in
                        self.returnToIdentity(0)
                        self.view.bringSubviewToFront(self.rootContainerView2)
                    }
                )
            }
            else {
                returnToIdentity(Constants.timeToReturnToIdentity)
            }
        case .Changed:
            if translationX != 0 {
                leftHorizontalConstraintStory.constant = xOffsetStory
                rightHorizontalConstraintStory.constant = -xOffsetStory

                view.layoutIfNeeded()
            }
        default: break
        }
    }
    
    private func returnToIdentity(time: Double) {
        leftHorizontalConstraintStory.constant = 0
        rightHorizontalConstraintStory.constant = 0
        
        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(
            time,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
}

