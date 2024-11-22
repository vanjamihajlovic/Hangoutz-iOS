//
//  Validation.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/15/24.
//

import Foundation

class Validation {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", ValidationConstants.EMAIL_REGEX)
        return emailPredicate.evaluate(with: email)
    }
    func isEmpty(_ text: String) -> Bool {
        return text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    func isValidPassword(_ password: String) -> Bool {
        let passPredicate = NSPredicate(format: "SELF MATCHES %@", ValidationConstants.PASS_REGEX)
        return passPredicate.evaluate(with: password)
    }
    func isConfirmPasswordEqual(pass: String, conPass: String) -> Bool {
        return pass == conPass
    }
    func isNameValid(_ name: String) -> Bool {
        return name.count >= ValidationConstants.MIN_NAME_LENGTH && name.count <= ValidationConstants.MAX_NAME_LENGTH
    }
}
