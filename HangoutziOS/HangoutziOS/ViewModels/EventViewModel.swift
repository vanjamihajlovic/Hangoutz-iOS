//
//  EventViewModel.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/22/24.
//

import Foundation
import SwiftUICore
import SwiftUI

class EventViewModel : ObservableObject {
    @Published var url: String = ""
    @Published var urlCount: String = ""
    @ObservedObject var eventService = EventService.shared
    @Published var events: [eventModelDTO] = []
    @Published var count: Int = 0
    @AppStorage("currentUserId") var currentUserId: String?
    static let shared = EventViewModel()
    
    private init() {
    }
    
    
    func performApiLogic(for tab: Tab) {
        switch tab {
        case .going:
            Task{
                await createUrlEventFilteredGoing()
                await getEvents()
            }
        case .invited:
            Task{
                await createUrlEventFilteredInvited()
                await getEvents()
            }
        case .mine:
            Task{
                await createUrlEventMine()
                await getEvents()
            }
        }
    }
    
        
        func createUrlEventNonfiltered() async {
            url = SupabaseConfig.baseURL + SupabaseConstants.SELECT_EVENTS
        }
        
        func createUrlEventFilteredGoing() async {
            url = SupabaseConfig.baseURL + SupabaseConstants.SELECT_GOING_EVENTS + (currentUserId ?? " ")
        }
        
        func createUrlEventFilteredInvited() async {
            url = SupabaseConfig.baseURL + SupabaseConstants.SELECT_INVITED_EVENTS + (currentUserId ?? " ")
        }
        
        func createUrlEventMine() async {
            url = SupabaseConfig.baseURL + SupabaseConstants.SELECT_MINE_EVENTS + (currentUserId ?? " ")
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
    

