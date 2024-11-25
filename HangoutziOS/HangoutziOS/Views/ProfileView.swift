//
//  ProfileScreen.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/21/24.
//

import SwiftUI


struct ProfileView: View {
    
    @AppStorage("currentUserAvatar") var currentUserAvatar : String?
    @AppStorage("currentUserName") var currentUserName: String?
    @AppStorage("currentUserEmail") var currentUserEmail: String?
    @AppStorage("currentUserId") var currentUserId : String?
    //    @State private var path = NavigationPath()
    var profileViewModel : ProfileViewModel = ProfileViewModel()
    var userService : UserService = UserService()
    //Nemanja
    //    let currentUserId : String = "dd2e34d5-f5b7-4573-bda2-4be6c1e7e840"
    let backgroundImage: String = "MainBackground"
    //This can go to supabase config
    //   let avatarDefault: String = "https://zsjxwfjutstrybvltjov.supabase.co/storage/v1/object/public/avatar/avatar_default.png"
    //
    
    
    var body: some View {
        //path: $path
        
        ZStack {
            Image(backgroundImage)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack{
                AppBarView()
                Spacer()
            }
            
            
            ZStack {
                AsyncImage(url: URL(string: currentUserAvatar ?? "No avatar"), content: { Image in Image
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle()) // Makes the image circular
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2) // Thin white border
                        )
                        .frame(width: 200, height: 200)
                }, placeholder: {
                    ProgressView()
                }
                )
                Image("profilelines").resizable()
                    .scaledToFit()
            }
            .padding(.bottom, 300)
            
            VStack{
                Text(currentUserName ?? "").font(.title).foregroundColor(.white).padding(.top, 30)
                
                
                Text(currentUserEmail ?? "").font(.body).foregroundColor(.white)
            }
            
            //path.append("loginView")
            Button(action: {
            }){
                HStack {
                    Text(HTTPConstants.LOGOUT.rawValue)
                    Image(systemName: "door.right.hand.open")
                }
                .padding()
                .frame(width:310)
                .background(Color.loginButton)
                .cornerRadius(20)
                .foregroundColor(.black)
                
            }.padding(.top, 550)
            
            
        }
        .onAppear{getProfilePicture()}
        //            .navigationDestination(for: String.self) { view in
        //                if view == Router.Destination.loginView.rawValue {
        //                    LoginView()
        //                }
        //            }
        
    }
    func getProfilePicture()  {
        Task{
            profileViewModel.createUrlToGetAvatarJson(id: currentUserId ?? "No id")
            await userService.getUsers(from: profileViewModel.urlGetAvatarJson)
            
            
            print("Avatar JSON: \(profileViewModel.urlGetAvatarJson)")
            print("User JSON: \(userService.users.first?.avatar)")
            
            
            profileViewModel.createUrlToGetAvatarPhoto(imageName: userService.users.first?.avatar ?? SupabaseConfig.avatarDefault)
            print("URL to get avatar photo from storage: \(profileViewModel.urlGetAvatarPhoto)")
            //            await userService.getAvatar(from: profileViewModel.urlGetAvatarPhoto)
            currentUserAvatar = profileViewModel.urlGetAvatarPhoto
            
            //            //Username
            //            profileViewModel.createUrlGetUserName(param: "name", id: currentUserId)
            //            await userService.getUsers(from: profileViewModel.urlGetUserName)
            
            
        }
    }
}

#Preview {
    ProfileView()
    
}
