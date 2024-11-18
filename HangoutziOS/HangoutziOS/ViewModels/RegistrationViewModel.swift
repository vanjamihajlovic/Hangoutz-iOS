//
//  RegistrationViewModel.swift
//  HangoutziOS
//
//  Created by User01 on 11/18/24.
//

import Foundation
import SwiftUI
import Combine

class RegistrationViewModel: ObservableObject {
    
    @Published var nameRegistration = ""
    @Published var emailRegistration = ""
    @Published var passwordRegistration = ""
    @Published var password2Registration = ""
    
    @Published var isNameValid = true
    @Published var isEmailValid = true
    @Published var isPasswordValid = true
    @Published var isPassword2Valid = true
    @Published var showGlobalError = false
    @Published var globalErrorMessage = ""
    @Published var allFieldsFilled = true
    
    private let validation = Validation()
    
    // Function to validate all fields
    func validateFields() {
        allFieldsFilled = true
        var hasValidationErrors = false
        
        // Check if all fields are filled
        if validation.isEmpty(nameRegistration) ||
            validation.isEmpty(emailRegistration) ||
            validation.isEmpty(passwordRegistration) ||
            validation.isEmpty(password2Registration) {
            allFieldsFilled = false
        }
        
        // Individual Field Validations
        isNameValid = validation.isNameValid(nameRegistration)
        isEmailValid = validation.isValidEmail(emailRegistration)
        isPasswordValid = validation.isValidPassword(passwordRegistration)
        isPassword2Valid = validation.isConfirmPasswordEqual(pass: passwordRegistration, conPass: password2Registration)
        
        // If any validation fails, flag as having errors
        if !isNameValid || !isEmailValid || !isPasswordValid || !isPassword2Valid {
            hasValidationErrors = true
        }
        
        // Update Global Error Message
        if !allFieldsFilled {
            globalErrorMessage = "All fields must be filled."
            showGlobalError = true
        } else {
            showGlobalError = false
        }
    }
}
