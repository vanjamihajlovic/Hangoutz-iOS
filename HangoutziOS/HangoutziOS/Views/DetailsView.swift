//
//  SwiftUIView.swift
//  HangoutziOS
//
//  Created by Aleksa on 12/1/24.
//  DetailsView.swift
//  HangoutziOS
//
//
import SwiftUI

struct DetailsView: View {
    
    @ObservedObject var detailsViewModel = DetailsViewModel()
    @ObservedObject var userService = UserService()
    @ObservedObject var eventViewModel = EventViewModel.shared
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State var isOwner : Bool = false
    let event : eventModelDTO
    let selectedTab : Tab
    var body: some View {
        
        ZStack {
            VStack {
                ZStack{
                        AppBarView()
                        Image(detailsViewModel.checkIfUserIsOwner(ownerOfEvent: event.owner ?? "") ? StringConstants.DELETE : "").resizable()
                        .frame(width : 30, height: 30, alignment: .trailing)
                        .padding(.leading, 300)
                        .padding(.bottom, 10)
                            
                    
                }
                ScrollView {
                    VStack{
                        Fields(textFieldType: $detailsViewModel.title, fieldsCategory: DetailsViewModel.FieldsCategory.title.rawValue, textFieldPlaceholder: event.title ?? "").padding(5).disabled(detailsViewModel.checkIfUserIsOwner(ownerOfEvent: event.owner ?? "") ? false : true)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.TITLE)
                        Fields(textFieldType: $detailsViewModel.description, fieldsCategory: DetailsViewModel.FieldsCategory.description.rawValue, textFieldPlaceholder: event.description ?? "").padding(5)
                            .disabled(detailsViewModel.checkIfUserIsOwner(ownerOfEvent: event.owner ?? "") ? false : true)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.DESCRIPTION)
                        Fields(textFieldType: $detailsViewModel.city, fieldsCategory: DetailsViewModel.FieldsCategory.city.rawValue, textFieldPlaceholder: event.city ?? "").padding(5).disabled(detailsViewModel.checkIfUserIsOwner(ownerOfEvent: event.owner ?? "") ? false : true)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.CITY)
                        Fields(textFieldType: $detailsViewModel.street, fieldsCategory: DetailsViewModel.FieldsCategory.street.rawValue, textFieldPlaceholder: event.street ?? "")
                            .padding(5).disabled(detailsViewModel.checkIfUserIsOwner(ownerOfEvent: event.owner ?? "") ? false : true)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.STREET)
                        Fields(textFieldType: $detailsViewModel.place, fieldsCategory: DetailsViewModel.FieldsCategory.place.rawValue, textFieldPlaceholder: event.place ?? "")
                            .padding(5).disabled(detailsViewModel.checkIfUserIsOwner(ownerOfEvent: event.owner ?? "") ? false : true)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.PLACE)
                        
                        Spacer()
                        
                        if(detailsViewModel.currentUserId == event.owner){
                            DateAndTime
                        }
                        HStack{
                            Text(StringConstants.PARTICIPANTS)
                                .font(.title2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 30)
                                .foregroundColor(.white)
                                .padding(.top, 10)
                            Image(detailsViewModel.checkIfUserIsOwner(ownerOfEvent: event.owner ?? "") ? StringConstants.ADD_BUTTON : "")
                                .resizable()
                                .frame(width:40, height:40)
                                .padding(.trailing, 20)
                        }
                        Divider()
                            .background(Color.dividerColor)
                            .frame(width:350)
                        
                        ForEach(userService.acceptedEventUsers.indices, id: \.self){ index in
                            HStack{
                                AsyncImage(url: URL(string:SupabaseConfig.baseURLStorage + (userService.acceptedEventUsers[index].users.avatar ?? SupabaseConfig.avatarDefault)), content: { Image in Image
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color.dividerColor, lineWidth: 2)
                                        )
                                        .frame(width: 40, height: 40)
                                }, placeholder: {
                                    ProgressView()
                                }
                                )
                                Text(userService.acceptedEventUsers[index].users.name).font(.title3).foregroundColor(.white).padding(.leading, 10)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 35)
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                                .accessibilityIdentifier(AccessibilityIdentifierConstants.PARTICIPANTS)
                            Divider()
                                .background(Color.dividerColor)
                                .frame(width:350)
                        }
                    }
                }
                Button(action: {
                    deleteInvite()
                    print("Button pressed! \n URL to delete invite: \(detailsViewModel.urlToDeleteInvite)\n")
                }){
                    NavigationLink(destination: EventView().navigationBarBackButtonHidden(true)){
                        HStack {
                            Text(detailsViewModel.checkIfUserIsOwner(ownerOfEvent: event.owner ?? "") ? StringConstants.UPDATE : StringConstants.LEAVE_EVENT)
                            if(!detailsViewModel.checkIfUserIsOwner(ownerOfEvent: event.owner ?? "")){Image.doorRightHandOpen}
                        }
                    }.onTapGesture {
                        eventViewModel.performApiLogic(for: selectedTab)
                        MainTabView()
                    }
                    .onDisappear{
                        eventViewModel.performApiLogic(for: selectedTab)
                        MainTabView()
                    }
                    .padding()
                    .frame(width:310)
                    .background(Color.loginButton)
                    .cornerRadius(20)
                    .foregroundColor(.black)
                }
                .padding(.bottom, 20)
                .accessibilityIdentifier(AccessibilityIdentifierConstants.LOGOUT)
                
            }.onAppear{getAcceptedUsers()}
                .applyBlurredBackground()
        }.ignoresSafeArea(.keyboard, edges: .all)
        
    }
    var DateAndTime : some View{
        
        HStack(spacing: 30) {
            //Date
            HStack {
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .labelsHidden()
                    .tint(.white)
                    .foregroundColor(.white)
                Image(systemName: ImageConstants.CALENDAR)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3)
            )
            .background(Color.clear)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityIdentifier(AccessibilityIdentifierConstants.DATE)
            
            HStack {
                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .environment(\.locale, Locale(identifier: "en_GB"))
                    .tint(.white)
                    .foregroundColor(.white)
                Image(systemName: ImageConstants.CLOCK)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3)
            )
            .background(Color.clear)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityIdentifier(AccessibilityIdentifierConstants.TIME)
        }.padding()
            .padding(.leading, -3)
        
    }
    
    func getAcceptedUsers() {
        Task {
            detailsViewModel.createUrlToGetAcceptedUsers(eventId: event.id)
            print("URL to get acceptedUsers: \(detailsViewModel.urlToGetAcceptedUsers)\n")
            await userService.getAcceptedUsers(from: detailsViewModel.urlToGetAcceptedUsers)
            print("Accepted users data: \(userService.acceptedEventUsers)")
            print("User name is : \(userService.acceptedEventUsers.first?.users.name)\n")
            print("User avatar is : \(userService.acceptedEventUsers.first?.users.avatar)\n")
        }
    }
    func deleteInvite() {
        detailsViewModel.createUrlToDeleteInvite(eventId: event.id)
        userService.deleteInvite(url: detailsViewModel.urlToDeleteInvite)
    }
}

struct Fields: View {
    
    @Binding var textFieldType : String
    var fieldsCategory: String
    var textFieldPlaceholder : String
    
    var body: some View {
        VStack {
            Text("\(fieldsCategory)")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 40)
                .foregroundColor(.white)
            TextField("", text: $textFieldType, prompt: Text(textFieldPlaceholder)
                .foregroundColor(.white))
            .accessibilityIdentifier(AccessibilityIdentifierConstants.USER_NAME)
            .autocapitalization(.none)
            .frame(width: 320, height: 15, alignment: .center)
            .foregroundColor(.white)
            .padding()
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3)
            )
        }
    }
    
}


