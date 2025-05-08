//
//  String+Localized.swift
//  testAsinc
//
//  Created by Ire  Av on 8/5/25.
//

// String+Localized.swift
import Foundation

extension String {
    var localized: String {
        String(localized: String.LocalizationValue(self))
    }
}
