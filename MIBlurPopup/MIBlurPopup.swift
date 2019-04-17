//
//  MIBlurPopup.swift
//  MIBlurPopupDemo
//
//  Created by Mario on 01/01/2017.
//  Copyright © 2017 Mario Iannotta. All rights reserved.
//

import Foundation
import UIKit

public protocol MIBlurPopupDelegate: class {
    var popupView: UIView { get }
    var blurEffectStyle: UIBlurEffect.Style { get }
    var initialScaleAmmount: CGFloat { get }
    var animationDuration: TimeInterval { get }
}

open class MIBlurPopup: NSObject {
    
    private static var shared = MIBlurPopup()
    
    private var visualEffectBlurView = UIVisualEffectView()
    private var isPresenting = false
    
    public static func show(_ viewControllerToPresent: UIViewController, on parentViewController: UIViewController) {
        viewControllerToPresent.modalPresentationStyle = .overCurrentContext
        viewControllerToPresent.transitioningDelegate = shared
        
        if !(viewControllerToPresent is MIBlurPopupDelegate) {
            assertionFailure("ERROR: \(viewControllerToPresent) does not conform to protocol 'MIBlurPopupDelegate'")
        }
        
        parentViewController.present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    private func animatePresent(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let presentedViewController = transitionContext.viewController(forKey: .to),
            let presentedControllerDelegate = presentedViewController as? MIBlurPopupDelegate
            else { return }
        
        presentedViewController.view.alpha = 0
        presentedViewController.view.frame = transitionContext.containerView.bounds
        
        transitionContext.containerView.addSubview(presentedViewController.view)
        
        visualEffectBlurView.frame = transitionContext.containerView.bounds
        visualEffectBlurView.alpha = 1
        
        transitionContext.containerView.insertSubview(visualEffectBlurView, at: 0)
        visualEffectBlurView.translatesAutoresizingMaskIntoConstraints = false
        
        transitionContext.containerView.addConstraints([
            NSLayoutConstraint(item: visualEffectBlurView, attribute: .bottom, relatedBy: .equal,
                               toItem: transitionContext.containerView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: visualEffectBlurView, attribute: .top, relatedBy: .equal,
                               toItem: transitionContext.containerView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: visualEffectBlurView, attribute: .leading, relatedBy: .equal,
                               toItem: transitionContext.containerView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: visualEffectBlurView, attribute: .trailing, relatedBy: .equal,
                               toItem: transitionContext.containerView, attribute: .trailing, multiplier: 1, constant: 0)
            ])
        
        presentedControllerDelegate.popupView.alpha = 0
        presentedControllerDelegate.popupView.transform = CGAffineTransform(scaleX: presentedControllerDelegate.initialScaleAmmount,
                                                                            y: presentedControllerDelegate.initialScaleAmmount)
        
        // blur view animation workaround: need that to avoid the "blur-flashes"
        UIView.animate(withDuration: transitionDuration(using: transitionContext) * 0.75) {
            self.visualEffectBlurView.effect = UIBlurEffect(style: presentedControllerDelegate.blurEffectStyle)
        }
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: .allowUserInteraction,
            animations: {
                presentedViewController.view.alpha = 1
                presentedControllerDelegate.popupView.alpha = 1
                presentedControllerDelegate.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
            },
            completion: { isCompleted in
                transitionContext.completeTransition(isCompleted)
            }
        )
    }
    
    fileprivate func animateDismiss(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let presentedViewController = transitionContext.viewController(forKey: .from),
            let presentedControllerDelegate = presentedViewController as? MIBlurPopupDelegate
            else { return }
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0.0,
            usingSpringWithDamping: 2,
            initialSpringVelocity: 0.0,
            options: .allowUserInteraction,
            animations: {
                presentedViewController.view.alpha = 0
                self.visualEffectBlurView.alpha = 0
                presentedControllerDelegate.popupView.transform = CGAffineTransform(scaleX: presentedControllerDelegate.initialScaleAmmount,
                                                                                    y: presentedControllerDelegate.initialScaleAmmount)
            },
            completion: { isCompleted in
                self.visualEffectBlurView.effect = nil
                self.visualEffectBlurView.removeFromSuperview()
                transitionContext.completeTransition(isCompleted)
            }
        )
    }
    
}

// MARK: - Storyboard Segue

open class MIBlurPopupSegue: UIStoryboardSegue {
    
    open override func perform() {
        MIBlurPopup.show(destination, on: source)
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate

extension MIBlurPopup: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning

extension MIBlurPopup: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if let toViewControllerDelegate = transitionContext?.viewController(forKey: .to) as? MIBlurPopupDelegate {
            return toViewControllerDelegate.animationDuration
        }
        if let fromViewControllerDelegate = transitionContext?.viewController(forKey: .from) as? MIBlurPopupDelegate {
            return fromViewControllerDelegate.animationDuration
        }
        return 0
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresent(transitionContext: transitionContext)
        } else {
            animateDismiss(transitionContext: transitionContext)
        }
    }
    
}
