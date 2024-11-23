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
    let userName: String = "Nemanja"
    let userEmail: String = "nemanja9@gmail.com"
    let backgroundImage: String = "MainBackground"
    
    
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
                Image(currentUserAvatar ?? "defaultProfilePicture")
                    .resizable()
                    .scaledToFill()
                    .frame(width:200, height: 200)
                    .cornerRadius(150)
                    .padding(.top, 100)
                Text(userName).font(.title).foregroundColor(.white)
                    .padding()
                Text(userEmail).font(.body).foregroundColor(.white)
                Spacer()
                Button {
                    getProfilePicture()
                } label: {
                    Text("Click me")
                }
                
            }
        }
    }
    func getProfilePicture()  {
        Task{
            profileViewModel.createUrlToGetAvatarJson(id: currentUserId)
            await userService.getUsers(from: profileViewModel.urlGetAvatarJson)
            
            print("Avatar JSON: \(profileViewModel.urlGetAvatarJson)")
            print("User JSON: \(userService.users.first?.avatar)")
            
            profileViewModel.createUrlToGetAvatarPhoto(imageName: userService.users.first?.avatar)
            print("URL to get avatar photo from storage: \(profileViewModel.urlGetAvatarPhoto)")
            await userService.getAvatar(from: profileViewModel.urlGetAvatarPhoto)
            currentUserAvatar = profileViewModel.urlGetAvatarPhoto
        }
    }
}
#Preview {
    ProfileView()
    
}
