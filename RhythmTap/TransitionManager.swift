//
//  TransitionManager.swift
//  RhythmTap
//
//  Created by Shelby Jestin on 2016-03-13.
//  Copyright © 2016 Brian Yip. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    var presenting = true
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to our fromView, toView and the container view
        let container = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // set up from 2D transforms that we'll use in the animation
        let offScreenRight = CGAffineTransformMakeTranslation(container!.frame.width, 0)
        let offScreenLeft = CGAffineTransformMakeTranslation(-container!.frame.width, 0)
        
        // start the toView to the right of the screen
        if (self.presenting){
            toView.transform = offScreenRight
        }
        else {
            toView.transform = offScreenLeft
        }
        
        // add the both views to our view controller
        container!.addSubview(toView)
        container!.addSubview(fromView)
        
        let duration = self.transitionDuration(transitionContext)
        
        // start animation
        UIView.animateWithDuration(duration, animations: {
            if (self.presenting){
                fromView.transform = offScreenLeft
            }
            else {
                fromView.transform = offScreenRight
            }
            toView.transform = CGAffineTransformIdentity
            }, completion: { finished in transitionContext.completeTransition(true)
        })
    }
    
    // return transition duration
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    // when presenting a ViewController
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //self.presenting = true
        return self
    }
    
    // rwhen dismissing a ViewController
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
}
