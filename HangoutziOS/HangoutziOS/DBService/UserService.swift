//
//  UserService.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/18/24.
//
import Foundation

class UserService : ObservableObject {
    
    @Published var users: [userData] = []
    let url: String = ""
    
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
    
    //In order to get avatar from supabase, we need to GET user avatar in json format (ex. {"avatar" : "avatar.jpg"}). Just save the image name "avatar.jpg" and then make another GET request to the storage of supabase with the image name.
    /*API Call for user avatar: https://zsjxwfjutstrybvltjov.supabase.co/rest/v1/users?select=avatar&id=eq.\(loggedInUser))
     API Call for image in storage:
     https://zsjxwfjutstrybvltjov.supabase.co/storage/v1/object/public/avatar/\(imageName)*/
    
//    func getAvatar(from urlString: String) async -> [userData] {
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL.")
//            return []
//        }
//        let returnedData = await downloadData(fromURL: url, method: HTTPConstants.GET)
//        if let data = returnedData {
//            guard let newUsers = try? JSONDecoder().decode([userData].self, from: data) else {
//                print("Failed to decode user data.")
//                return []
//            }
//            await MainActor.run {
//                self.users = newUsers
//            }
//            return newUsers
//        } else {
//            return []
//        }
//    }
    
}



