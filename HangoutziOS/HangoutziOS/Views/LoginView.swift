//
//  LoginView.swift
//  HangoutziOS
//
//  Edited by alex64a on 11/14/24.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var loginViewModel : LoginViewModel = LoginViewModel()
    @ObservedObject var userService: UserService = UserService()
    let backgroundImage: String = "MainBackground"
    let logo: String = "Hangoutz"
    
    var body: some View {
        NavigationStack() {
            ZStack{
                Image(backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                hangoutzLogo
                LoginSection(loginViewModel:loginViewModel, isVisiblePassword: false)
                CreateAccount(loginViewModel: loginViewModel, userService: userService)
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
            TextField("", text: $loginViewModel.username, prompt: Text("Email").foregroundColor(.white))
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
    
    var body: some View {
        VStack{
            Spacer()
            Button(action: {
                if(loginViewModel.validateLogin())
                {
                    loginViewModel.createUrlLogin()
                    getUserFromSupabase()
                    print("User id from @appstorage: \(currentUserId)")
                    print("User email from @appstorage: \(currentUserEmail)")
                }
                else {
                    showAlert.toggle()
                    
                }
            })
            {
                HStack {
                    Text(HTTPConstants.Login.rawValue)
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
            Text("OR")
                .bold()
                .foregroundColor(.white)
                .padding(.top, 20)
            NavigationLink(destination: {RegistrationView(/*path: $path*/)}, label:{ Text("Create account")
                    .padding(5)
                    .font(.title3)
                    .bold()
                .foregroundColor(.white)})//            Button(action:{
            //                path.append("registrationScreen")
            //            }){Text("Create account")
            //                    .padding(5)
            //                    .font(.title3)
            //                    .bold()
            //                .foregroundColor(.white)}
        }
        .padding(.bottom, 10)
    }
    
    func getUserFromSupabase() {
        Task {
            await userService.getUsers(from: loginViewModel.url)
            if(userService.users.first?.id != nil){
                loginViewModel.isLoggedIn.toggle()
                print("Bool isLoggedin: \(loginViewModel.isLoggedIn)\n")
                //Save data to @AppStorage
                currentUserId = userService.users.first?.id
                currentUserEmail = userService.users.first?.email
            }
            else {
                showAlert.toggle()
                loginViewModel.errorMessage = "Incorrect email or password"
            }
        }
    }
}
