//
//  CreateEventViewModel.swift
//  HangoutziOS
//
//  Created by Aleksa on 12/6/24.
//
import Foundation
import SwiftUICore
import SwiftUI

class CreateEventViewModel : FriendsViewModel {
    
    @Published var selectedDate = Date()
    @Published var selectedTime = Date()
    @Published var title : String = ""
    @Published var description : String = ""
    @Published var city : String = ""
    @Published var street : String = ""
    @Published var place : String = ""
    @Published var myFriends: [Friend] = []
    let myFriendsService = FriendsService()    
    
    enum FieldsCategory: String {
        case title = "Title*"
        case description = "Description"
        case city = "City"
        case street = "Street"
        case place = "Place*"
    }
    override func getFriends() async {
        guard let userId = currentUserId else {
            print("Current user ID is nil.")
            return
        }
        url = SupabaseConfig.baseURL + SupabaseConstants.GET_FIRENDS_VIA_ID + userId
        let fetchedFriends = await myFriendsService.getFriends(from: url)
        await MainActor.run {
            self.myFriends = fetchedFriends
        }
    }
    
    override var filteredFriends: [Friend] {
        if searchText.count >= 3 {
            return myFriends.filter { friend in
                let firstWord = friend.name.components(separatedBy: " ").first ?? ""
                return firstWord.localizedCaseInsensitiveContains(searchText)
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
}
