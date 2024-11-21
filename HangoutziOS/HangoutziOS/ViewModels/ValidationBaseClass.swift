//
//  Validation.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/15/24.
//

import Foundation

class Validation {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    func isEmpty(_ text: String) -> Bool {
        return text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    func isValidPassword(_ password: String) -> Bool {
        let passRegex = "^(?=.*\\d)[A-Za-z0-9!@#$%^&*]{8,}$"
        let passPredicate = NSPredicate(format: "SELF MATCHES %@", passRegex)
        return passPredicate.evaluate(with: password)
    }
    func isConfirmPasswordEqual(pass: String, conPass: String) -> Bool {
        return pass == conPass
    }
    func isNameValid(_ name: String) -> Bool {
        return name.count >= 3 && name.count <= 25
    }
}
