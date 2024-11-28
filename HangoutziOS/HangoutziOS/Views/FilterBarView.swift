//
//  FilterBarView.swift
//  HangoutziOS
//
//  Created by User03 on 11/28/24.
//

import SwiftUI

struct FilterBarView: View {
    @State private var selectedTab: Tab = .going
    let badgeCount = 4
    
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
                        .offset(x: 40, y: -10) // Adjust for the badge position
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
    }
}

#Preview {
    FilterBarView()
}
