//
//  UserViewModel.swift
//  HangoutziOS
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var users: [userData] = []
    @Published var errorMessage: String? = nil
    @Published var isUserCreated: Bool = false
    private let us = UserService()
    @Published var url: String = ""
    
    func createUrlUserById(id:String) async {
        url = SupabaseConfig.baseURL + "rest/v1/users?id=eq.\(id)&select"
    }
    
    func getUsers() async {
        Task {
            await us.getUsers(from: url)
        }
    }
}

