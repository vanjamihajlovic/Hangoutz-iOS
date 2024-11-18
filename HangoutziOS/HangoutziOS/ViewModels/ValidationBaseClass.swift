//
//  Validation.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/15/24.
//

import Foundation

class Validation {
    
    // Checks whether the email string is of correct email format, including the dot and @
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    // Checks if the string is empty. The whitespaces are not counted as characters.
    func isEmpty(_ text: String) -> Bool {
        return text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    // Checks if the password fulfills all of the requirements: at least 8 characters and at least one digit
    func isValidPassword(_ password: String) -> Bool {
        let passRegex = "^(?=.*\\d)[A-Za-z0-9!@#$%^&*]{8,}$"
        let passPredicate = NSPredicate(format: "SELF MATCHES %@", passRegex)
        return passPredicate.evaluate(with: password)
    }
    // Checks if the entry from the 'confirm password' is the same as the one from the 'password'
    func isConfirmPasswordEqual(pass: String, conPass: String) -> Bool {
        return pass == conPass
    }
    // Checks if the name has at least 3 and at most 25 characters
    func isNameValid(_ name: String) -> Bool {
        return name.count >= 3 && name.count <= 25
    }
}
