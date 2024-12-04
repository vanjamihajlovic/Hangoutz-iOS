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
    @State var badgeCount = 0
    @State var selectedTab: Tab = .going
    
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
                                .font(.headline)
                                .foregroundColor(selectedTab == tab ? Color.filterBarSelectedTextColor : Color.filterBarAccentColor)
                                .padding(.horizontal, 20)
                                .onTapGesture {
                                    withAnimation{
                                        selectedTab = tab
                                        eventViewModel.performApiLogic(for:tab)
                                    }
                                }
                            
                            if tab == .invited, badgeCount > 0 {
                                ZStack {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 20, height: 20)
                                    Text("\(badgeCount)")
                                        .foregroundColor(.white)
                                        .font(.caption)
                                        .bold()
                                }
                                .offset(x: 40, y: -10)
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
          
            ScrollView{
                VStack{
                    ForEach(eventViewModel.events.indices, id: \.self){ index in
                        let event = eventViewModel.events[index]
                        let color = ColorConstants.eventCardColors[index % ColorConstants.eventCardColors.count]
                        
                        EventCard(event:event,color:color)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 700)
            .padding(.top, 120)
            
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
            }
        }
    }
    
    private func handleSwipe(value: DragGesture.Value) {
        let allTabs = Tab.allCases
        
        if value.translation.width < UIConstants.MIN_HORIZONTAL_SWIPE {
            if let currentIndex = allTabs.firstIndex(of: selectedTab),
               currentIndex < allTabs.count - 1 {
                withAnimation {
                    selectedTab = allTabs[currentIndex + 1]
                    eventViewModel.performApiLogic(for: selectedTab)
                }
            }
        } else if value.translation.width > UIConstants.MIN_HORIZONTAL_SWIPE {
            if let currentIndex = allTabs.firstIndex(of: selectedTab),
               currentIndex > 0 {
                withAnimation {
                    selectedTab = allTabs[currentIndex - 1]
                    eventViewModel.performApiLogic(for: selectedTab)
                }
            }
        }
    }
}

#Preview {
    EventView()
}
