//
//  CurrencyTextField.swift
//  WorkingWithCurrencies
//
//  Created by Josh R on 9/8/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import UIKit

class CurrencyTextField: UITextField {
    
    var passTextFieldText: ((String, Double?) -> Void)?
    
    var currencyCode: String? {
        didSet { numberFormatter.currencyCode = self.currencyCode ?? Locale.current.currencyCode ?? "USD" }
    }
    var locale: Locale? {
        didSet { numberFormatter.locale = self.locale ?? Locale.current }
    }
    
    var amountAsDouble: Double?
    
    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.locale ?? Locale.current
        formatter.currencyCode = self.currencyCode ?? Locale.current.currencyCode ?? "USD"
        
        return formatter
    }()
    
    private var roundingPlaces: Int {
        return numberFormatter.maximumFractionDigits
    }
    
    private var isSymbolOnRight = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //If using in SBs
        setup()
    }
    
    private func setup() {
        self.textAlignment = .right
        self.keyboardType = .numberPad
        delegate = self
        
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    //AFTER entered string is registered in the textField
    @objc func textFieldDidChange() {
        print("Text in textFieldDidChange before cleaning: \(String(describing: self.text))")
        var cleanedAmount = ""
        
        for character in self.text ?? "" {
            if character.isNumber {
                cleanedAmount.append(character)
            }
        }
        
        if isSymbolOnRight {
            cleanedAmount = String(cleanedAmount.dropLast())
        }
        
        //Format the number based on number of decimal digits
        if self.roundingPlaces > 0 {
            //ie. USD
            let amount = Double(cleanedAmount) ?? 0.0
            amountAsDouble = (amount / 100.0)
            let amountAsString = numberFormatter.string(from: NSNumber(value: amountAsDouble ?? 0.0)) ?? ""
            
            self.text = amountAsString
        } else {
            //ie. JPY
            let amountAsNumber = Double(cleanedAmount) ?? 0.0
            amountAsDouble = amountAsNumber
            self.text = numberFormatter.string(from: NSNumber(value: amountAsNumber)) ?? ""
        }
        
        passTextFieldText?(self.text!, amountAsDouble)
    }
    
}


extension CurrencyTextField: UITextFieldDelegate {
    
    //BEFORE entered string is registered in the textField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let lastCharacterInTextField = (textField.text ?? "").last
        
        //Note - not the most straight forward implementation but this subclass supports both right and left currencies
        if string == "" && lastCharacterInTextField!.isNumber == false {
            //For hitting backspace and currency is on the right side
            isSymbolOnRight = true
        } else {
            isSymbolOnRight = false
        }
        
        print("shouldChangeCharactersIn - textField: \(String(describing: textField.text))")
        print("shouldChangeCharactersIn - replacementString: \(string)")
        
        return true
    }
}
