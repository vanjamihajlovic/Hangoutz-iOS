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
        
            ZStack {
                NavigationLink(destination: DetailsView(event: event)) {
                    HStack(){
                        
                        if let avatarImage = event.users?.avatar {
                            AsyncImage(url: URL(string: SupabaseConfig.baseURLStorage + avatarImage), content: { Image in Image
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                    .frame(width: UIConstants.AVATAR_FRAME_WIDTH, height: UIConstants.AVATAR_FRAME_HEIGHT)
                                    .padding(.bottom,UIConstants.AVATAR_PADDING_BOTTOM)
                                    .padding(.trailing, UIConstants.AVATAR_PADDING_TRAILING)
                            }, placeholder: {
                                ProgressView()
                                    .frame(width: UIConstants.AVATAR_FRAME_WIDTH, height: UIConstants.AVATAR_FRAME_HEIGHT)
                                    .padding(.bottom,UIConstants.AVATAR_PADDING_BOTTOM)
                                    .padding(.trailing, UIConstants.AVATAR_PADDING_TRAILING)
                            }
                            )
                            .accessibilityIdentifier(IdentifierConstants.CARD_IMAGE)
                        } else {
                            Image("avatar_default")
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                .frame(width: UIConstants.AVATAR_FRAME_WIDTH, height: UIConstants.AVATAR_FRAME_HEIGHT)
                                .padding(.bottom,UIConstants.AVATAR_PADDING_BOTTOM)
                                .padding(.trailing, UIConstants.AVATAR_PADDING_TRAILING)
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text(event.title ?? "No Title")
                                .accessibilityIdentifier(IdentifierConstants.CARD_TITLE)
                                .foregroundColor(.white)
                                .bold()
                                .font(.title2)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(eventPlaceString)
                                .accessibilityIdentifier(IdentifierConstants.CARD_PLACE)
                                .bold()
                                .font(.title3)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.trailing)
                            Text(dateTimeString)
                                .accessibilityIdentifier(IdentifierConstants.CARD_TIME)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                    }
                }.onTapGesture {
                    DetailsView(event:event)
                }
                
                HStack{
                    Spacer()
                    if(eventViewModel.count == 1){
                        Text("\(eventViewModel.count) person going")
                            .accessibilityIdentifier(IdentifierConstants.CARD_PEOPLE_GOING)
                            .foregroundColor(.white)
                            .padding(.trailing)
                            .font(.caption)
                            .lineLimit(1)
                    }else {
                        Text("\(eventViewModel.count) people going")
                            .accessibilityIdentifier(IdentifierConstants.CARD_PEOPLE_GOING)
                            .foregroundColor(.white)
                            .padding(.trailing)
                            .font(.caption)
                            .lineLimit(1)
                    }
                }
                .padding(.top, 90)
            }
            .groupBoxAccessibilityIdentifier(IdentifierConstants.CARD)
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

struct ContainerGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
    }
}
