//
//  EventScreen.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/21/24.
//

import SwiftUI

struct EventScreen: View {
    @ObservedObject var eventViewModel = EventViewModel.shared
    @StateObject var eventService = EventService.shared
    
    let colors: [Color] = [Color.firstEventCard, Color.secondEventCard, Color.thirdEventCard]
    
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
                        let color = colors[index % colors.count]
                        
                       
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

struct EventCard : View {
    let event: eventModelDTO
    let color : Color
    @ObservedObject var userService : UserService = UserService()
    @ObservedObject var userViewModel : UserViewModel = UserViewModel()
    @ObservedObject var eventViewModel = EventViewModel.shared
    @StateObject var eventService = EventService.shared
    
    var body: some View {
    
        let dateTimeString = (event.date?.formattedWithOrdinal() ?? "") + " @ " + (event.date?.justTime() ?? "")
        ZStack {
            HStack(){
                
                if let avatarImage = event.users?.avatar {
                    AsyncImage(url: URL(string: SupabaseConfig.baseURLStorage + avatarImage), content: { Image in Image
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(Circle())
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.white, lineWidth: 2)
                                                )
                                                .frame(width: 90, height: 90)
                                                .padding(.bottom,20)
                                                .padding(.trailing, 10)
                                        }, placeholder: {
                                            ProgressView()
                                        }
                                        )
                    .accessibilityIdentifier("cardImage")
                } else {
                    Circle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 80, height: 80)
                        .padding(.bottom,20)
                }
                    VStack(alignment: .leading, spacing: 5) {
                        Text(event.title ?? "No Title")
                            .foregroundColor(.white)
                            .bold()
                            .font(.title2)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .accessibilityIdentifier("cardTitle")
                        Text("@ " + (event.place ?? "No Place"))
                            .bold()
                            .font(.title3)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing)
                            .accessibilityIdentifier("cardPlace")
                        Text(dateTimeString)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .accessibilityIdentifier("cardTime")

                    }
                    .padding(.bottom, 20)
                    //.padding(.trailing, -5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                }
                
                HStack{
                    Spacer()
                    if(eventViewModel.count == 1){
                        Text("\(eventViewModel.count) person going")
                            .foregroundColor(.white)
                            .padding(.trailing)
                            .font(.caption)
                            .lineLimit(1)
                            .accessibilityIdentifier("cardPeopleGoing")
                    }else {
                        Text("\(eventViewModel.count) people going")
                            .foregroundColor(.white)
                            .padding(.trailing)
                            .font(.caption)
                            .lineLimit(1)
                            .accessibilityIdentifier("cardPeopleGoing")
                    }
                    
                }
                .padding(.top, 90)
            }
            .background(color)
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(color))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .accessibilityIdentifier("card")
            .onAppear() {
                Task{
                    await eventViewModel.createUrlPeopleGoingCount(idEvent: event.id ?? "")
                    await eventViewModel.getCount()
                }
            }
        }
    }
    


