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
    @State var currentImage : UIImage?
    @State var selectedImageCamera : UIImage?
    @State var showSheet: Bool = false
    @State var showCamera: Bool = false
    var userService : UserService = UserService()
    let backgroundImage: String = "MainBackground"
    @State private var selectedImage: UIImage?
    
    
    var body: some View {
        
        ZStack {
            Image.backgroundImage
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            ZStack {
                
                Image.profilelines.resizable()
                
                if let currentImage = photoPickerViewModel.selectedImage {
                    Button(action: {showSheet.toggle()
                    }
                    ) { Image(uiImage: currentImage)
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
                                showSheet = false
                                
                            }
                    }.sheet(isPresented: $showSheet) {
                        HStack {
                            PhotosPicker(selection: $photoPickerViewModel.imageSelection, matching: .images) {
                                VStack{
                                    Text(StringConstants.GALLERY).padding()
                                    Image(systemName: StringConstants.PHOTO)
                                        .font(.title)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black, lineWidth: 1).padding(-10)
                                        )
                                }
                                .padding(30)
                            }
                            .foregroundColor(Color.black)
                            
                            Button(action: {
                                showCamera.toggle()
                            }){
                                VStack{
                                    Text(StringConstants.CAMERA).padding()
                                    Image(systemName: StringConstants.CAMERA)
                                        .font(.title)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black, lineWidth: 1).padding(-10)
                                        )
                                }
                                .padding(30)
                            }.foregroundColor(Color.black)
                                .fullScreenCover(isPresented: self.$showCamera) {
                                    accessCameraView(selectedImage: self.$selectedImageCamera)
                                        .background(.black)
                                }
                        }
                        .presentationDetents([.fraction(0.2)])
                    }
                }
                else if let selectedImageCamera {
                    Button(action: {showSheet.toggle()
                    }
                    ) { Image(uiImage: selectedImageCamera)
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
                                uploadProfilePicture(imageToUpload: selectedImageCamera)
                                showSheet = false
                                
                            }
                    }.sheet(isPresented: $showSheet) {
                        HStack {
                            PhotosPicker(selection: $photoPickerViewModel.imageSelection, matching: .images) {
                                VStack{
                                    Text(StringConstants.GALLERY).padding()
                                    Image(systemName: StringConstants.PHOTO)
                                        .font(.title)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black, lineWidth: 1).padding(-10)
                                        )
                                }
                                .padding(30)
                            }
                            .foregroundColor(Color.black)
                            
                            Button(action: {
                                showCamera.toggle()
                            }){
                                VStack{
                                    Text(StringConstants.CAMERA).padding()
                                    Image(systemName: StringConstants.CAMERA)
                                        .font(.title)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black, lineWidth: 1).padding(-10)
                                        )
                                }
                                .padding(30)
                            }.foregroundColor(Color.black)
                                .fullScreenCover(isPresented: self.$showCamera) {
                                    accessCameraView(selectedImage: self.$selectedImageCamera)
                                        .background(.black)
                                }
                        }
                        .presentationDetents([.fraction(0.2)])
                    }
                }
                else {
                    Button(action: {
                        showSheet.toggle()
                        print("On first button pressed, showSheet is \(showSheet)\n")
                    }){
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
                    .sheet(isPresented: $showSheet) {
                        HStack {
                            PhotosPicker(selection: $photoPickerViewModel.imageSelection, matching: .images) {
                                VStack{
                                    Text(StringConstants.GALLERY).padding()
                                    Image(systemName: StringConstants.PHOTO)
                                        .font(.title)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black, lineWidth: 1).padding(-10)
                                        )
                                }.padding(30)
                                
                            }.foregroundColor(Color.black)
                            Button(action: {
                                showCamera.toggle()
                            }){
                                VStack{
                                    Text(StringConstants.CAMERA).padding()
                                    Image(systemName: StringConstants.CAMERA)
                                        .font(.title)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.black, lineWidth: 1).padding(-10)
                                        )
                                }
                                .padding(30)
                            }.foregroundColor(Color.black)
                                .fullScreenCover(isPresented: self.$showCamera) {
                                    accessCameraView(selectedImage: self.$selectedImageCamera)
                                        .background(.black)
                                }
                        }
                        .presentationDetents([.fraction(0.2)])
                    }
                }
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
