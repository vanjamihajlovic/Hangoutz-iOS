//
//  EventViewModel.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/22/24.
//

import Foundation
import SwiftUICore

class EventViewModel : ObservableObject {
    @Published var url: String = ""
    @Published var url2: String = ""
    @ObservedObject var eventService = EventService.shared
    @Published var events: [eventModelDTO] = []
    @Published var count: Int = 0
    static let shared = EventViewModel()
    
    private init() {
    }
    
    func createUrlEventNonfiltered() async {
        url = SupabaseConfig.baseURL + "rest/v1/events?select=*,users(avatar)&order=date"
    }
    
    func createUrlPeopleGoingCount(idEvent: String) async {
        url2 = SupabaseConfig.baseURL + "rest/v1/invites?select=count&event_status=eq.accepted&event_id=eq.\(idEvent)"
    }
    
    func getEvents() async {
        Task {
            await events = eventService.getEvents(from: url)
        }
    }
    
    func getCount() async {
        Task{
            await count = 1 + (eventService.getCount(from: url2) ?? 0) 
        }
    }
    
}

