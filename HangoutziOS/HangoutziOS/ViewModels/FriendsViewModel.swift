//
//  FriendsViewModel.swift
//  HangoutziOS
//
//  Created by User01 on 11/29/24.
//
import Foundation
import SwiftUICore
import SwiftUI

class FriendsViewModel : ObservableObject {
    @Published var friends: [Friend] = []
    @Published var notFriends: [userData] = []
    @Published var searchUser = ""
    @Published var snackBarText = ""
    @Published var snackBarTitle = ""
    @Published var show = false
    @Published var url: String = ""
    @Published var searchText = ""
    @AppStorage("currentUserId") var currentUserId: String?
    let friendsService = FriendsService()
    let userService = UserService()
    
    var filteredFriends: [Friend] {
        if searchText.count >= 3 {
            return friends.filter { friend in
                let firstWord = friend.name.components(separatedBy: " ").first ?? ""
                return firstWord.localizedCaseInsensitiveContains(searchText)
            }
        } else {
            return friends
        }
    }
    var sortedFriends: [Friend] {
        filteredFriends.sorted {
            let firstWord1 = $0.name.components(separatedBy: " ").first ?? $0.name
            let firstWord2 = $1.name.components(separatedBy: " ").first ?? $1.name
            return firstWord1.localizedCompare(firstWord2) == .orderedAscending
        }
    }
    
    func getFriends() async {
        guard let userId = currentUserId else {
            print("Current user ID is nil.")
            return
        }
        url = SupabaseConfig.baseURL + SupabaseConstants.GET_FIRENDS_VIA_ID + userId
        let fetchedFriends = await friendsService.getFriends(from: url)
        await MainActor.run {
            self.friends = fetchedFriends
        }
    }
    
    func getUsersWhoAreNotFriends() async {
        let excludedFriendIds = sortedFriends.compactMap { $0.id }
        let joinedString = excludedFriendIds.joined(separator: ",")
        url = SupabaseConfig.baseURL + SupabaseConstants.GET_USERS_WHO_ARE_NOT_FRIENDS + joinedString + ")&name=ilike." + searchUser + "*"
        let fetchedNonFriends = await userService.getUsers(from: url)
        await MainActor.run {
            self.notFriends = fetchedNonFriends
        }
    }

    func createJsonObject(friendId: String) -> Data? {
        let friendId = friendId
        let jsonObject: [String: Any] = [
            "user_id" : currentUserId,
            "friend_id": friendId
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            return jsonData
        } catch {
            print("Error creating JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    func createUrlDeleteFriend(){
        url = SupabaseConfig.baseURL + "rest/v1/friends?user_id=eq."
    }
    
    func deleteFriend(friendId: String, friendName: String) async -> Int {
        let friendName = friendName
        let apiUrl = SupabaseConfig.baseURL + "rest/v1/friends?user_id=eq.\(currentUserId ?? "")" + "&friend_id=eq." + "\(friendId)"
        let friendService = FriendsService()
        
        do {
            let success = try await friendService.deleteFriend(urlString: apiUrl)
            if success {
                print("Friend successfully deleted!")
                show.toggle()
                snackBarText = "\(friendName) is removed from the friend list"
                return 200
            } else {
                print("Failed to delete friend.")
                return 400
            }
        } catch let error as NSError {
            print("Error deleting friend: \(error.localizedDescription)")
            return error.code
        }
    }
    func reverseDeleteFriend(friendId: String) async -> Int {
        let apiUrl = SupabaseConfig.baseURL + "rest/v1/friends?user_id=eq.\(friendId)" + "&friend_id=eq.\(currentUserId ?? "")"
        let friendService = FriendsService()
        do {
            let success = try await friendService.deleteFriend(urlString: apiUrl)
            if success {
                print("Friend successfully Reverse- deleted!")
                return 200
            } else {
                print("Failed to delete friend.")
                return 400
            }
        } catch let error as NSError {
            print("Error deleting friend: \(error.localizedDescription)")
            return error.code
        }
    }
    func createReverseJsonObject(friendId: String) -> Data? {
        let friendId = friendId
        let jsonObject: [String: Any] = [
            "user_id" : friendId,
            "friend_id": currentUserId
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            return jsonData
        } catch {
            print("Error creating JSON: \(error.localizedDescription)")
            return nil
        }
    }

    func createUrlAddFriend()  {
        url = SupabaseConfig.baseURL + "rest/v1/friends"
    }

    func addFriend(friendId: String) async -> Int {
        let friendId = friendId
        createUrlAddFriend()
        guard let jsonData = createJsonObject(friendId: friendId) else {
            print("Failed to create JSON data.")
            return 500
        }
        let userService = UserService()
        do {
            let success = try await userService.addUser(urlString: url, jsonData: jsonData)
            if success {
                print("User registered successfully!")
                return 200
            }
        } catch let error as NSError {
            print("Failed to register user: \(error.localizedDescription)")
            return error.code
        }
        return 500
    }
    func reverseAddFriend(friendId: String) async -> Int {
        let friendId = friendId
        createUrlAddFriend()
        guard let jsonData = createReverseJsonObject(friendId: friendId) else {
            print("Failed to create JSON data.")
            return 500
        }
        let userService = UserService()
        do {
            let success = try await userService.addUser(urlString: url, jsonData: jsonData)
            if success {
                print("User registered successfully!")
                return 200
            }
        } catch let error as NSError {
            print("Failed to register user: \(error.localizedDescription)")
            return error.code
        }
        return 500
    }

}


