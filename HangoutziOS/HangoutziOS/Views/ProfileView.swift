//
<<<<<<< HEAD
//  ProfileView.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/21/24.
=======
//  ProfileScreen.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/21/24.
>>>>>>> 91d854c (First commit on this branch. Implemented basic UI for testing. Created functions to get avatar. Next step is to investigate async image on swiftful thinking.)
//

import SwiftUI

<<<<<<< HEAD
struct ProfileView: View {
    
    var body: some View {
        ZStack {
            Image.backgroundImage
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                AppBarView()
                Spacer()
            }
            
            Text("Profile Screen")
                .foregroundColor(.white)
=======
struct ProfileScreen: View {

    @AppStorage("currentUserAvatar") var currentUserAvatar: String?
    @State private var path = NavigationPath()
    
    var profileViewModel : ProfileViewModel = ProfileViewModel()
    var userService : UserService = UserService()
    //Nemanja
    let currentUserId : String = "dd2e34d5-f5b7-4573-bda2-4be6c1e7e840"
    let userName: String = "Nemanja"
    let userEmail: String = "nemanja9@gmail.com"
    let backgroundImage: String = "MainBackground"
    
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Image(backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
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
>>>>>>> 91d854c (First commit on this branch. Implemented basic UI for testing. Created functions to get avatar. Next step is to investigate async image on swiftful thinking.)
        }
    }
}

#Preview {
<<<<<<< HEAD
    ProfileView()
=======
    ProfileScreen()
>>>>>>> 91d854c (First commit on this branch. Implemented basic UI for testing. Created functions to get avatar. Next step is to investigate async image on swiftful thinking.)
}
