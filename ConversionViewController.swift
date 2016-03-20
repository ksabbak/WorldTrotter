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
        
        print("ConversionViewController did load")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Changes the background to a random color every time.
        //view.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255)) / 255, green: CGFloat(arc4random_uniform(255)) / 255, blue: CGFloat(arc4random_uniform(255)) / 255, alpha: 1.0)
        
        //Changes the background based on time of day. Probably a lot more convoluted than needed but fuck it.
        let dateTime = NSDate()
        let dateFormatter: NSDateFormatter = {
            let df = NSDateFormatter()
            df.timeStyle = .MediumStyle
            return df
            }()
        let currentTime = dateFormatter.stringFromDate(dateTime)
        print("\(currentTime)")
        print("\(currentTime.characters.first)")
        
        //Gets the hour characters of the time string. OH MY GOD I JUST FIGURED SOMETHING THE FUCK OUT.
        var hour: String {
            
            if String(currentTime.characters[currentTime.characters.startIndex.advancedBy(1)]) == ":"
            {
                return String(currentTime.characters[currentTime.characters.startIndex])
            }
            else
            {
                return String(currentTime.characters[currentTime.characters.startIndex]) + String(currentTime.characters[currentTime.characters.startIndex.advancedBy(1)])
            }
        }
        print(hour)
        
        if let hourTime = Int(hour)
        {
            if   currentTime.containsString("PM") && hourTime > 5
            {
                view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
                print("After 6PM")
            }
            else if currentTime.containsString("PM")
            {
                view.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
                print("Between Noon and 6PM")
            }
            else if currentTime.containsString("AM") && hourTime < 5
            {
                view.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
                print("Between midnight and 6AM")
            }
            else
            {
                view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
                print("Between 6AM and noon")
            }
        }
        

        
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
        if let text = textField.text, number = numberFormatter.numberFromString(text)
        {
            fahrValue = number.doubleValue
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
        let currentLocale = NSLocale.currentLocale()
        let decimalSeparator = currentLocale.objectForKey(NSLocaleDecimalSeparator) as! String
        
        let existingTextHasDecimal = textField.text?.rangeOfString(decimalSeparator)
        let replacementTextHasDecimal = string.rangeOfString(decimalSeparator)
        
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