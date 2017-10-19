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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions
    
    @IBAction func animationDurationStepperValueChanged(_ sender: Any) {
        guard let stepper = sender as? UIStepper else { return }
        
        animationDurationTextField.text = String(stepper.value)
    }
    
    @IBAction func initialScaleAmmountStepperValueChanged(_ sender: Any) {
        guard let stepper = sender as? UIStepper else { return }
        
        initialScaleAmmountTextField.text = String(stepper.value)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        
        guard let popupViewController = segue.destination as? PopupViewController else { return }
        
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
    }
    
}

