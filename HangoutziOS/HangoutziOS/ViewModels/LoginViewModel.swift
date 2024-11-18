//
//  LoginViewModel.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/17/24.
//

import Foundation

class LoginViewModel: ObservableObject  {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false
    
    var validation : Validation = Validation()
    
    func createBaseUrlLogin(email: String, password: String) {
        //TODO: IMPORT API FROM FILE, DON'T COMMIT!!!
        let baseUrlLogin: String = ""

    }
    
    func validateLogin(username: String, password: String) -> Bool {
            
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
