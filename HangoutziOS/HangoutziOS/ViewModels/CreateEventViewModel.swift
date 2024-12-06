//
//  CreateEventViewModel.swift
//  HangoutziOS
//
//  Created by Aleksa on 12/6/24.
//
import Foundation
import SwiftUICore
import SwiftUI

class CreateEventViewModel : ObservableObject {
    
    @AppStorage("currentUserId") var currentUserId: String?
    @Published var selectedDate = Date()
    @Published var selectedTime = Date()
    @Published var friends: [Friend] = []
    @Published var url: String = ""
    @Published var title : String = ""
    @Published var description : String = ""
    @Published var city : String = ""
    @Published var street : String = ""
    @Published var place : String = ""
    
    let friendsService = FriendsService()
    
    enum FieldsCategory: String {
        case title = "Title*"
        case description = "Description"
        case city = "City"
        case street = "Street"
        case place = "Place*"
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
}
