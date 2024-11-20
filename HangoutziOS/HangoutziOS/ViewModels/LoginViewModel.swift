//
//  LoginViewModel.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/17/24.
//

import Foundation
import CryptoKit

class LoginViewModel: ObservableObject  {
    //MARK: PROPERTIES
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var url: String = ""
    //Create object of class Validation
    var validation : Validation = Validation()
    var userService: UserService = UserService()
    
    //MARK: HASH PASSWORD FUNCTION
    ///Function that hashes the user password according to the SHA256 hash function
    func hashPassword(password: String) -> String {
        let data = Data(password.utf8)
        let hashed = SHA256.hash(data: data)
        //Convert the hashed data to a hexadecimal string
        return hashed.compactMap{ String(format: "%02x", $0) }.joined()
    }
    //MARK: CREATE URL
    ///Creates a url from the base supabase url and embeds user email and hashed password to the URL request
    func createUrlLogin()  {
        //Hash password for url
        let hashedPassword = hashPassword(password: password)
        url = SupabaseConfig.baseURL + "rest/v1/users?select=id,email,password_hash&email=eq.\(username)&password_hash=eq.\(hashedPassword)"
        
    }//createBaseUrlLogin
    
    //MARK: VALIDATE USER
    ///Function that returns true if the local valiation goes well, else returns false and doesn't send any data to the database.
    func validateLogin() -> Bool {
        if(validation.isEmpty(self.username) || validation.isEmpty(self.password)){
            //Empty fields error
            self.errorMessage = "All fields must be filled!"
            return false
        }
        else if(!validation.isValidEmail(self.username) || !validation.isValidPassword(self.password)) {
            self.errorMessage = "Incorrect email or password"
            return false
        }
        return true
    }
}//LoginViewModel
