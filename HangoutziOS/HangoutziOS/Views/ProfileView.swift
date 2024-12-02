//
//  ProfileScreen.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/21/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @StateObject var profileViewModel : ProfileViewModel = ProfileViewModel()
    @StateObject private var photoPickerViewModel = PhotoPickerViewModel()
    @State var newUserName : String = ""
    @State var photoPickerIsPressed : Bool = false
    @State var currentImage : UIImage?
    var userService : UserService = UserService()
    let backgroundImage: String = "MainBackground"
    
    var body: some View {
        
        ZStack {
            Image.backgroundImage
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
            }
            
            ZStack {
                
                Image.profilelines.resizable()
                
                if let currentImage = photoPickerViewModel.selectedImage {
                    PhotosPicker(selection: $photoPickerViewModel.imageSelection, matching: .images){
                        Image(uiImage: currentImage)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2).padding(-5)
                            )
                            .frame(width: 160, height: 160)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.PROFILE_PICTURE)
                            .onAppear{
                                uploadProfilePicture(imageToUpload: currentImage)
                            }
                    }
                }
                else {
                    PhotosPicker(selection: $photoPickerViewModel.imageSelection, matching: .images) {
                        AsyncImage(url: URL(string: profileViewModel.currentUserAvatar ?? "No avatar"), content: { Image in Image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2).padding(-5)
                                )
                                .frame(width: 160, height: 160)
                        }, placeholder: {
                            ProgressView()
                        }
                        ).accessibilityIdentifier(AccessibilityIdentifierConstants.PROFILE_PICTURE)
                    }
                }
                Spacer()
            }
            .padding(.bottom, 350)
            VStack{
                HStack {
                    if(profileViewModel.isEditing){
                        TextField(profileViewModel.currentUserName ?? "", text: $newUserName)
                            .frame(width: 150)
                            .font(.custom("Inter", size: 34)).foregroundColor(.white).padding(.top, 20)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .padding(10)
                        Image.checkmark
                            .resizable()
                            .frame(width: 40, height: 30).foregroundColor(profileViewModel.checkUsername(param: newUserName) ? Color.white : Color.gray)
                            .padding(.top, 20)
                            .bold()
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.CHECKMARK)
                            .onTapGesture {
                                if(profileViewModel.checkUsername(param: newUserName)) {
                                    profileViewModel.isEditing.toggle()
                                    updateUserName()
                                }
                            }
                    }
                    else{
                        Text(profileViewModel.currentUserName ?? "").font(.custom("Inter", size: 34)).foregroundColor(.white).padding(.top, 20).padding(10)
                            .lineLimit(1)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.NAME_LABEL)
                        Image.profilePicturePen
                            .resizable()
                            .frame(width: 25, height: 25).foregroundColor(.white)
                            .padding(.top,20)
                            .padding(.trailing, 5)
                            .bold()
                            .onTapGesture {
                                profileViewModel.isEditing.toggle()
                                
                            }
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.PEN)
                    }
                }
                Text(profileViewModel.currentUserEmail ?? "").font(.custom("Inter", size: 24)).foregroundColor(.white)
                    .accessibilityIdentifier(AccessibilityIdentifierConstants.EMAIL_LABEL)
            }
            Button(action: {
                profileViewModel.isLoggedIn = false
            }){
                HStack {
                    Text(StringConstants.LOGOUT)
                    Image.doorRightHandOpen
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
            profileViewModel.createUrlToGetAvatarJson(id: profileViewModel.currentUserId ?? "No id")
            await userService.getUsers(from: profileViewModel.urlGetAvatarJson)
            profileViewModel.createUrlToGetAvatarPhoto(imageName: userService.users.first?.avatar ?? SupabaseConfig.avatarDefault)
            profileViewModel.currentUserAvatar = profileViewModel.urlGetAvatarPhoto
        }
    }
    func uploadProfilePicture(imageToUpload: UIImage) {
        let photoName = profileViewModel.randomAlphanumericString(10)
        profileViewModel.createUrlToUpdateAvatar(id: profileViewModel.currentUserId ?? "")
        userService.updateAvatar(url: profileViewModel.urlToUpdateAvatar, userId: profileViewModel.currentUserId ?? "", newAvatar: photoName)
        userService.uploadImageToSupabase(image: imageToUpload, fileName: photoName)
    }
    func updateUserName() {
        profileViewModel.currentUserName = newUserName.trimmingCharacters(in: .whitespaces)
        newUserName = newUserName.trimmingCharacters(in: .whitespaces)
        print("CurrentUserName is : \(profileViewModel.currentUserName)")
        profileViewModel.createUrlToUpdateName(id: profileViewModel.currentUserId)
        userService.updateName(url: profileViewModel.urlToUpdateName, userId: profileViewModel.currentUserId ?? "", newName: profileViewModel.currentUserName ?? "")
    }
}

#Preview {
    ProfileView()
}
