
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
    
    @ObservedObject var detailsViewModel = DetailsViewModel()
    @ObservedObject var userService = UserService()
    @ObservedObject var eventViewModel = EventViewModel.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State var showSheet: Bool = false
    @State var searchText: String = ""
    let selectedTab : Tab
    
    var body: some View {
        
        ZStack {
            VStack {
                AppBarView()
                ScrollView {
                    VStack{
                        FieldsCreateEvent(textFieldType: $detailsViewModel.title, fieldsCategory: DetailsViewModel.FieldsCategory.title.rawValue, textFieldPlaceholder: "")
                            .padding(5)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.TITLE)
                        FieldsCreateEvent(textFieldType: $detailsViewModel.description, fieldsCategory: DetailsViewModel.FieldsCategory.description.rawValue, textFieldPlaceholder: "")
                            .padding(5)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.DESCRIPTION)
                        FieldsCreateEvent(textFieldType: $detailsViewModel.city, fieldsCategory: DetailsViewModel.FieldsCategory.city.rawValue, textFieldPlaceholder: "")
                            .padding(5)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.CITY)
                        FieldsCreateEvent(textFieldType: $detailsViewModel.street, fieldsCategory: DetailsViewModel.FieldsCategory.street.rawValue, textFieldPlaceholder: "")
                            .padding(5)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.STREET)
                        FieldsCreateEvent(textFieldType: $detailsViewModel.place, fieldsCategory: DetailsViewModel.FieldsCategory.place.rawValue, textFieldPlaceholder: "")
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
                                VStack{
                                    TextField("Search...", text: $searchText, prompt: Text("Search..."))
                                        .accessibilityIdentifier(AccessibilityIdentifierConstants.USER_NAME)
                                        .autocapitalization(.none)
                                        .frame(width: 300, height: 15, alignment: .center)
                                        .padding()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.gray, lineWidth: 3)
                                        )
                                    Spacer()
                                }.padding(.top, 20)
                                    .presentationDetents([.fraction(0.7)])
                            }
                        }
                        
                        Divider()
                            .background(Color.dividerColor)
                            .frame(width:350)
                    }.padding(.top, 20)
                }
                
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
            }
            .applyBlurredBackground()
        }.ignoresSafeArea(.keyboard, edges: .all)
        
    }
    var DateAndTime : some View{
        
        HStack(spacing: 30) {
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
                .padding(.leading, 40)
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
