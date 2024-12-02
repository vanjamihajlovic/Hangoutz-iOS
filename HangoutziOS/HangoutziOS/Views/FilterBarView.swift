//
//  FilterBarView.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/28/24.
//

import SwiftUI

struct FilterBarView: View {
    @State var selectedTab: Tab = .going
    @State private var selectedTabIndex: Int = 0
    @ObservedObject var eventViewModel = EventViewModel.shared
    @State var badgeCount = 0
    
    
    enum Tab: String, CaseIterable {
        case going = "GOING"
        case invited = "INVITED"
        case mine = "MINE"
    }
    var body: some View {
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
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .foregroundColor(selectedTab == tab ? Color.filterBarSelectedTextColor : Color.filterBarAccentColor)
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            withAnimation{
                                selectedTab = tab
                                performApiLogic(for:tab)
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
        .padding(5)
                .background(
                    Capsule()
                        .fill(Color.filterBarPrimaryColor.opacity(0.5))
                )
                .padding(.horizontal, 16)
//                .gesture(
//                    DragGesture()
//                        .onEnded { gesture in
//                            if gesture.translation.width < -50 {
//                                if selectedTabIndex < Tab.allCases.count - 1 {
//                                    withAnimation {
//                                        selectedTabIndex += 1
//                                        performApiLogic(for: Tab.allCases[selectedTabIndex])
//                                    }
//                                }
//                            } else if gesture.translation.width > 50 {
//                                if selectedTabIndex > 0 {
//                                    withAnimation {
//                                        selectedTabIndex -= 1
//                                        performApiLogic(for: Tab.allCases[selectedTabIndex])
//                                    }
//                                }
//                            }
//                        }
//                    )
    }
    
    private func performApiLogic(for tab: Tab) {
        switch tab {
        case .going:
            Task{
                await eventViewModel.createUrlEventFilteredGoing()
                await eventViewModel.getEvents()
            }
        case .invited:
            Task{
                await eventViewModel.createUrlEventFilteredInvited()
                await eventViewModel.getEvents()
            }
        case .mine:
            Task{
                await eventViewModel.createUrlEventMine()
                await eventViewModel.getEvents()
            }
        }
    }
    
}

//#Preview {
//    FilterBarView()
//}
