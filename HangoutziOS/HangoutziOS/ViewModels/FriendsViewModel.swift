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

    let testUsers = [
        Friend(name: "Milan Jovanović", avatar: "https://example.com/avatar1.png"),
        Friend(name: "Ana Petrović", avatar: "https://example.com/avatar2.png"),
        Friend(name: "Marko Marković", avatar: "https://example.com/avatar3.png"),
        Friend(name: "Ivana Savić", avatar: "https://example.com/avatar4.png"),
        Friend(name: "Stefan Milošević", avatar: "https://example.com/avatar5.png"),
        Friend(name: "Jelena Nikolić", avatar: "https://example.com/avatar6.png"),
        Friend(name: "Nikola Stojanović", avatar: "https://example.com/avatar7.png"),
        Friend(name: "Tamara Ilić", avatar: "https://example.com/avatar8.png")
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
