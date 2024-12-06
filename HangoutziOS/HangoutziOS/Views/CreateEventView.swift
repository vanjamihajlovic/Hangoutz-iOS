
//  SwiftUIView.swift
//  HangoutziOS
//
//  Created by Aleksa on 12/1/24.
//  DetailsView.swift
//  HangoutziOS
//
//
import SwiftUI

struct CreateEventView: View {
    
    @StateObject var createEventViewModel = CreateEventViewModel()
    @StateObject var eventViewModel = EventViewModel.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State var showSheet: Bool = false
    @State var searchText: String = ""
    let selectedTab : Tab
    
    var body: some View {
       // ScrollView {
            ZStack {
                VStack {
                    AppBarView()
                    ScrollView {
                        VStack{
                            FieldsCreateEvent(textFieldType: $createEventViewModel.title, fieldsCategory: CreateEventViewModel.FieldsCategory.title.rawValue, textFieldPlaceholder: "")
                                .padding(5)
                                .accessibilityIdentifier(AccessibilityIdentifierConstants.TITLE)
                            FieldsCreateEvent(textFieldType: $createEventViewModel.description, fieldsCategory: CreateEventViewModel.FieldsCategory.description.rawValue, textFieldPlaceholder: "")
                                .padding(5)
                                .accessibilityIdentifier(AccessibilityIdentifierConstants.DESCRIPTION)
                            FieldsCreateEvent(textFieldType: $createEventViewModel.city, fieldsCategory: CreateEventViewModel.FieldsCategory.city.rawValue, textFieldPlaceholder: "")
                                .padding(5)
                                .accessibilityIdentifier(AccessibilityIdentifierConstants.CITY)
                            FieldsCreateEvent(textFieldType: $createEventViewModel.street, fieldsCategory: CreateEventViewModel.FieldsCategory.street.rawValue, textFieldPlaceholder: "")
                                .padding(5)
                                .accessibilityIdentifier(AccessibilityIdentifierConstants.STREET)
                            FieldsCreateEvent(textFieldType: $createEventViewModel.place, fieldsCategory: CreateEventViewModel.FieldsCategory.place.rawValue, textFieldPlaceholder: "")
                                .padding(5)
                                .accessibilityIdentifier(AccessibilityIdentifierConstants.PLACE)
                            
                            Spacer()
                            
                            DateAndTime
                            
                            HStack {
                                Text(StringConstants.PARTICIPANTS)
                                    .font(.title2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 15)
                                    .foregroundColor(.white)
                                Button(action: {showSheet.toggle()}){
                                    Image("AddButtonImage")
                                        .resizable()
                                        .frame(width:40, height:40)
                                        .padding(.trailing, 20)
                                }.sheet(isPresented: $showSheet){
                                    PopupViewFriends()
                                }
                            }
                            
                            Divider()
                                .background(Color.dividerColor)
                                .frame(width:350)
                        }.padding(.top, 20)
                            .frame(maxWidth: .infinity)
                        
                        
                    }
                    ZStack{
                        NavigationLink(destination: MainTabView().navigationBarBackButtonHidden(true)){
                            Button(action: {
                                //TODO: MAKE NAVIGATION ONLY TO CREATED. TICKET REQUIREMENT!!
                            }){
                                
                                HStack {
                                    Text(StringConstants.CREATE)
                                    Image.doorRightHandOpen
                                }
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
                            .padding(.bottom, 20)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.CREATE_EVENT)
                        }
                    }.ignoresSafeArea(.keyboard, edges: .all)
                }
                .applyBlurredBackground()
            }
        //}
    }
    var DateAndTime : some View{
        
        HStack(spacing: 30) {
            HStack {
                DatePicker("", selection: $createEventViewModel.selectedDate, displayedComponents: .date)
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
                DatePicker("", selection: $createEventViewModel.selectedTime, displayedComponents: .hourAndMinute)
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
        
}

struct FieldsCreateEvent: View {
    
    @Binding var textFieldType : String
    var fieldsCategory: String
    var textFieldPlaceholder : String
    
    var body: some View {
        VStack {
            Text("\(fieldsCategory)")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .foregroundColor(.white)
            TextField("", text: $textFieldType, prompt: Text(textFieldPlaceholder)
                .foregroundColor(.white))
            .accessibilityIdentifier(AccessibilityIdentifierConstants.USER_NAME)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .frame(width: 320, height: 15, alignment: .center)
            .foregroundColor(.white)
            .textContentType(.emailAddress)
            .padding()
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3)
            )
        }
    }
}

struct PopupViewFriends: View {
    @ObservedObject var friendViewModel = FriendsViewModel()
    @State private var excludedFriendIds: [String] = []
    
    var body: some View {
        ZStack {
            Color("AddFriendsPopupColor")
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    TextField("", text: $friendViewModel.searchUser,prompt:
                                Text("Search...")
                        .foregroundColor(Color.black)
                    )
                    .accessibilityIdentifier("usersSearchField")
                    .padding()
                    .onChange(of: friendViewModel.searchUser) { newValue in
                        if newValue.count >= 3 {
                            Task {
                                await friendViewModel.getUsersWhoAreNotFriends()
                            }
                        }
                    }
                    
                    if !friendViewModel.searchUser.isEmpty {
                        Button(action: {
                            friendViewModel.searchUser = ""
                        }){
                            Image(systemName: "x.circle")
                                .foregroundColor(Color.gray)
                        }
                        .accessibilityIdentifier("usersSearchFieldClearButton")
                    }
                }
                .padding(12)
                .cornerRadius(20)
                .frame(width: 320, height:60, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 1)
                        .frame(height: 40)
                )
                .padding(.top, 15)
                
                if friendViewModel.searchUser.count >= 3{
                    ScrollView{
                        ForEach(friendViewModel.notFriends){ user in
                            HStack{
                                if let avatarURL = user.avatar{
                                    AsyncImage(url: URL(string: avatarURL), content: {image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 47, height: 47)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color("FriendAddButton"), lineWidth: 2))
                                    }, placeholder: {
                                        Image("DefaultImage")
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(Color("FriendAddButton"), lineWidth: 2)
                                            )
                                            .frame(width: 47, height: 47)
                                            .accessibilityIdentifier("userImagePlaceholder")
                                    }
                                    )
                                    .accessibilityIdentifier("userImage")
                                } else {
                                    Image("DefaultImage")
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color("FriendAddButton"), lineWidth: 2)
                                        )
                                        .frame(width: 47, height: 47)
                                        .accessibilityIdentifier("defaultUserImage")
                                }
                                Text(user.name ?? "")
                                    .font(.title3).padding(.leading, 10)
                                    .foregroundColor(Color("FriendFontColor"))
                                    .accessibilityIdentifier("userName")
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                    })
                                    {
                                        Image("AddButtonImage")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                            .padding()
                                    }
                                    .accessibilityIdentifier("addUserButton")
                                }
                            }
                            .frame(maxWidth: 340, maxHeight: 50, alignment: .leading)
                            .padding(.leading, 35)
                            .groupBoxAccessibilityIdentifier("userListItem")
                            Divider()
                                .frame(height: 1)
                                .background(Color.black)
                                .frame(width: 340)
                                .shadow(color: .black.opacity(0.4), radius: 4, x: 2, y: 2)
                        }
                        Spacer()
                    }
                    .padding(.top, 30)
                }
                else {
                    Spacer()
                    Text("Search for new friends...")
                        .bold()
                    Spacer()
                }
            }
            .presentationDetents([.fraction(0.7)])
            .onAppear {
                Task {
                    await friendViewModel.getFriends()
                    await friendViewModel.getUsersWhoAreNotFriends()
                }
            }
        }
    }
}
