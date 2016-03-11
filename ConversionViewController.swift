//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by k_sabbak on 3/10/16.
//  Copyright © 2016 k_sabbak. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet var celciusdLabel: UILabel!       //That d shouldn't be there but like, meh, you know?
    @IBOutlet var fahrTextField: UITextField!
    
    var fahrValue: Double?{
        didSet{
            updateCelciusLabel()
        }
    }
    var celciusValue: Double? {
        if let value = fahrValue {
            return (value - 32) * (5 / 9)
        }
        else {
            return nil
        }
    }
    
    let numberFormatter: NSNumberFormatter = {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func updateCelciusLabel()
    {
        if let value = celciusValue
        {
            celciusdLabel.text = numberFormatter.stringFromNumber(value)
        }
        else
        {
            celciusdLabel.text = "???"
        }
    }
    
    
    @IBAction func fahrenheitFieldEditingChanged(textField: UITextField)
    {
        if let text = textField.text, value = Double(text)
        {
            fahrValue = value
        }
        else
        {
            fahrValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject)
    {
        fahrTextField.resignFirstResponder()
    }
    
    
    //Mark: - TextField Delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let existingTextHasDecimal = textField.text?.rangeOfString(".")
        let replacementTextHasDecimal = string.rangeOfString(".")
        
        let replacementIsNumber = string.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet())
        
        
        if (existingTextHasDecimal != nil && replacementTextHasDecimal != nil)
        || !(replacementIsNumber != nil || replacementTextHasDecimal != nil || string.isEmpty || string.containsString("-")) //isempty controls for backspace
        {
            return false
        }
        else
        {
            return true
        }
    }
}