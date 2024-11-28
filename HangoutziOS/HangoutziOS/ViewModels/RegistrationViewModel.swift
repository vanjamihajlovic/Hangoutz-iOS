//
//  RegistrationViewModel.swift
//  HangoutziOS
//
//  Created by User01 on 11/18/24.
//

import Foundation
import SwiftUI
import Combine
import CryptoKit


class RegistrationViewModel: ObservableObject {
    
    @Published var nameRegistration = ""
    @Published var emailRegistration = ""
    @Published var passwordRegistration = ""
    @Published var password2Registration = ""
    @Published var hashedPassword = ""
    @Published var url: String = ""
    
    @Published var isNameValid = true
    @Published var isEmailValid = true
    @Published var isPasswordValid = true
    @Published var isPassword2Valid = true
    @Published var showGlobalError = false
    @Published var globalErrorMessage = ""
    @Published var allFieldsFilled = true
    
    private let validation = Validation()
    
    func createJsonObject() -> Data? {
        let jsonObject: [String: Any] = [
            "name": nameRegistration,
            "email": emailRegistration,
            "password_hash": hashedPassword
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            return jsonData
        } catch {
            print("Error creating JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    func hashPassword(passwordRegistration: String) -> String {
        let data = Data(passwordRegistration.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap{ String(format: "%02x", $0) }.joined()
    }
    
    func createUrlRegister()  {
        hashedPassword = hashPassword(passwordRegistration: passwordRegistration)
        url = SupabaseConfig.baseURL + "rest/v1/users"
    }
    
    func registerUser() async -> Int {
        createUrlRegister()
        guard let jsonData = createJsonObject() else {
            print("Failed to create JSON data.")
            return 500
        }
        let userService = UserService()
        do {
            let success = try await userService.addUser(urlString: url, jsonData: jsonData)
            if success {
                print("User registered successfully!")
                return 200
            }
        } catch let error as NSError {
            print("Failed to register user: \(error.localizedDescription)")
            return error.code
        }
        return 500
    }
    
   

    func validateFields() -> Bool{
        allFieldsFilled = true
        var hasValidationErrors = false
        
        if validation.isEmpty(nameRegistration) ||
            validation.isEmpty(emailRegistration) ||
            validation.isEmpty(passwordRegistration) ||
            validation.isEmpty(password2Registration) {
            allFieldsFilled = false
        }
        isNameValid = !validation.isEmpty(nameRegistration) && validation.isNameValid(nameRegistration)
                isEmailValid = !validation.isEmpty(emailRegistration) && validation.isValidEmail(emailRegistration)
                isPasswordValid = !validation.isEmpty(passwordRegistration) && validation.isValidPassword(passwordRegistration)
                isPassword2Valid = !validation.isEmpty(password2Registration) && validation.isConfirmPasswordEqual(pass: passwordRegistration, conPass: password2Registration)
                
//
//        isNameValid = validation.isNameValid(nameRegistration)
//        isEmailValid = validation.isValidEmail(emailRegistration)
//        isPasswordValid = validation.isValidPassword(passwordRegistration)
//        isPassword2Valid = validation.isConfirmPasswordEqual(pass: passwordRegistration, conPass: password2Registration)
//        
        if !isNameValid || !isEmailValid || !isPasswordValid || !isPassword2Valid {
            hasValidationErrors = true
        }
        if !allFieldsFilled {
            globalErrorMessage = "All fields must be filled."
            showGlobalError = true
        } else {
            showGlobalError = false
        }
        return allFieldsFilled && !hasValidationErrors
    }
}
