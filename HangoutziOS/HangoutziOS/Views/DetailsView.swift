//
//  SwiftUIView.swift
//  HangoutziOS
//
//  Created by Aleksa on 12/1/24.
//

import SwiftUI

struct DetailsView: View {
    
    @ObservedObject var detailsViewModel = DetailsViewModel()
    
    var body: some View {
        
        ZStack {
            VStack{
                AppBarView()
                Spacer()
            }
            VStack {
                ScrollView {
                    VStack{
                        Fields(textFieldType: $detailsViewModel.title, fieldsCategory: DetailsViewModel.FieldsCategory.title.rawValue).padding(5)
                        Fields(textFieldType: $detailsViewModel.description, fieldsCategory: DetailsViewModel.FieldsCategory.description.rawValue).padding(5)
                        Fields(textFieldType: $detailsViewModel.city, fieldsCategory: DetailsViewModel.FieldsCategory.city.rawValue).padding(5)
                        Fields(textFieldType: $detailsViewModel.street, fieldsCategory: DetailsViewModel.FieldsCategory.street.rawValue)
                            .padding(5)
                        Fields(textFieldType: $detailsViewModel.place, fieldsCategory: DetailsViewModel.FieldsCategory.place.rawValue)
                            .padding(5)
                        Spacer()
                    }.padding(.top,80)
                    Text("Participants")
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                        .foregroundColor(.white)
                        .padding(.top, 20)
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
        }.applyGlobalBackground()
    }
}

#Preview {
    DetailsView()
}

struct Fields: View {
    
    @Binding var textFieldType : String
    var fieldsCategory: String
    
    var body: some View {
        VStack {
            Text("\(fieldsCategory)")
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 40)
                .foregroundColor(.white)
            TextField("", text: $textFieldType, prompt: Text("")
                .foregroundColor(.white))
            .accessibilityIdentifier(AccessibilityIdentifierConstants.USER_NAME)
            .autocapitalization(.none)
            .frame(width: 320, height: 25, alignment: .center)
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
