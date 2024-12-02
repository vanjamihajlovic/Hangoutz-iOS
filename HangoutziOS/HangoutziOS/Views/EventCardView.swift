//
//  EventCard.swift
//  HangoutziOS
//
//  Created by User03 on 12/2/24.
//
import SwiftUI

struct EventCard : View {
    let event: eventModelDTO
    let color : Color
    @ObservedObject var userViewModel : UserViewModel = UserViewModel()
    @ObservedObject var eventViewModel = EventViewModel.shared
    @StateObject var eventService = EventService.shared
    
    var body: some View {
        let dateTimeString = eventViewModel.createDateTimeString(event: event)
        let eventPlaceString = eventViewModel.createEventPlaceString(event: event)
        
        NavigationStack{
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
                            .accessibilityIdentifier("cardImage")
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text(event.title ?? "No Title")
                            .accessibilityIdentifier("cardImage")
                            .foregroundColor(.white)
                            .bold()
                            .font(.title2)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(eventPlaceString)
                            .accessibilityIdentifier("cardPlace")
                            .bold()
                            .font(.title3)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing)
                        Text(dateTimeString)
                            .accessibilityIdentifier("cardTime")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                }
                
                HStack{
                    Spacer()
                    if(eventViewModel.count == 1){
                        Text("\(eventViewModel.count) person going")
                            .accessibilityIdentifier("cardPeopleGoing")
                            .foregroundColor(.white)
                            .padding(.trailing)
                            .font(.caption)
                            .lineLimit(1)
                    }else {
                        Text("\(eventViewModel.count) people going")
                            .accessibilityIdentifier("cardPeopleGoing")
                            .foregroundColor(.white)
                            .padding(.trailing)
                            .font(.caption)
                            .lineLimit(1)
                    }
                }
                .padding(.top, 90)
            }
            .accessibilityIdentifier("card")
            .background(color)
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(color))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .onAppear() {
                Task{
                    await eventViewModel.createUrlPeopleGoingCount(idEvent: event.id ?? "")
                    await eventViewModel.getCount()
                }
            }
        }
    }
}
