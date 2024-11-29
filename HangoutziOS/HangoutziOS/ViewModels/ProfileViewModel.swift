//
//  EventViewModel.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/21/24.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @AppStorage("currentUserAvatar") var currentUserAvatar : String?
    @AppStorage("currentUserId") var currentUserId : String?
    @Published var urlGetAvatarJson: String = ""
    @Published var urlGetAvatarPhoto : String = ""
    @Published var urlGetUserName : String = ""
    @Published var urlGetUserEmail: String = ""
    @Published var isEditing : Bool = false
    @Published var urlToUpdateName : String = ""
    @Published var urlToUpdateAvatar : String = ""
    var userService : UserService = UserService()
    
    func createUrlToGetAvatarJson(id: String){
        urlGetAvatarJson = SupabaseConfig.baseURL + SupabaseConstants.SELECT_AVATAR + "\(id)"
    }
    func createUrlToGetAvatarPhoto(imageName: String?) {
        urlGetAvatarPhoto = SupabaseConfig.baseURLStorage + "\(imageName ?? "error")"
    }
    func createUrlGetUserName(param: String, id: String)  {
        urlGetUserName = SupabaseConfig.baseURL + "rest/v1/users?select=\(param)&id=eq.\(id)"
    }
    func createUrlGetUserEmail(param: String, id: String)  {
        urlGetUserEmail = SupabaseConfig.baseURL + "rest/v1/users?select=\(param)&id=eq.\(id)"
    }
    func checkUsername(param: String) -> Bool {

        let param = param.trimmingCharacters(in: .whitespacesAndNewlines)
        if(param.count >= 3 && param.count <= 25)
        {return true}
        else {return false}
    }
    func createUrlToUpdateName(id: String?){
        urlToUpdateName = SupabaseConfig.baseURL + "rest/v1/users?id=eq.\(id ?? "")"
    }
    func createUrlToUpdateAvatar(id: String?){
        urlToUpdateAvatar = SupabaseConfig.baseURL + "rest/v1/users?id=eq.\(id ?? "")"
    }
    func randomAlphanumericString(_ length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.count)
        var random = SystemRandomNumberGenerator()
        var randomString = ""
        for _ in 0..<length {
            let randomIndex = Int(random.next(upperBound: len))
            let randomCharacter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
            randomString.append(randomCharacter)
        }
        return randomString
    }
}
