//
//  ProfileScreen.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/21/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @AppStorage("currentUserAvatar") var currentUserAvatar : String?
    @AppStorage("currentUserName") var currentUserName: String?
    @AppStorage("currentUserEmail") var currentUserEmail: String?
    @AppStorage("currentUserId") var currentUserId : String?
    @AppStorage("isLoggedIn") var isLoggedIn : Bool?
    @State private var photosPickerItem : PhotosPickerItem?
    var profileViewModel : ProfileViewModel = ProfileViewModel()
    var userService : UserService = UserService()
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
            
            ZStack {
                Image("profilelines").resizable()
                    .scaledToFit()
                PhotosPicker(selection: $photosPickerItem, matching: .images) {
                    AsyncImage(url: URL(string: currentUserAvatar ?? "No avatar"), content: { Image in Image
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2).padding(-5)
                            )
                            .frame(width: 165, height: 165)
                    }, placeholder: {
                        ProgressView()
                    }
                    ).accessibilityIdentifier(AccessibilityIdentifierConstants.PROFILE_PICTURE)
                }
               
            }
            .padding(.bottom, 350)
            
            VStack{
                HStack {
                    Text(currentUserName ?? "").font(.custom("Inter", size: 34)).foregroundColor(.white).padding(.top, 20).padding(10)
                        .accessibilityIdentifier(AccessibilityIdentifierConstants.USER_NAME)
                    Image(systemName: "applepencil")
                        .resizable()
                        .frame(width: 25, height: 25).foregroundColor(.white)
                        .padding(.top,20)
                        .bold()
                        .accessibilityIdentifier(AccessibilityIdentifierConstants.PEN)
                }
                Text(currentUserEmail ?? "").font(.custom("Inter", size: 24)).foregroundColor(.white)
                    .accessibilityIdentifier(AccessibilityIdentifierConstants.USER_EMAIL)
            }
            Button(action: {
                isLoggedIn = false
            }){
                HStack {
                    Text(StringConstants.LOGOUT)
                    Image(systemName: "door.right.hand.open")
                }
                .padding()
                .frame(width:310)
                .background(Color.loginButton)
                .cornerRadius(20)
                .foregroundColor(.black)
            }.padding(.top, 550)
                .accessibilityIdentifier(AccessibilityIdentifierConstants.LOGOUT)
        }
        .onAppear{getProfilePicture()}
    }
    func getProfilePicture()  {
        Task{
            profileViewModel.createUrlToGetAvatarJson(id: currentUserId ?? "No id")
            await userService.getUsers(from: profileViewModel.urlGetAvatarJson)
            profileViewModel.createUrlToGetAvatarPhoto(imageName: userService.users.first?.avatar ?? SupabaseConfig.avatarDefault)
            currentUserAvatar = profileViewModel.urlGetAvatarPhoto
        }
    }
}

#Preview {
    ProfileView()
    
}
