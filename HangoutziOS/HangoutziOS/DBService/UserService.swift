//
//  UserService.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/18/24.
//

import SwiftUI
import Foundation

class UserService {
    //TODO: IMPORT API KEY AND SECURE KEY (SERVICE_ROLE) FROM FILE!!!
    @ObservedObject var loginViewModel: LoginViewModel = LoginViewModel()
   
    // Fetch users from Supabase
    func fetchUsers(completion: @escaping (Result<[userData], Error>) -> Void) {
        guard let url = URL(string: loginViewModel.url) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(SupabaseConfig.apiKey, forHTTPHeaderField: "apiKey")
        request.setValue("Bearer \(SupabaseConfig.serviceRole)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            do {
                let users = try JSONDecoder().decode([userData].self, from: data)
                completion(.success(users))
               // print("PRIHVACEN USER")
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

