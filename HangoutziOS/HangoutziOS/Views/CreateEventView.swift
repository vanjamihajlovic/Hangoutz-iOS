
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
    @StateObject var createEventFriendsPopupViewModel = CreateEventFriendsPopupViewModel()
    @StateObject var createEventViewModel = CreateEventViewModel()
    @StateObject var eventViewModel = EventViewModel.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State var showSheet: Bool = false
    @State var searchText: String = ""
    let selectedTab : Tab
    
    var body: some View {
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
                                PopupViewFriends(createEventFriendsPopupViewModel: createEventFriendsPopupViewModel)
                            }
                        }
                        
                        Divider()
                            .background(Color.dividerColor)
                            .frame(width:350)
                    }.padding(.top, 20)
                        .frame(maxWidth: .infinity)
                    
                    
                }
                ZStack{
                    VStack{
                        NavigationLink(destination: MainTabView().navigationBarBackButtonHidden(true)){
                            Button(action: {
                                //TODO: MAKE NAVIGATION ONLY TO CREATED. TICKET REQUIREMENT!!
                            }){
                                
                                HStack {
                                    Text(StringConstants.CREATE)
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
                    }
                } .ignoresSafeArea(.keyboard, edges: .all)
                
            }
            .applyBlurredBackground()
        }.onAppear{
            Task{
                await createEventFriendsPopupViewModel.getFriends()
            }
        }
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
    
    @StateObject var createEventFriendsPopupViewModel : CreateEventFriendsPopupViewModel
    @State var isPressed : Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    TextField("", text: $createEventFriendsPopupViewModel.mySearchText,prompt:
                                Text("Search...")
                        .foregroundColor(Color.gray)
                    )
                    
                    .accessibilityIdentifier("friendsSearchField")
                    if !createEventFriendsPopupViewModel.mySearchText.isEmpty {
                        Button(action: {
                            createEventFriendsPopupViewModel.mySearchText = ""
                        }){
                            Image(systemName: "x.circle")
                                .foregroundColor(Color.gray)
                        }
                        .accessibilityIdentifier("friendsSearchFieldClearButton")
                    }
                }
                .padding(12)
                .frame(width: 340, height: 40, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .padding(.top, 30)
                
                if createEventFriendsPopupViewModel.sortedFriends.isEmpty{
                    Spacer()
                    Text("No friends found.")
                        .foregroundColor(Color.white)
                    Spacer()
                }
                else {
                    List {
                        ForEach(createEventFriendsPopupViewModel.sortedFriends) { friend in
                            HStack {
                                if let avatarImage = friend.avatar {
                                    AsyncImage(url: URL(string: SupabaseConfig.baseURLStorage + avatarImage),
                                               content:{ Image in
                                        Image
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(Color("FriendAddButton"), lineWidth: 4)
                                            )
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    }, placeholder: {
                                        Image("DefaultImage")
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(Color("FriendAddButton"), lineWidth: 2)
                                            )
                                            .frame(width: 50, height: 50)
                                            .accessibilityIdentifier("friendImagePlaceholder")
                                    }
                                    )
                                    .accessibilityIdentifier("friendImage")
                                } else {
                                    Image("DefaultImage")
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color("FriendAddButton"), lineWidth: 2)
                                        )
                                        .frame(width: 50, height: 50)
                                        .accessibilityIdentifier("defaultFriendImage")
                                    
                                }
                                Text(friend.name)
                                    .accessibilityIdentifier("friendName")
                                    .font(.headline)
                                    .foregroundColor(Color("FriendFontColor"))
                                Spacer()
                                Button(action: {isPressed.toggle()}){
                                    Image(systemName: isPressed ? "checkmark.square" : "square").resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(Color.black)
                                }
                            }
                            .groupBoxAccessibilityIdentifier("friendListItem")
                            
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            
        } .onAppear(){
            Task {
                await createEventFriendsPopupViewModel.getFriends()
            }
        }
    }
}
