import UIKit

let numberFormatter = NumberFormatter()
numberFormatter.locale = .current

print("Current locale: \(numberFormatter.locale)")
print("Current locale currency code: \(numberFormatter.currencyCode)")

print("Currency code: \(NumberFormatter().currencyCode)")
