//
//  LoginViewModel.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/17/24.
//

import Foundation
import CryptoKit

class LoginViewModel: ObservableObject  {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var url: String = ""
    var validation : Validation = Validation()
    var userService: UserService = UserService()
    
    func hashPassword(password: String) -> String {
        let data = Data(password.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap{ String(format: "%02x", $0) }.joined()
    }
    func createUrlLogin()  {
        let hashedPassword = hashPassword(password: password)
        url = SupabaseConfig.baseURL + "rest/v1/users?select=id,email,password_hash&email=eq.\(username)&password_hash=eq.\(hashedPassword)"
    }
    func validateLogin() -> Bool {
        if(validation.isEmpty(self.username) || validation.isEmpty(self.password)){
            self.errorMessage = "All fields must be filled!"
            return false
        }
        else if(!validation.isValidEmail(self.username) || !validation.isValidPassword(self.password)) {
            self.errorMessage = "Incorrect email or password"
            return false
        }
        return true
    }
}
