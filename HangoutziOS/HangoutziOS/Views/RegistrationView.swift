//
//  RegistrationView.swift
//  HangoutziOS
//
//  Created by User01 on 11/15/24.
//

import SwiftUI

struct RegistrationView: View {
    @State var nameRegistration = ""
    @State var emailRegistration = ""
    @State var passwordRegistration = ""
    @State var password2Registration = ""
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 30){
                GlobalLogoView()
                    .padding(.bottom,60)
                TextField("", text: $nameRegistration, prompt: Text("Name")
                    .foregroundColor(.white)
                )
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
                
                TextField("", text: $emailRegistration, prompt: Text("Email")
                    .foregroundColor(.white)
                )
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
                
                SecureField("", text: $passwordRegistration, prompt: Text("Password")
                    .foregroundColor(.white)
                )
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
                
                SecureField("", text: $password2Registration, prompt: Text("Re-enter password")
                    .foregroundColor(.white)
                )
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
                
                Button(action: {
                    //registration action here
                }){
                    
                }
                
        
                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .applyGlobalBackground()
        
    }
}

#Preview {
    RegistrationView()
}
