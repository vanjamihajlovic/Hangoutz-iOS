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
    //Create object of class Validation
    var validation : Validation = Validation()
    
    //MARK: HASH PASSWORD FUNCTION
    func hashPassword(password: String) -> String {
        //Covert password to data
        let data = Data(password.utf8)
        //Hash the data using SHA256
        let hashed = SHA256.hash(data: data)
        //Convert the hashed data to a hexadecimal string
        return hashed.compactMap{ String(format: "%02x", $0) }.joined()
    }
    //MARK: CREATE URL
    func createUrlLogin() {
        //Hash password for url
        let hashedPassword = hashPassword(password: password)
        url = SupabaseConfig.baseURL + "rest/v1/users?select=id,email,password_hash&email=eq.\(username)&password_hash=eq.\(hashedPassword)"
    }//createBaseUrlLogin
    
    //MARK: VALIDATE USER
    func validateLogin() -> Bool {
        if(validation.isEmpty(self.username) || validation.isEmpty(self.password)){
            //Empty fields error
            self.errorMessage = "All fields must be filled!"
            return false
        }
        else if(!validation.isValidEmail(self.username) || !validation.isValidPassword(self.password)) {
            //Invalid username or password
            self.errorMessage = "Incorrect email or password"
            return false
        }
        return true
    }
}//LoginViewModel
