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

    func getFriends(from urlString: String) async -> [Friend] {
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return []
        }
        let returnedData = await downloadData(fromURL: url)
        
        if let data = returnedData {
            do {
                let decodedResponse = try JSONDecoder().decode([APIResponse].self, from: data)
                let friends = decodedResponse.map { $0.users }.map { friend in
                    var updatedFriend = friend
                    updatedFriend.isChecked = friend.isChecked ?? false
                    return updatedFriend
                }
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
    func deleteFriend(urlString: String) async throws -> Bool {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPConstants.DELETE.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(SupabaseConfig.apiKey, forHTTPHeaderField: HTTPConstants.API_KEY.rawValue)
        request.setValue("Bearer \(SupabaseConfig.serviceRole)", forHTTPHeaderField: HTTPConstants.AUTHORIZATION.rawValue)

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if (200...299).contains(httpResponse.statusCode) {
            print("Friend successfully deleted!")
            return true
        } else {
            print("Failed to delete friend. Status code: \(httpResponse.statusCode)")
            return false
        }
    }

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
