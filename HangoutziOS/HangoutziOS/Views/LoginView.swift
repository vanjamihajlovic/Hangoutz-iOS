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
    @ObservedObject var loginViewModel : LoginViewModel = LoginViewModel()
  
    
    //MARK: BODY
    var body: some View {
        NavigationStack {
            ZStack{
                Image(backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                hangoutzLogo
                LoginSection(loginViewModel:loginViewModel, isVisiblePassword: false)
                LoginOrCreateAccount(loginViewModel: loginViewModel)
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
    
    @State var loginViewModel: LoginViewModel
    //TODO: CREATE SHOW PASSWORD LOGIC ON CLICKED Image(systemName: "eye")
    @State var isVisiblePassword: Bool
    
    var body: some View {
        VStack{
            // Email TextField
            TextField("", text: $loginViewModel.username, prompt: Text("Username").foregroundColor(.white))
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
            SecureField("", text: $loginViewModel.password, prompt: Text("Password").foregroundColor(.white))
                .autocapitalization(.none)
                .frame(width: 320, height: 25, alignment: .center)
                .foregroundColor(.white)
                .textContentType(.password)
                .padding()
                .foregroundColor(.white)
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
    
    //Object of class LoginViewModel
    var loginViewModel : LoginViewModel
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack{
            Spacer()
            // Login Button
            Button(action: {
                
               
                // Handle login action here
                if(loginViewModel.validateLogin(username: loginViewModel.username, password: loginViewModel.password))
                {
                    //Login user to event screen
    
                }
                else {
                    showAlert.toggle()
                }
               
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
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(loginViewModel.errorMessage))
                }
            }//LoginButton
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
