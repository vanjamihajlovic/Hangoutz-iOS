//
//  MainTabView.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/21/24.
//

import SwiftUI

struct MainTabView: View {
    @AppStorage("currentUserId") var currentUserId: String?
    @AppStorage("currentUserEmail") var currentUserEmail: String?
    @State var currentTab = 0
    
    var body: some View {
        
        VStack(spacing: 0) {
            AppBarView()
            ZStack{
                TabView(selection: $currentTab ) {
                    EventScreen()
                        .tabItem {
                            Label("Events", systemImage: "calendar")
                        }
                        .tag(0)
                        .accessibilityIdentifier("eventIcon")
                    
                    FriendsView()
                        .tabItem {
                            Label("Friends", systemImage: "person.2.fill")
                        }
                        .tag(1)
                        .accessibilityIdentifier("friendsIcon")
                    
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "gearshape")
                        }
                        .tag(2)
                        .accessibilityIdentifier("settingsIcon")
                }
                .accessibilityIdentifier("bottomBar")
                .onAppear(){
                    let tabBarAppearance = UITabBarAppearance()
                    tabBarAppearance.configureWithOpaqueBackground()
                    tabBarAppearance.backgroundColor = UIColor.barColor
                    tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .white
                    tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .lightGray
                    tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                        .foregroundColor: UIColor.white
                    ]
                    tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                        .foregroundColor: UIColor.gray
                    ]
                    
                    UITabBar.appearance().standardAppearance = tabBarAppearance
                    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                }
            }
            .navigationBarBackButtonHidden(true)
        }
         
    }
}

#Preview {
    MainTabView()
}
