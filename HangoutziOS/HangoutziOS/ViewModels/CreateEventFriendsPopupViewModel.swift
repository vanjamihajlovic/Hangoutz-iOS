//
//  CreateEventFriendsPopupViewModel.swift
//  HangoutziOS
//
//  Created by Aleksa on 12/9/24.
//
import Foundation
import SwiftUICore
import SwiftUI

class CreateEventFriendsPopupViewModel : FriendsViewModel {
    @Published var mySearchUser = ""
    @Published var myUrl: String = ""
    @Published var mySearchText = ""
    @Published var myFriends: [Friend] = []
    let myFriendsService = FriendsService()
    

    override func getFriends() async {
        guard let userId = currentUserId else {
            print("Current user ID is nil.")
            return
        }
        myUrl = SupabaseConfig.baseURL + SupabaseConstants.GET_FIRENDS_VIA_ID + userId
        let fetchedFriends = await myFriendsService.getFriends(from: myUrl)
        await MainActor.run {
            self.myFriends = fetchedFriends
        }
    }
    
    override var filteredFriends: [Friend] {
        if mySearchText.count >= 3 {
            return myFriends.filter { friend in
                let firstWord = friend.name.components(separatedBy: " ").first ?? ""
                return firstWord.localizedCaseInsensitiveContains(mySearchText)
            }
        } else {
            return myFriends
        }
    }
    override var sortedFriends: [Friend] {
        filteredFriends.sorted {
            let firstWord1 = $0.name.components(separatedBy: " ").first ?? $0.name
            let firstWord2 = $1.name.components(separatedBy: " ").first ?? $1.name
            return firstWord1.localizedCompare(firstWord2) == .orderedAscending
        }
    }
    
    func toggleFriendCheck(for friendID: String) {
            if let index = myFriends.firstIndex(where: { $0.id == friendID }) {
                myFriends[index].isChecked?.toggle()
            }
        }
}
