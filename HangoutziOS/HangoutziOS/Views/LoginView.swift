//
//  LoginView.swift
//  HangoutziOS
//
//  Edited by alex64a on 11/14/24.
//

import SwiftUI

struct LoginView: View {
    
    //MARK: PROPERTIES
    let backgroundImage: String = "MainBackground"
    let logo: String = "Hangoutz"
    @State var email: String = ""
    @State var password: String = ""

    
    //MARK: BODY
    var body: some View {
        NavigationStack {
            ZStack{
                Image(backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                hangoutzLogo
                LoginSection(emailLogin: email, passwordLogin: password, isVisiblePassword: false)
                LoginOrCreateAccount()
            }//ZStack
        }//NavigationStack
        
    }//body
    
    //MARK: HANGOUTZ LOGO
    var hangoutzLogo: some View {
        VStack{
            Image(logo)
                .resizable()
                .scaledToFit()
                //Dimension and distance from top of the screen used from Figma
                .frame(width: 215, height: 50, alignment: .center)
                .padding(.top, 100)
                .padding(.trailing, 20)
            Spacer()
        }//VStack
    }//hangoutzLogo
    

}//LoginView
#Preview {
    LoginView()
}

//MARK: EMAIL AND PASSWORD
struct LoginSection: View {
    @State var emailLogin: String
    @State var passwordLogin: String
    @State var isVisiblePassword: Bool
    
    var body: some View {
        VStack{
            // Email TextField
            TextField("Email", text: $emailLogin)
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
                .padding(20)
            
            // Password SecureField
            HStack {
                SecureField("Password", text: $passwordLogin)
                    .autocapitalization(.none)
                    .frame(width: 320, height: 25, alignment: .center)
                    .foregroundColor(.white)
                    .textContentType(.emailAddress)
                    .padding()
                    .foregroundColor(.white)

            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 3)
                  

            )
        }//VStack
        .padding(.bottom, 80)
    }
}
//MARK: LOGIN OR CREATE ACCOUNT
struct LoginOrCreateAccount: View {
    var body: some View {
        VStack{
            Spacer()
            // Login Button
            Button(action: {
                // Handle login action here
            }) {
                HStack {
                    Text("Login")
                    Image(systemName: "door.right.hand.open")
                }
                .padding()
                .frame(width:310)
                .background(Color.loginButton)
                .cornerRadius(10)
                .foregroundColor(.black)
            }
            .padding(.horizontal, 40)
            
            // "OR" text
            Text("OR")
                .bold()
                .foregroundColor(.white)
                .padding(.top, 20)
            
            // Create Account NavigationLink
            NavigationLink(destination: {/*TODO: Destination to createAccountView */}, label:{ Text("Create account")
                    .padding(5)
                    .font(.title3)
                    .bold()
                .foregroundColor(.white)})

            
        }//VStack
        .padding(.bottom, 10)
    }
}


