//
//  FriendsService.swift
//  HangoutziOS
//
//  Created by User01 on 11/29/24.
//

import Foundation

class FriendsService : ObservableObject{
    static let shared = FriendsService()
    let decoder = JSONDecoder()
    @Published var friends: [Friend] = []

   // @Published var friends: [FriendModel] = []
    
    
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
    func getFriends(from urlString: String) async -> [Friend] {
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return []
        }
        
        let returnedData = await downloadData(fromURL: url)
        
        if let data = returnedData {
            do {
                let decodedResponse = try JSONDecoder().decode([APIResponse].self, from: data)
                let friends = decodedResponse.map { $0.users }
                print("Decoded friends count: \(friends.count)")
                return friends
            } catch {
                print("Failed to decode friends data: \(error)")
                return []
            }
        } else {
            print("No data returned from API.")
            return []
        }
    }

//    func getFriends(from urlString: String) async -> [Friend] {
//        
//        guard let url = URL(string: urlString) else {
//            print ("Invalid url.")
//            return []
//        }
//        let returnedData = await downloadData(fromURL: url)
//        it let data = returnedData {
//            guard let newFriends = try? decoder.decode([Friend].self, from: data) else {
//                print("Failed to decode friends data.")
//                return []
//                }
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                print("Error fetching friends:", error ?? "Unknown error")
//                return
//            }
//            
//            do {
//                let apiResponses = try JSONDecoder().decode([APIResponse].self, from: data)
//                let friends = apiResponses.map { $0.users } // Ekstraktujemo `users` iz svakog objekta
//                DispatchQueue.main.async {
//                    completion(friends)
//                }
//            } catch {
//                print("Error decoding JSON:", error)
//            }
//        }.resume()
//    }
//
//    func fetchFriends(completion: @escaping ([Friend]) -> Void) {
//        let urlString = "https://zsjxwfjutstrybvltjov.supabase.co/rest/v1/friends?select=users!friend_id(name,avatar)&user_id=eq.0d1e1ace-d426-4734-876c-701784de75bb" // API URL
//        guard let url = URL(string: urlString) else { return }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                print("Error fetching friends:", error ?? "Unknown error")
//                return
//            }
//            
//            do {
//                let apiResponses = try JSONDecoder().decode([APIResponse].self, from: data)
//                let friends = apiResponses.map { $0.users } // Ekstraktujemo `users` iz svakog objekta
//                DispatchQueue.main.async {
//                    completion(friends)
//                }
//            } catch {
//                print("Error decoding JSON:", error)
//            }
//        }.resume()
//    }
    
//    func downloadData(fromURL url: URL, method: HTTPConstants) async -> Data? {
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = HTTPConstants.GET.rawValue
//            request.setValue(SupabaseConfig.apiKey, forHTTPHeaderField: HTTPConstants.API_KEY.rawValue)
//            request.setValue("Bearer \(SupabaseConfig.serviceRole)", forHTTPHeaderField: HTTPConstants.AUTHORIZATION.rawValue)
//            
//            return await withCheckedContinuation { continuation in
//                URLSession.shared.dataTask(with: request) { (data, response, error) in
//                    guard
//                        let data1 = data,
//                        error == nil,
//                        let response1 = response as? HTTPURLResponse,
//                        response1.statusCode >= 200 && response1.statusCode < 300
//                    else {
//                        print("Error downloading data.")
//                        continuation.resume(returning: nil)
//                        return
//                    }
//                    continuation.resume(returning: data1)
//                }.resume()
//            }
//        }

    func downloadData(fromURL url: URL) async -> Data? {
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
