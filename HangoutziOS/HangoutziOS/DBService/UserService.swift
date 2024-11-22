//
//  UserService.swift
//  HangoutziOS
//

import Foundation

class UserService : ObservableObject {
    
    @Published var users: [userData] = []
    let url: String = ""
    let body: [String: Any] = ["data": []]

    
    init() {
    }
    func getUsers(from urlString: String) async -> [userData] {
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return []
        }
        let returnedData = await downloadData(fromURL: url)
        if let data = returnedData {
            guard let newUsers = try? JSONDecoder().decode([userData].self, from: data) else {
                print("Failed to decode user data.")
                return []
            }
            await MainActor.run {
                self.users = newUsers
            }
            return newUsers
        } else {
            return []
        }
    }
        func addUser(urlString: String, jsonData: Data?) async throws -> Bool {
        guard let url = URL(string: urlString) else {
                    throw URLError(.badURL)
                }
                guard let jsonData = jsonData else {
                    throw NSError(domain: "Invalid JSON data", code: 0, userInfo: nil)
                }
        var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue(SupabaseConfig.apiKey, forHTTPHeaderField: "apikey")
                request.httpBody = jsonData
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 409 {
                        print("Conflict: User already exists.")
                        throw NSError(domain: "User already exists", code: 409, userInfo: nil)
                    } else if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                        print("Error: HTTP status code \(httpResponse.statusCode)")
                        throw NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)
                    }
        }
            print("User successfully added.")
            return true
    }
    
    func uploadData(fromURL url: URL, name : String, email: String, password: String ) async -> Data? {
        let body: [String: Any] = ["data": ["name": name, "email": email, "password": password]]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPConstants.Post.rawValue
        request.setValue(SupabaseConfig.apiKey, forHTTPHeaderField: HTTPConstants.ApiKey.rawValue)
        request.setValue("Bearer \(SupabaseConfig.serviceRole)", forHTTPHeaderField: HTTPConstants.Authorization.rawValue)
        //make body
        return await withCheckedContinuation { continuation in
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard
                    let data1 = data,
                    error == nil,
                    let response1 = response as? HTTPURLResponse,
                    response1.statusCode >= 200 && response1.statusCode < 300
                else {
                    print("Error downloading data.")
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: data1)
            }.resume()
        }
    }

    func downloadData(fromURL url: URL) async -> Data? {
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPConstants.Get.rawValue
        request.setValue(SupabaseConfig.apiKey, forHTTPHeaderField: HTTPConstants.ApiKey.rawValue)
        request.setValue("Bearer \(SupabaseConfig.serviceRole)", forHTTPHeaderField: HTTPConstants.Authorization.rawValue)
        //Make body
        // request.setValue(String?, forHTTPHeaderField: Body)
        return await withCheckedContinuation { continuation in
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard
                    let data1 = data,
                    error == nil,
                    let response1 = response as? HTTPURLResponse,
                    response1.statusCode >= 200 && response1.statusCode < 300
                else {
                    print("Error downloading data.")
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: data1)
            }.resume()
        }
    }
}

