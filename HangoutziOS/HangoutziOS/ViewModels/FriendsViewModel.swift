//
//  FriendsViewModel.swift
//  HangoutziOS
//
//  Created by User01 on 11/29/24.
//

import Foundation
import SwiftUICore

class FriendsViewModel : ObservableObject {
//    
//    ListOfFriends: Codable, Identifiable {
//        let id = UUID() // Automatski generisan ID za grupu
//        let users: FriendModel
//    }

    @Published var friends: [FriendModel] = []
    @Published var url: String = ""
    @ObservedObject var friendsService = FriendsService.shared
    
    func getFriends() async {
        Task {
            await friends = friendsService.getFriends(from : "https://zsjxwfjutstrybvltjov.supabase.co/rest/v1/friends?select=users!friend_id(name,avatar)&user_id=eq.0d1e1ace-d426-4734-876c-701784de75bb")
        }
    }
}
