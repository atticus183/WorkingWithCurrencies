//
//  CurrencyTest.swift
//  WorkingWithCurrenciesTests
//
//  Created by Josh R on 8/9/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

@testable import WorkingWithCurrencies
import XCTest

class CurrencyTest: XCTestCase {
    
    var currency: Currency!
    
    override func setUp() {
        super.setUp()
        currency = Currency(locale: "en_US", amount: 1.25)
    }
    
    override func tearDown() {
        currency = nil
        super.tearDown()
    }
    
    //MARK: Testing methods
    func test_Currency_Code() {
        XCTAssertEqual(currency.code!, "USD")
    }
    
    func test_Currency_Symbol() {
        XCTAssertEqual(currency.symbol!, "$")
    }
    
    func test_Currency_Format() {
        XCTAssertEqual(currency.format, "$1.25")
    }
    
    func test_formatCurrencyAsDouble() {
        let cleanedAmount = Currency.formatCurrencyStringAsDouble(with: "en_US", for: "$1,234.45")
        
        XCTAssertEqual(cleanedAmount, 1234.45)
    }
   
    
}
