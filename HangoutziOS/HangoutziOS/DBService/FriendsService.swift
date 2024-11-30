//
//  FriendsService.swift
//  HangoutziOS
//
//  Created by User01 on 11/29/24.
//

import Foundation

class FriendsService : ObservableObject{
    static let shared = FriendsService()
    @Published var friends: [FriendModel] = []
    
    
//    func getEvents(from urlString: String) async -> [eventModelDTO] {
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL.")
//            return []
//        }
//        let returnedData = await downloadData(fromURL: url)
//        if let data = returnedData {
//            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//            decoder.dateDecodingStrategy = .formatted(formatter)
//            guard let newEvents = try? decoder.decode([eventModelDTO].self, from: data) else {
//                print("Failed to decode events data.")
//                return []
//            }
//            print("Decoded events count: \(newEvents.count)")
//            await MainActor.run {
//                self.events = newEvents
//            }
//            return newEvents
//        } else {
//            return []
//        }
//    }
    
//    func getUsers(from urlString: String) async -> [userData] {
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
    
    func getFriends(from urlString: String) async -> [FriendModel] {
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return []
        }
        let returnedData = await downloadData(fromURL: url, method: HTTPConstants.GET)
        if let data = returnedData {
            guard let newFriends = try? JSONDecoder().decode([FriendModel].self, from: data) else {
                print("Failed to decode user data.")
                return []
            }
            await MainActor.run {
                self.friends = newFriends
            }
            return newFriends
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

    
}
