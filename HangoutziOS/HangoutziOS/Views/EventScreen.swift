//
//  EventScreen.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/21/24.
//

import SwiftUI

struct EventScreen: View {
    @ObservedObject var eventViewModel = EventViewModel.shared
    @AppStorage("currentUserId") var currentUserId: String?
    @AppStorage("currentUserEmail") var currentUserEmail: String?
    @AppStorage("currentUserName") var currentUserName: String?
    
    var body: some View {
        ZStack {
            Image.backgroundImage
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                AppBarView()
                Spacer()
                
            }
        
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
        .onAppear() {
            Task{
                await eventViewModel.createUrlEventNonfiltered()
                await eventViewModel.getEvents()
            }
        }
    }
}

#Preview {
    EventScreen()
}
