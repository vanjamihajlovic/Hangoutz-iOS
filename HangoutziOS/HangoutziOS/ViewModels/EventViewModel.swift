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
    @Published var urlCount: String = ""
    @ObservedObject var eventService = EventService.shared
    @Published var events: [eventModelDTO] = []
    @Published var count: Int = 0
    static let shared = EventViewModel()
    
    private init() {
    }
    
    func createUrlEventNonfiltered() async {
        url = SupabaseConfig.baseURL + SupabaseConstants.SELECT_EVENTS
    }
    
    func createUrlPeopleGoingCount(idEvent: String) async {
        urlCount = SupabaseConfig.baseURL + SupabaseConstants.SELECT_PEOPLE_COUNT + idEvent
    }
    
    func getEvents() async {
        Task {
            await events = eventService.getEvents(from: url)
        }
    }
    
    func createDateTimeString(event: eventModelDTO) -> String {
       return (event.date?.formattedWithOrdinal() ?? "") + " @ " + (event.date?.justTime() ?? "")
    }
    
    func createEventPlaceString(event: eventModelDTO) -> String {
        return ("@ " + (event.place ?? "No Place"))
    }
    
    func getCount() async {
        Task{
            await count = 1 + (eventService.getCount(from: urlCount) ?? 0)
        }
    }
    
}

