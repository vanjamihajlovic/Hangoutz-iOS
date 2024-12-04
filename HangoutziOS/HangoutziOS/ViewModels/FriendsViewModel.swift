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
    @Published var url: String = ""
    @AppStorage("currentUserId") var currentUserId: String?
    let friendsService = FriendsService()

    let testUsers: [Friend] = [
        Friend(name: "Ana Nikolić", avatar: "person.circle"),
        Friend(name: "Marko Jovanović", avatar: "person.circle.fill"),
        Friend(name: "Jelena Petrović", avatar: "star.circle"),
        Friend(name: "Ivan Ilić", avatar: "heart.circle"),
        Friend(name: "Sara Perić", avatar: "bolt.circle")
    ]
    
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
}
