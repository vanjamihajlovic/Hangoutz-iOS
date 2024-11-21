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
    
    var body: some View {
        ZStack {
            VStack{
                Text("Event screen").font(.title).padding(30)
                Text("Logged in as user id: \(currentUserId)\n")
                Text("User email: \(currentUserEmail)")
            }
        }.navigationBarBackButtonHidden(true) 
    }
}

#Preview {
    EventScreen()
}
