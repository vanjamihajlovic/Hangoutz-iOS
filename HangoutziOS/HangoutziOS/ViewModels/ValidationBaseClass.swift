//
//  Validation.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/15/24.
//

import Foundation

class Validation {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", Constants.emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    func isEmpty(_ text: String) -> Bool {
        return text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    func isValidPassword(_ password: String) -> Bool {
        let passPredicate = NSPredicate(format: "SELF MATCHES %@", Constants.passRegex)
        return passPredicate.evaluate(with: password)
    }
    func isConfirmPasswordEqual(pass: String, conPass: String) -> Bool {
        return pass == conPass
    }
    func isNameValid(_ name: String) -> Bool {
        return name.count >= Constants.minNameLength && name.count <= Constants.maxNameLength
    }
}
