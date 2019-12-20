//
//  Currency.swift
//  WorkingWithCurrencies
//
//  Created by Josh R on 12/17/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import Foundation

struct Currency {
    let locale: String
    let amount: Double
    
    var code: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: self.locale)
        
        return numberFormatter.currencyCode ?? "N/A"
    }
    
    var symbol: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: self.locale)
        
        return numberFormatter.currencySymbol  ?? "N/A"
    }
    
    var format: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: self.locale)
        numberFormatter.numberStyle = .currency
        
        return numberFormatter.string(from: amount as NSNumber) ?? "N/A"
    }
    
    //Used to populate the cells on the MainVC
    func retrieveDetailedInformation() -> [(description: String, value: String)] {
        let retrievedLocale = Locale(identifier: self.locale)
        
        let informationToReturn = [
            (description: "locale", value: self.locale),
            (description: "code", value: self.code ?? "N/A"),
            (description: "symbol", value: retrievedLocale.currencySymbol ?? "N/A"),
            (description: "groupingSep", value: retrievedLocale.groupingSeparator ?? "N/A"),
            (description: "decimalSeparator", value: retrievedLocale.decimalSeparator ?? "N/A")
        ]
        
        return informationToReturn
    }
    
    //MARK: Clean formatting from string
    static func cleanString(given formattedString: String) -> String {
        var cleanedAmount = ""
        
        for character in formattedString {
            if character.isNumber {
                cleanedAmount.append(character)
            }
        }
        
        return cleanedAmount
    }
    
    //MARK: Use when saving to a database which only requires numeric values
    static func saveCurrencyAsDouble(with localeString: String, for stringAmount: String) -> Double {
        //Clean string first
        let cleanedString = Double(Currency.cleanString(given: stringAmount)) ?? 0.0
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeString)
        numberFormatter.numberStyle = .currency
        
        let numberOfDecimalPlaces = numberFormatter.maximumFractionDigits
        
        //Format the number based currency locale.  ie. JPY only uses whole numbers
        if numberOfDecimalPlaces > 0 {
            //ie. USD
            return cleanedString / 100.0
        } else {
            //ie. JPY
            return cleanedString
        }
    }
    
    //MARK: Currency Input Formatting - called when the user enters an amount in the
    static func currencyInputFormatting(with localeString: String, for amount: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeString)
        numberFormatter.numberStyle = .currency
        
        let numberOfDecimalPlaces = numberFormatter.maximumFractionDigits
        
        //Clean the inputed string
        var cleanedAmount = ""
        
        for character in amount {
            if character.isNumber {
                cleanedAmount.append(character)
            }
        }
        
        //Format the number based on number of decimal digits
        if numberOfDecimalPlaces > 0 {
            //ie. USD
            let amountAsDouble = Double(cleanedAmount) ?? 0.0
            
            return numberFormatter.string(from: amountAsDouble / 100.0 as NSNumber) ?? ""
        } else {
            //ie. JPY
            let amountAsNumber = Double(cleanedAmount) as NSNumber?
            return numberFormatter.string(from: amountAsNumber ?? 0) ?? ""
        }
    }
}


struct Currencies {
    static func retrieveAllCurrencies() -> [Currency] {
        var currencies = [Currency]()
        for locale in Locale.availableIdentifiers {
            let loopLocale = Locale(identifier: locale)
            currencies.append(Currency(locale: loopLocale.identifier, amount: 1000.00))
        }
        
        return currencies.sorted(by: { $0.locale < $1.locale })
    }
}
