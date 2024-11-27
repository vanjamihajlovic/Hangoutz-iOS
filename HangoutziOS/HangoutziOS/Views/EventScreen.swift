//
//  EventScreen.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/20/24.
//

import SwiftUI

struct EventScreen: View {
    
    @AppStorage("currentUserId") var currentUserId: String?
    @AppStorage("currentUserEmail") var currentUserEmail: String?
    @AppStorage("currentUserName") var currentUserName: String?
    
    var body: some View {
        ZStack {
            Image.backgroundImage
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                AppBarView()
                Spacer()
                
            }
            Group {
                VStack{
                    Text("Event Screen")
                    Text("Logged in as user id: \(currentUserId)\n")
                    Text("User name: \(currentUserName)")
                    Text("User email: \(currentUserEmail)")
                }
            }
            .foregroundColor(.white)
        }
    }
}

#Preview {
    EventScreen()
}
