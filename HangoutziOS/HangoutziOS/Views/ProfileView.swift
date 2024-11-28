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
    @State private var uploadStatus: String = ""
    @AppStorage("currentUserAvatar") var currentUserAvatar : String?
    @AppStorage("currentUserName") var currentUserName: String?
    @AppStorage("currentUserEmail") var currentUserEmail: String?
    @AppStorage("currentUserId") var currentUserId : String?
    @AppStorage("isLoggedIn") var isLoggedIn : Bool?
    @State var currentImage : UIImage?
    var userService : UserService = UserService()
    let backgroundImage: String = "MainBackground"
    
    var body: some View {
        
        ZStack {
            Image.backgroundImage
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            /*TODO: REMOVE VStack, because app bar will be only defined in maintabview*/
            VStack{
                AppBarView()
                Spacer()
            }
            ZStack {
                Image.profilelines.resizable()
                    .scaledToFill()
                
                if let currentImage = photoPickerViewModel.selectedImage {
                    Image(uiImage: currentImage)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2).padding(-5)
                        )
                        .frame(width: 160, height: 160)
                    
                }

                PhotosPicker(selection: $photoPickerViewModel.imageSelection, matching: .images) {
                    AsyncImage(url: URL(string: currentUserAvatar ?? "No avatar"), content: { Image in Image
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
            .padding(.bottom, 350)
            
            VStack{
                HStack {
                    if(profileViewModel.isEditing){
                        TextField(currentUserName ?? "", text: $newUserName)
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
                            .onTapGesture {
                                
                                if(profileViewModel.checkUsername(param: newUserName)) {
                                    profileViewModel.isEditing.toggle()
                                    currentUserName = newUserName.trimmingCharacters(in: .whitespaces)
                                    newUserName = newUserName.trimmingCharacters(in: .whitespaces)
                                    print("CurrentUserName is : \(currentUserName)")
                                    profileViewModel.createUrlToUpdateName(id: currentUserId)
                                    userService.updateName(url: profileViewModel.urlToUpdateName, userId: currentUserId ?? "", newName: currentUserName ?? "")
                                }
                            }
                    }
                    else{
                        Text(currentUserName ?? "").font(.custom("Inter", size: 34)).foregroundColor(.white).padding(.top, 20).padding(10)
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.USER_NAME)
                        Image.profilePicturePen
                            .resizable()
                            .frame(width: 25, height: 25).foregroundColor(.white)
                            .padding(.top,20)
                            .bold()
                            .onTapGesture {
                                profileViewModel.isEditing.toggle()
                                
                            }
                            .accessibilityIdentifier(AccessibilityIdentifierConstants.PEN)
                    }
                    
                }
                Text(currentUserEmail ?? "").font(.custom("Inter", size: 24)).foregroundColor(.white)
                    .accessibilityIdentifier(AccessibilityIdentifierConstants.USER_EMAIL)
            }
            Button(action: {
                isLoggedIn = false
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
            profileViewModel.createUrlToGetAvatarJson(id: currentUserId ?? "No id")
            await userService.getUsers(from: profileViewModel.urlGetAvatarJson)
            profileViewModel.createUrlToGetAvatarPhoto(imageName: userService.users.first?.avatar ?? SupabaseConfig.avatarDefault)
            currentUserAvatar = profileViewModel.urlGetAvatarPhoto
        }
    }
    
//    func uploadImage(image: UIImage) {
//        userService.uploadImageToSupabase(image: image, fileName: "sample.jpg") { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let filePath):
//                    uploadStatus = "Upload successful: \(filePath)"
//                case .failure(let error):
//                    uploadStatus = "Error: \(error.localizedDescription)"
//                }
//                
//            }
//        }
//    }
}

#Preview {
    ProfileView()
}
