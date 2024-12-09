
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
    @State private var navigateToMainTab = false
    @Environment(\.presentationMode) var presentationMode
    let selectedTab : Tab
    var body: some View {
        
        ZStack {
            VStack {
                AppBarView()
                
                ScrollView {
                    VStack{
                        FieldsCreateEvent(textFieldType: $createEventViewModel.title, fieldsCategory: DetailsViewModel.FieldsCategory.title.rawValue, textFieldPlaceholder: "")
                            .padding(5)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.TITLE)
                        FieldsCreateEvent(textFieldType: $createEventViewModel.description,fieldsCategory: DetailsViewModel.FieldsCategory.description.rawValue, textFieldPlaceholder: "")
                            .padding(5)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.DESCRIPTION)
                            
                        FieldsCreateEvent(textFieldType: $createEventViewModel.city, fieldsCategory: DetailsViewModel.FieldsCategory.city.rawValue, textFieldPlaceholder: "")
                            .padding(5)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.CITY)
                        FieldsCreateEvent(textFieldType: $createEventViewModel.street, fieldsCategory: DetailsViewModel.FieldsCategory.street.rawValue, textFieldPlaceholder: "")
                            .padding(5)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.STREET)
                        FieldsCreateEvent(textFieldType: $createEventViewModel.place, fieldsCategory: DetailsViewModel.FieldsCategory.place.rawValue, textFieldPlaceholder: "")
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
                            Image("AddButtonImage")
                                .resizable()
                                .frame(width:40, height:40)
                                .padding(.trailing, 20)
                        }
                        
                        Divider()
                            .background(Color.dividerColor)
                            .frame(width:350)
                    }.padding(.top, 20)
                }
                
                if let emptyError = createEventViewModel.emptyError {
                    Text(emptyError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                if let dateError = createEventViewModel.dateError {
                    Text(dateError)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.bottom,5)
                }
                
                if let descriptionError = createEventViewModel.descriptionError {
                    Text(descriptionError)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.bottom,5)
                }
                
                NavigationLink(
                    destination: MainTabView(selectedTab: .created)
                        .navigationBarBackButtonHidden(true),
                    isActive: $navigateToMainTab,
                    label: {
                        Button(action: {
                            createEventViewModel.createCreateEventURLAndInstance()
                            createEventViewModel.assembleDate()
                            createEventViewModel.createEvent()
                            if createEventViewModel.validateFields() {
                                navigateToMainTab = true
                            }
                        }) {
                            HStack {
                                Text(StringConstants.CREATE)
                                Image.doorRightHandOpen
                            }
                            .padding()
                            .frame(width: 310)
                            .background(Color.loginButton)
                            .cornerRadius(20)
                            .foregroundColor(.black)
                        }
                    }
                )
                .accessibilityIdentifier(AccessibilityIdentifierConstants.LOGOUT)
                .padding(.bottom, 20)
            }
            .applyBlurredBackground()
        }
    }
    var DateAndTime : some View{
        
        HStack(spacing: 30) {
            HStack {
                DatePicker("", selection: $createEventViewModel.selectedDate, displayedComponents: .date)
                    .labelsHidden()
                    .tint(.white)
                    .onChange(of: createEventViewModel.selectedDate) { newDate in
                            print("Selected Date Picker Value: \(newDate)")
                        }
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
                    .onChange(of: createEventViewModel.selectedDate) { newDate in
                            print("Selected Time Picker Value: \(newDate)")
                        }
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
