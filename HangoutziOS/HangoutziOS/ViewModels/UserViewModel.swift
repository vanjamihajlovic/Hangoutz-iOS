//
//  UserViewModel.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/18/24.
//

import Foundation

class UserViewModel: ObservableObject {
    
    @Published var users: [userData] = []
    @Published var errorMessage: String? = nil
    @Published var isUserCreated: Bool = false
    //Object of class UserService
    private let us = UserService()

    // Fetch users from Supabase
    func fetchUsers() {
        us.fetchUsers() { result in
            switch result {
            case .success(let users):
                DispatchQueue.main.async {
                    self.users = users
                    self.errorMessage = nil
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }//fetchUsers()

//    // Post a new user to Supabase
//    func createUser(username: String, email: String) {
//        let newUser = User(id: 0, username: username, email: email)
//        userService.postUser(user: newUser) { result in
//            switch result {
//            case .success(let user):
//                DispatchQueue.main.async {
//                    self.isUserCreated = true
//                    self.users.append(user)  // Optionally update the users list with the newly created user
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self.errorMessage = error.localizedDescription
//                }
//            }
//        }
//    }
}
