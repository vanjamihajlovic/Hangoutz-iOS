//
//  UserViewModel.swift
//  HangoutziOS
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var users: [userData] = []
    @Published var errorMessage: String? = nil
    @Published var isUserCreated: Bool = false
    @Published var url: String = ""
    private let us = UserService()

    func getUsers() async {
        Task {
            await us.getUsers(from: url)
        }
    }
}

