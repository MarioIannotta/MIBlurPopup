//
//  ViewController.swift
//  MIBlurPopup
//
//  Created by Mario on 14/01/2017.
//  Copyright © 2017 Mario. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var blurStyleSegmentControl: UISegmentedControl!
    @IBOutlet weak var animationDurationTextField: UITextField!
    @IBOutlet weak var initialScaleAmmountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - IBActions
    
    @IBAction func showButtonTapped(_ sender: Any) {
        
        let popupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
        
        switch blurStyleSegmentControl.selectedSegmentIndex {
            
        case 0:
            popupViewController.customBlurEffectStyle = .light
            
        case 1:
            popupViewController.customBlurEffectStyle = .extraLight
            
        case 2:
            popupViewController.customBlurEffectStyle = .dark
            
        default:
            break
            
        }
        popupViewController.customAnimationDuration = TimeInterval(animationDurationTextField.text!)
        popupViewController.customInitialScaleAmmount = CGFloat(Double(initialScaleAmmountTextField.text!)!) // https://www.youtube.com/watch?v=TH_JRjJtNSw
        
        MIBlurPopup.show(popupViewController, on: self)
        
    }
    
    @IBAction func animationDurationStepperValueChanged(_ sender: Any) {
        
        guard let stepper = sender as? UIStepper else { return }
        
        animationDurationTextField.text = String(stepper.value)
        
    }
    @IBAction func initialScaleAmmountStepperValueChanged(_ sender: Any) {
        
        guard let stepper = sender as? UIStepper else { return }
        
        initialScaleAmmountTextField.text = String(stepper.value)
        
    }
    
}

