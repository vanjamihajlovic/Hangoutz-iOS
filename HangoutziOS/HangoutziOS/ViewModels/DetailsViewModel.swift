//
//  DetailsViewModel.swift
//  HangoutziOS
//
//  Created by Aleksa on 12/1/24.
//rest/v1/invites?select=users(name,avatar)&event_id=eq.6592910b-a891-42f6-8f35-c833589197da&event_status=eq.accepted

import Foundation
import SwiftUI

class DetailsViewModel: ObservableObject  {
    
    @AppStorage("currentUserId") var currentUserId : String?
    @Published var title : String = ""
    @Published var description : String = ""
    @Published var city : String = ""
    @Published var street : String = ""
    @Published var place : String = ""
    @Published var urlToGetAcceptedUsers : String = ""
    @Published var urlGetAvatarPhoto : String = ""
    @Published var urlToDeleteInvite : String = ""

    enum FieldsCategory: String {
        case title = "Title*"
        case description = "Description"
        case city = "City"
        case street = "Street"
        case place = "Place*"
    }
    func checkIfUserIsOwner(ownerOfEvent: String?) -> Bool {
        if(currentUserId == ownerOfEvent) {
            return true
        }
        else {return false}
    }
    func createUrlToGetAcceptedUsers(eventId: String?) {
        if let idOfEvent = eventId {
            urlToGetAcceptedUsers = SupabaseConfig.baseURL + "rest/v1/invites?select=users(name,avatar)&event_id=eq.\(idOfEvent)&event_status=eq.accepted"
        }
        else {return}
    }
    func createUrlToDeleteInvite(eventId : String?) {
        urlToDeleteInvite = SupabaseConfig.baseURL + "rest/v1/invites?user_id=eq.\(currentUserId)&event_id=eq.\(eventId)"
    }
}
