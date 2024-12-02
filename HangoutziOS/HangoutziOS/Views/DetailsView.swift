//
//  SwiftUIView.swift
//  HangoutziOS
//
//  Created by Aleksa on 12/1/24.
//

import SwiftUI

struct DetailsView: View {
    
    @ObservedObject var detailsViewModel = DetailsViewModel()
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    //TODO: Implement logic to see if user is owner of event
    let event : eventModelDTO
    @State var isOwner : Bool = true
    var body: some View {
        
        ZStack {
            VStack{
                AppBarView()
                Spacer()
            }
            VStack {
                ScrollView {
                    VStack{
                        Fields(textFieldType: $detailsViewModel.title, fieldsCategory: DetailsViewModel.FieldsCategory.title.rawValue, textFieldPlaceholder: event.title ?? "").padding(5)
                        Fields(textFieldType: $detailsViewModel.description, fieldsCategory: DetailsViewModel.FieldsCategory.description.rawValue, textFieldPlaceholder: event.description ?? "").padding(5)
                        Fields(textFieldType: $detailsViewModel.city, fieldsCategory: DetailsViewModel.FieldsCategory.city.rawValue, textFieldPlaceholder: event.city ?? "").padding(5)
                        Fields(textFieldType: $detailsViewModel.street, fieldsCategory: DetailsViewModel.FieldsCategory.street.rawValue, textFieldPlaceholder: event.street ?? "")
                            .padding(5)
                        Fields(textFieldType: $detailsViewModel.place, fieldsCategory: DetailsViewModel.FieldsCategory.place.rawValue, textFieldPlaceholder: event.place ?? "")
                            .padding(5)
                        Spacer()
                        // Date Picker and time picker
                        if(isOwner){
                            HStack(spacing: 16) {
                                //Date
                                HStack {
                                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                        .labelsHidden()
                                        .tint(.white)
                                    Image(systemName: "calendar")
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
                                //Time
                                HStack {
                                    DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                        .tint(.white)
                                    Image(systemName: "clock")
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
                            }.padding()
                                .padding(.leading, 10)
                        }
                        Text("Participants")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 30)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        
                        Divider()
                            .background(Color.dividerColor)
                            .frame(width:350)
                        
                    }.padding(.top,70)
                    
                    
                }
                
                Button(action: {
                    
                }){
                    HStack {
                        Text(StringConstants.LEAVE_EVENT)
                        Image.doorRightHandOpen
                    }
                    .padding()
                    .frame(width:310)
                    .background(Color.loginButton)
                    .cornerRadius(20)
                    .foregroundColor(.black)
                }
                .padding(.bottom, 20)
                .accessibilityIdentifier(AccessibilityIdentifierConstants.LOGOUT)
            }
        }
        .applyBlurredBackground()
    }
}

//#Preview {
//    DetailsView()
//}

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
