//
//  EventScreen.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/21/24.
//

import SwiftUI

struct EventView: View {
    @ObservedObject var eventViewModel = EventViewModel.shared
    @State private var swipeIndex: Int = 0
    @AppStorage("currentUserId") var currentUserId: String?
    @AppStorage("currentUserEmail") var currentUserEmail: String?
    @AppStorage("currentUserName") var currentUserName: String?
    @State private var selectedTabIndex: Int = 0
    @State var selectedTab: Tab = .going
    @State private var isPolling: Bool = false
    
    var body: some View {
        ZStack {
                VStack {
                    HStack {
                        ForEach(Tab.allCases, id: \.self) { tab in
                            ZStack {
                                if selectedTab == tab {
                                    Capsule()
                                        .fill(Color.filterBarAccentColor)
                                        .frame(height: 40)
                                        .padding(.horizontal, 8)
                                        .shadow(radius: 3)
                                }
                                
                                Text(tab.rawValue)
                                    .accessibilityIdentifier(tab.rawValue.lowercased())
                                    .frame(maxWidth: .infinity)
                                    .font(.footnote)
                                    .bold()
                                    .foregroundColor(selectedTab == tab ? Color.filterBarSelectedTextColor : Color.filterBarAccentColor)
                                    .padding(.horizontal, 20)
                                    .onTapGesture {
                                        withAnimation{
                                            selectedTab = tab
                                            eventViewModel.performApiLogic(for:tab)
                                        }
                                    }
                                if tab == .invited {
                                    if eventViewModel.badgeCount > 0 {
                                        ZStack {
                                            Circle()
                                                .fill(Color.red)
                                                .frame(width: 20, height: 20)
                                            Text("\(eventViewModel.badgeCount)")
                                                .foregroundColor(.white)
                                                .font(.caption)
                                                .bold()
                                        }
                                        .offset(x: 40, y: -10)
                                    }
                                }
                            }
                        }
                    }
                    .accessibilityIdentifier(IdentifierConstants.FILTER_BAR
                    )
                    .padding(5)
                    .background(
                        Capsule()
                            .fill(Color.filterBarPrimaryColor.opacity(0.5))
                    )
                    .padding(.horizontal, 16)
                    Spacer()
                }
                .padding(.top, 35)
            
            if eventViewModel.isLoading {
                ProgressView(StringConstants.LOADING_EVENTS)
                                .foregroundColor(.white)
                                .font(.headline)
                        } else if eventViewModel.events.isEmpty {
                            Text(StringConstants.NO_EVENTS)
                                .foregroundColor(.white)
                                .font(.headline)
                                .accessibilityIdentifier(IdentifierConstants.NO_EVENTS_TEXT)
                        } else {
                            ScrollView{
                                VStack{
                                    ForEach(eventViewModel.events.indices, id:  \.self){ index in
                                        let event = eventViewModel.events[index]
                                        let color = ColorConstants.eventCardColors[index % ColorConstants.eventCardColors.count]
                                        
                                        EventCard(event:event,color:color, selTab:selectedTab)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: 700)
                            .padding(.top, 120)
                        }
                        
            
                VStack {
                    Spacer()
                  
                    HStack {
                        Spacer()
                       
                        ZStack {
                            NavigationLink(destination: CreateEventView()) {
                                Image.plusImage
                                .resizable()
                                .padding(.trailing, UIConstants.PLUS_SIGN_PADDING_TRAILING)
                                .padding(.bottom, UIConstants.AVATAR_PADDING_BOTTOM)
                                .frame(width: UIConstants.PLUS_SIGN_FRAME_WIDTH, height: UIConstants.PLUS_SIGN_FRAME_HEIGHT)
                                .accessibilityIdentifier(IdentifierConstants.NEW_EVENT_BUTTON)
                        }
                        }.onTapGesture {
                            CreateEventView()
                    }
                }
            }
        }
        .applyGlobalBackground()
        .gesture(
            DragGesture()
                .onEnded { value in
                    handleSwipe(value:value)
                }
            )
        .onAppear() {
            Task{
                await eventViewModel.createUrlEventFilteredGoing()
                await eventViewModel.getEvents()
                startPollingForBadgeCount()
            }
        }
    }
    
    private func handleSwipe(value: DragGesture.Value) {
        let allTabs = Tab.allCases
        let width = value.translation.width
        if width < UIConstants.MIN_HORIZONTAL_SWIPE {
            if let currentIndex = allTabs.firstIndex(of: selectedTab),
               currentIndex < allTabs.count - 1 {
                withAnimation {
                    selectedTab = allTabs[currentIndex + 1]
                    eventViewModel.performApiLogic(for: selectedTab)
                }
            }
        } else if width > UIConstants.MIN_HORIZONTAL_SWIPE {
            if let currentIndex = allTabs.firstIndex(of: selectedTab),
               currentIndex > 0 {
                withAnimation {
                    selectedTab = allTabs[currentIndex - 1]
                    eventViewModel.performApiLogic(for: selectedTab)
                }
            }
        }
    }
    
    private func startPollingForBadgeCount() {
            isPolling = true
            Task {
                while isPolling {
                    if let userId = currentUserId {
                        await eventViewModel.createUrlInvitedEventsCount(idUser: userId)
                        await eventViewModel.getBadgeCount()
                        }
                    try? await Task.sleep(nanoseconds: NumberConstants.BADGE_NANOSECONDS)
                }
            }
        }
}

#Preview {
    EventView()
}
