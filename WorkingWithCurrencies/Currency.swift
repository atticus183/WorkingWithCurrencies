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
        return formatter.currencyCode ?? "N/A"
    }
    
    var symbol: String? {
        return formatter.currencySymbol  ?? "N/A"
    }
    
    var format: String {
        return formatter.string(from: NSNumber(value: self.amount))!
    }

    var formatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: self.locale)
        numberFormatter.numberStyle = .currency
        
        return numberFormatter
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
    //not used anymore but left for example
//    static func cleanString(given formattedString: String) -> String {
//        var cleanedAmount = ""
//
//        for character in formattedString {
//            if character.isNumber {
//                cleanedAmount.append(character)
//            }
//        }
//
//        return cleanedAmount
//    }
    
    //MARK: Use when saving to a database which only requires numeric values
    static func formatCurrencyStringAsDouble(with localeString: String, for stringAmount: String) -> Double {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeString)
        numberFormatter.numberStyle = .currency
        
        return numberFormatter.number(from: stringAmount) as! Double
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
