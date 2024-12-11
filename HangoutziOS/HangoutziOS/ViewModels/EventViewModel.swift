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
    @Published var urlCountPeople: String = ""
    @Published var urlCountBadge: String = ""
    @Published var urlPatch: String = ""
    @ObservedObject var eventService = EventService.shared
    @Published var events: [eventModelDTO] = []
    @Published var count: Int = 0
    @AppStorage("currentUserId") var currentUserId: String?
    @Published var updateStatus: String = ""
    @Published var isLoading: Bool = false
    @Published var badgeCount = 0
    var changeTo: String = ""
    
    static let shared = EventViewModel()
    
        func createInvitationUpdateUrl(eventId: String, userId: String, change: String) {
            changeTo = change
            urlPatch = SupabaseConfig.baseURL + SupabaseConstants.SET_EVENT_STATUS_ACC_DEC_1 + eventId + SupabaseConstants.SET_EVENT_STATUS_ACC_DEC_2 + userId
        }

        func updateInvitation() {
            let url = urlPatch
            eventService.updateInvitationStatus(fromURL: url, changeTo: changeTo) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.updateStatus = "Invitation Accepted!"
                    case .failure(let error):
                        self.updateStatus = "Failed to accept invitation: \(error.localizedDescription)"
                    }
                }
            }
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
            case .created:
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
            urlCountPeople = SupabaseConfig.baseURL + SupabaseConstants.SELECT_PEOPLE_COUNT + idEvent
        }
    
        func createUrlInvitedEventsCount(idUser: String) async {
            urlCountBadge = SupabaseConfig.baseURL + SupabaseConstants.SELECT_INVITED_COUNT + idUser
        }
        
        func getEvents() async {
            Task {
                isLoading = true
                defer { isLoading = false }
                await events = eventService.getEvents(from: url)
            }
        }
        
        func createDateTimeString(event: eventModelDTO) -> String {
            return (event.date?.formattedWithOrdinal() ?? "") + " @ " + (event.date?.justTime() ?? "")
        }
        
        func createEventPlaceString(event: eventModelDTO) -> String {
            return ("@ " + (event.place ?? "No Place"))
        }
        
        func getPeopleCount() async {
            Task{
                await count = 1 + (eventService.getCount(from: urlCountPeople) ?? 0)
            }
        }
    
        func getBadgeCount() async {
            Task{
                await badgeCount = eventService.getCount(from: urlCountBadge)!
            }
        }
    
        
    }
    

