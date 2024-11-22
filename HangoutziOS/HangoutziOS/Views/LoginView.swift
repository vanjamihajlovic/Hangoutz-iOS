//
//  LoginView.swift
//  HangoutziOS
//
//  Edited by alex64a on 11/14/24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var path = NavigationPath()
    @StateObject var router: Router = Router()
    @ObservedObject var loginViewModel : LoginViewModel = LoginViewModel()
    @ObservedObject var userService: UserService = UserService()
    let backgroundImage: String = "MainBackground"
    let logo: String = "Hangoutz"
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack{
                Image(backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                hangoutzLogo
                LoginSection(loginViewModel:loginViewModel, isVisiblePassword: false)
                CreateAccount(loginViewModel: loginViewModel, userService: userService,path: $path)
            }
            .navigationDestination(for: String.self) { view in
                if view == Router.Destination.eventScreen.rawValue {
                    MainTabView()
                }
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
    @Binding var path : NavigationPath
    
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
                }
                else {
                    showAlert.toggle()
                
                }
            })
            {
                HStack {
                    Text(HTTPConstants.LOGIN.rawValue)
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
            NavigationLink(destination: {/*TODO: Destination to createAccountView */}, label:{ Text("Create account")
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
                path.append("eventScreen")
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
