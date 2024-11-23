//
//  ProfileScreen.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/21/24.
//

import SwiftUI


struct ProfileView: View {
    
    @AppStorage("currentUserAvatar") var currentUserAvatar : String?
    var profileViewModel : ProfileViewModel = ProfileViewModel()
    var userService : UserService = UserService()
    //Nemanja
    let currentUserId : String = "dd2e34d5-f5b7-4573-bda2-4be6c1e7e840"
     var userName: String = ""
     var userEmail: String = ""
    let backgroundImage: String = "MainBackground"
    let avatarDefault: String = "https://zsjxwfjutstrybvltjov.supabase.co/storage/v1/object/public/avatar/avatar_default.png"
    
    
    var body: some View {
        
        ZStack {
            Image(backgroundImage)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                AppBarView()
                Spacer()
            }
            VStack {
                ZStack {
                    AsyncImage(url: URL(string: currentUserAvatar ?? avatarDefault), content: { Image in Image
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
                    ) // Replace with your image name
                        
                }
                Text(userName).font(.title).foregroundColor(.white).padding(.top, 30)
                Text(userEmail).font(.body).foregroundColor(.white)
                Spacer()
            }.padding(.top, 150)
            
        }
        .onAppear{getProfilePicture()		}
    }
    func getProfilePicture()  {
        Task{
            profileViewModel.createUrlToGetAvatarJson(id: currentUserId)
            await userService.getUsers(from: profileViewModel.urlGetAvatarJson)
            
            print("Avatar JSON: \(profileViewModel.urlGetAvatarJson)")
            print("User JSON: \(userService.users.first?.avatar)")
            
            profileViewModel.createUrlToGetAvatarPhoto(imageName: userService.users.first?.avatar)
            print("URL to get avatar photo from storage: \(profileViewModel.urlGetAvatarPhoto)")
            //            await userService.getAvatar(from: profileViewModel.urlGetAvatarPhoto)
            currentUserAvatar = profileViewModel.urlGetAvatarPhoto
            //Username
            profileViewModel.createUrlGetUserName(param: "name", id: currentUserId)
            await userService.getUsers(from: profileViewModel.urlGetUserName)
            
            
        }
    }
}
    
#Preview {
    ProfileView()
    
}
