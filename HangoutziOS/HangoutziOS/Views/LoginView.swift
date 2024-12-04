//
//  LoginView.swift
//  HangoutziOS
//
//  Edited by alex64a on 11/14/24.
//

import SwiftUI

struct LoginView: View {
    
    @AppStorage("isLoggedIn") var isLoggedIn : Bool?
    @ObservedObject var loginViewModel : LoginViewModel = LoginViewModel()
    @ObservedObject var userService: UserService = UserService()
    let backgroundImage: String = "MainBackground"
    let logo: String = "Hangoutz"
    
    var body: some View {
        NavigationStack() {
            if isLoggedIn ?? false{
                MainTabView()
                    .navigationBarBackButtonHidden(true)
            }else{
                ZStack{
                    
                    hangoutzLogo
                    LoginSection(loginViewModel:loginViewModel, isVisiblePassword: false)
                    CreateAccount(loginViewModel: loginViewModel, userService: userService)
                }.applyGlobalBackground()
            }
        }
    }
    var hangoutzLogo: some View {
        VStack{
            Image(logo)
                .resizable()
                .scaledToFit()
                .frame(width: 215, height: 50, alignment: .center)
                .padding(.top, 100)
                .padding(.trailing, 20)
            Spacer()
        }
    }
}

#Preview {
    LoginView()
}

struct LoginSection: View {
    
    @State var loginViewModel: LoginViewModel
    //TODO: CREATE SHOW PASSWORD LOGIC ON CLICKED Image(systemName: "eye")
    @State var isVisiblePassword: Bool
    
    var body: some View {
        VStack{
            TextField("", text: $loginViewModel.username, prompt: Text("Email")
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
            .padding(20)
            SecureField("", text: $loginViewModel.password, prompt: Text("Password").foregroundColor(.white))
                .accessibilityIdentifier(AccessibilityIdentifierConstants.USER_PASSWORD)
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
        }
        .padding(.bottom, 80)
    }
}

struct CreateAccount: View {
    
    var loginViewModel : LoginViewModel
    var userService : UserService
    @State var showAlert: Bool = false
    
    @AppStorage("currentUserId") var currentUserId: String?
    @AppStorage("currentUserEmail") var currentUserEmail: String?
    @AppStorage("currentUserName") var currentUserName: String?
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some View {
        VStack{
            Spacer()
            Button(action: {
                loginViewModel.username =  loginViewModel.username.trimmingCharacters(in: .whitespacesAndNewlines)
                loginViewModel.password = loginViewModel.password.trimmingCharacters(in: .whitespacesAndNewlines)
                if(loginViewModel.validateLogin())
                {
                    loginViewModel.createUrlLogin()
                    getUserFromSupabase()
                }
                else {
                    showAlert.toggle()
                }
            })
            {
                HStack {
                    Text(StringConstants.LOGIN)
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
            }
            .padding(.horizontal, 40)
            .accessibilityIdentifier(AccessibilityIdentifierConstants.LOGIN)
            Text("OR")
                .bold()
                .foregroundColor(.white)
                .padding(.top, 20)
            NavigationLink(destination: {RegistrationView()}, label:{ Text(StringConstants.CREATE_ACCOUNT)
                    .padding(5)
                    .font(.title3)
                    .bold()
                .foregroundColor(.white)})
        }
        .padding(.bottom, 10)
    }
    func getUserFromSupabase() {
        Task {
            await userService.getUsers(from: loginViewModel.url)
            if(userService.users.first?.id != nil){
                loginViewModel.isLoggedIn = true
                isLoggedIn = loginViewModel.isLoggedIn
                print("Bool isLoggedin: \(loginViewModel.isLoggedIn)\n")
                loginViewModel.username = ""
                loginViewModel.password = ""
                currentUserId = userService.users.first?.id ?? nil
                currentUserEmail = userService.users.first?.email ?? nil
                currentUserName = userService.users.first?.name ?? nil
            }
            else {
                showAlert.toggle()
                loginViewModel.errorMessage = "Incorrect email or password"
            }
        }
    }
}
