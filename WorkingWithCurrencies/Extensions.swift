//
//  Extensions.swift
//  WorkingWithCurrencies
//
//  Created by Josh R on 12/17/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    class var identifier: String {
        return String(describing: self)
    }
}

extension String {
    func isLastCharANumber() -> Bool {
        let lastChar = self.last!
        
        if lastChar.isNumber {
            return true
        } else {
            return false
        }
    }
}
