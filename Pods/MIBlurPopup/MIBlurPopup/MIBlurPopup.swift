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
    var blurEffectStyle: UIBlurEffectStyle { get }
    var initialScaleAmmount: CGFloat { get }
    var animationDuration: TimeInterval { get }
    
}

open class MIBlurPopup: NSObject {
    
    // MARK: Default config
    
    private struct DefaultConfig {
        static let initialScaleAmmount: CGFloat = 0.7
        static let animationDuration: TimeInterval = 0.3
        static let blurEffectStyle: UIBlurEffectStyle = .dark
    }
    
    fileprivate weak var delegate: MIBlurPopupDelegate?
    
    private static var shared = MIBlurPopup()
    
    fileprivate var visualEffectBlurView = UIVisualEffectView()
    fileprivate var isPresenting = false
    
    open static func show(_ viewControllerToPresent: UIViewController, on parentViewController: UIViewController) {
        
        viewControllerToPresent.modalPresentationStyle = .overCurrentContext
        viewControllerToPresent.transitioningDelegate = shared
        
        if let popupDelegate = viewControllerToPresent as? MIBlurPopupDelegate {
            shared.delegate = popupDelegate
        } else {
            assertionFailure("ERROR: \(viewControllerToPresent) does not conform to protocol 'MIBlurPopupDelegate'")
        }
        
        parentViewController.present(viewControllerToPresent, animated: true, completion: nil)
        
    }
    
    // MARK: Transitions
    
    fileprivate func animatePresentationWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        presentedControllerView.alpha = 0
        
        transitionContext.containerView.addSubview(presentedControllerView)
        
        visualEffectBlurView.frame = transitionContext.containerView.bounds
        visualEffectBlurView.alpha = 1
        
        transitionContext.containerView.insertSubview(visualEffectBlurView, at: 0)
        
        delegate?.popupView.alpha = 0
        delegate?.popupView.transform = CGAffineTransform(scaleX: delegate?.initialScaleAmmount ?? DefaultConfig.initialScaleAmmount, y: delegate?.initialScaleAmmount ?? DefaultConfig.initialScaleAmmount)
        
        // blur view animation workaround: need that to avoid the "blur-flashes"
        UIView.animate(withDuration: transitionDuration(using: transitionContext) * 0.75) {
            
            self.visualEffectBlurView.effect = UIBlurEffect(style: self.delegate?.blurEffectStyle ?? DefaultConfig.blurEffectStyle)
            
        }
        
        // actual popup animation
        
        UIView.animate(

            withDuration: transitionDuration(using: transitionContext),
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: .allowUserInteraction,
            
            animations: {
                
                presentedControllerView.alpha = 1
                
                self.delegate?.popupView.alpha = 1
                self.delegate?.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            },
            completion: { (completed) in
                
                transitionContext.completeTransition(completed)
                
            }
            
        )
        
    }
    fileprivate func animateDismissalWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        
        UIView.animate(
            
            withDuration: transitionDuration(using: transitionContext),
            delay: 0.0,
            usingSpringWithDamping: 2,
            initialSpringVelocity: 0.0,
            options: .allowUserInteraction,
            animations: {
                
                presentedControllerView.alpha = 0
                
                self.visualEffectBlurView.alpha = 0
                self.delegate?.popupView.transform = CGAffineTransform(scaleX: self.delegate?.initialScaleAmmount ?? DefaultConfig.initialScaleAmmount, y: self.delegate?.initialScaleAmmount ?? DefaultConfig.initialScaleAmmount)
                
            }, completion: {(completed: Bool) -> Void in
                
                self.visualEffectBlurView.effect = nil
                self.visualEffectBlurView.removeFromSuperview()
                
                transitionContext.completeTransition(completed)
            
            }
            
        )
        
    }
    
}

open class MIBlurPopupSegue: UIStoryboardSegue {
    
    open override func perform() {
        
        MIBlurPopup.show(destination, on: source)
        
    }
    
}

extension MIBlurPopup: UIViewControllerTransitioningDelegate {
    
    // MARK: - UIViewControllerTransitioningDelegate
    
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
        
        return self.delegate?.animationDuration ?? 0.3
        
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        } else {
            animateDismissalWithTransitionContext(transitionContext)
        }
        
    }
    
}
