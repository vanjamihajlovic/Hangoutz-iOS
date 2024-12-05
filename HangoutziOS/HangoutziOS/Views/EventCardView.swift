//
//  EventCard.swift
//  HangoutziOS
//
//  Created by strahinjamil on 12/2/24.
//
import SwiftUI

struct EventCard : View {
    let event: eventModelDTO
    let color : Color
    let tab : Tab
    @AppStorage("currentUserId") var currentUserId: String?
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
                            Image.avatarImage
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
                }
                if(tab != .invited){
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
                } else {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)){
                                eventViewModel.createInvitationUpdateUrl(eventId: event.id ?? "", userId: currentUserId ?? "" , change: StringConstants.DECLINED)
                                eventViewModel.updateInvitation()
                                eventViewModel.performApiLogic(for: .invited)
                                Task{
                                   await eventViewModel.createUrlInvitedEventsCount(idUser: currentUserId ?? "")
                                   await eventViewModel.getBadgeCount()
                                }
                            }
                                    }) {
                                        Text(StringConstants.DECLINE)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(width: 100, height: 25)
                                            .background(Color.declineButtonColor)
                                            .cornerRadius(15)
                                            .shadow(radius: 10, x: 0, y: 5)
                                            .accessibilityIdentifier(IdentifierConstants.DECLINE_BUTTON)
                                    }
                        Button(action: {
                                        withAnimation(.easeInOut(duration: 0.2)){
                                            eventViewModel.createInvitationUpdateUrl(eventId: event.id ?? "", userId: currentUserId ?? "" , change: StringConstants.ACCEPTED)
                                            eventViewModel.updateInvitation()
                                            eventViewModel.performApiLogic(for: .invited)
                                            Task{
                                               await eventViewModel.createUrlInvitedEventsCount(idUser: currentUserId ?? "")
                                               await eventViewModel.getBadgeCount()
                                            }
                                            
                                        }
                                    }){
                                        Text(StringConstants.ACCEPT)
                                            .foregroundColor(.filterBarSelectedTextColor)
                                            .padding()
                                            .frame(width: 100, height: 25)
                                            .background(Color.acceptButtonColor)
                                            .cornerRadius(15)
                                            .shadow(radius: 10, x: 0, y: 5)
                                            .accessibilityIdentifier(IdentifierConstants.ACCEPT_BUTTON)
                                    }
                    }
                    .padding(.top, 100)
                }
            }
            .groupBoxAccessibilityIdentifier(IdentifierConstants.CARD)
            .background(color)
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(color))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .onTapGesture {
                DetailsView(event:event)
            }
            .onAppear() {
                Task{
                    await eventViewModel.createUrlPeopleGoingCount(idEvent: event.id ?? "")
                    await eventViewModel.getPeopleCount()
                }
            }
        
    }
}

struct ContainerGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
    }
}
