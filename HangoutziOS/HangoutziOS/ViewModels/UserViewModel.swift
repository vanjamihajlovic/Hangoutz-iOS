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
    private let us = UserService()
}
