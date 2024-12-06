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
}
