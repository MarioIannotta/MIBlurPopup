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

    // MARK: - IBActions
    
    @IBAction func animationDurationStepperValueChanged(_ stepper: UIStepper) {
        animationDurationTextField.text = String(stepper.value)
    }
    
    @IBAction func initialScaleAmmountStepperValueChanged(_ stepper: UIStepper) {
        initialScaleAmmountTextField.text = String(stepper.value)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        
        guard let popupViewController = segue.destination as? PopupViewController else { return }
        
        switch blurStyleSegmentControl.selectedSegmentIndex {
        case 0:
            popupViewController.customBlurEffectStyle = nil
        case 1:
            popupViewController.customBlurEffectStyle = .light
        case 2:
            popupViewController.customBlurEffectStyle = .extraLight
        case 3:
            popupViewController.customBlurEffectStyle = .dark
        default:
            break
        }
        
        popupViewController.customAnimationDuration = TimeInterval(animationDurationTextField.text!)
        popupViewController.customInitialScaleAmmount = CGFloat(Double(initialScaleAmmountTextField.text!)!) // https://www.youtube.com/watch?v=TH_JRjJtNSw
    }
    
}

