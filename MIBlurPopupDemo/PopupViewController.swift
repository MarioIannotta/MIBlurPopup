//
//  PopupViewController.swift
//  MIBlurPopup
//
//  Created by Mario on 14/01/2017.
//  Copyright © 2017 Mario. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var dismissButton: UIButton! {
        didSet {
            dismissButton.layer.cornerRadius = dismissButton.frame.height/2
        }
    }
    
    @IBOutlet weak var popupContentContainerView: UIView!
    @IBOutlet weak var popupMainView: UIView! {
        didSet {
            popupMainView.layer.cornerRadius = 10
        }
    }
    
    var customBlurEffectStyle: UIBlurEffectStyle!
    var customInitialScaleAmmount: CGFloat!
    var customAnimationDuration: TimeInterval!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return customBlurEffectStyle == .dark ? .lightContent : .default
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    // MARK: - IBActions
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }

}

// MARK: - MIBlurPopupDelegate

extension PopupViewController: MIBlurPopupDelegate {
    
    var popupView: UIView {
        return popupContentContainerView ?? UIView()
    }
    
    var blurEffectStyle: UIBlurEffectStyle {
        return customBlurEffectStyle
    }
    
    var initialScaleAmmount: CGFloat {
        return customInitialScaleAmmount
    }
    
    var animationDuration: TimeInterval {
        return customAnimationDuration
    }
    
}
