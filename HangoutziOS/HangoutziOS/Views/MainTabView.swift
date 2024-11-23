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
        
        ZStack{
            TabView(selection: $currentTab ) {
                EventScreen()
                    .tabItem {
                        Image(systemName: "calendar")
                    }
                    .tag(0)
                
                FriendsView()
                    .tabItem {
                        Image(systemName: "person.2.fill")
                    }
                    .tag(1)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "gearshape")
                    }
                    .tag(2)
            }
            .onAppear(){
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithOpaqueBackground()
                tabBarAppearance.backgroundColor = UIColor.barColor
                tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .white
                tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .lightGray
                
                UITabBar.appearance().standardAppearance = tabBarAppearance
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
        .navigationBarBackButtonHidden(true) 
    }
}


#Preview {
    MainTabView()
}
