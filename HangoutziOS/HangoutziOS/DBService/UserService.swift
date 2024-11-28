//
//  UserService.swift
//  HangoutziOS
//

import Foundation
import UIKit

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
        let returnedData = await downloadData(fromURL: url, method: HTTPConstants.GET)
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
                throw NSError(domain: "User already exists", code: 409, userInfo: nil)
            } else if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                throw NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)
            }
        }
        return true
    }
    func uploadData(fromURL url: URL, name : String, email: String, password: String ) async -> Data? {
        let body: [String: Any] = ["data": ["name": name, "email": email, "password": password]]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPConstants.POST.rawValue
        request.setValue(SupabaseConfig.apiKey, forHTTPHeaderField: HTTPConstants.API_KEY.rawValue)
        request.setValue("Bearer \(SupabaseConfig.serviceRole)", forHTTPHeaderField: HTTPConstants.AUTHORIZATION.rawValue)
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
    func downloadData(fromURL url: URL, method: HTTPConstants) async -> Data? {
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPConstants.GET.rawValue
        request.setValue(SupabaseConfig.apiKey, forHTTPHeaderField: HTTPConstants.API_KEY.rawValue)
        request.setValue("Bearer \(SupabaseConfig.serviceRole)", forHTTPHeaderField: HTTPConstants.AUTHORIZATION.rawValue)
        
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
    func updateName(url: String, userId: String, newName: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let jsonData: [String: Any] = [
            "name": newName
        ]
        guard let data = try? JSONSerialization.data(withJSONObject: jsonData) else {
            print("Failed to convert JSON to Data")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPConstants.PATCH.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(SupabaseConfig.apiKey, forHTTPHeaderField: HTTPConstants.API_KEY.rawValue)
        request.setValue("Bearer \(SupabaseConfig.serviceRole)", forHTTPHeaderField: HTTPConstants.AUTHORIZATION.rawValue)
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            if (200...299).contains(httpResponse.statusCode) {
                print("Name successfully updated!")
            } else {
                print("Failed to update name. Status code: \(httpResponse.statusCode)")
            }
        }.resume()
    }
    func uploadImageToSupabase(image: UIImage, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "InvalidImage", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid image data."])))
            return
        }
        let bucketName = "avatar"                     // Replace with your Supabase bucket name
        
        let uploadURL = SupabaseConfig.baseURLStorage + "\(fileName)"
        guard let url = URL(string: uploadURL) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to construct upload URL."])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPConstants.POST.rawValue
        request.setValue(SupabaseConfig.apiKey, forHTTPHeaderField: HTTPConstants.API_KEY.rawValue)
        request.setValue("Bearer \(SupabaseConfig.serviceRole)", forHTTPHeaderField: HTTPConstants.AUTHORIZATION.rawValue)
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        let uploadTask = URLSession.shared.uploadTask(with: request, from: imageData) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                let errorMessage = "Failed to upload image. HTTP Status Code: \(statusCode)"
                completion(.failure(NSError(domain: "UploadFailed", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                return
            }
            // Return the file path on success
            let filePath = "\(bucketName)/\(fileName)"
            completion(.success(filePath))
        }
        
        uploadTask.resume()
    }
    
}

