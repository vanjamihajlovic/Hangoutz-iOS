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
    
    @State var testFriends = [
        Friend(name: "John Doe", avatar: nil),
        Friend(name: "Jane Doe", avatar: nil)
    ]


    let friendsService = FriendsService()

//    func getFriends() async {
//        url = SupabaseConfig.baseURL + SupabaseConstants.GET_FIRENDS_VIA_ID + currentUserId! 
//        Task {
//            await friends = friendsService.getFriends(from: url)
//            print("url: \(url)")
//        }
//    }
    func testFunction() {
            // Test lista prijatelja
            friends = [
                Friend(name: "John Doe", avatar: nil),
                Friend(name: "Jane Doe", avatar: "avatar1.jpg"),
                Friend(name: "Alex Smith", avatar: nil),
                Friend(name: "Sarah Lee", avatar: "avatar3.jpg")
            ]
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
        
        print("url: \(url)")
    }

}
