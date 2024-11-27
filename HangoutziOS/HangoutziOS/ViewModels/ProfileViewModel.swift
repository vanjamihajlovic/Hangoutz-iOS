//
//  EventViewModel.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/21/24.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var urlGetAvatarJson: String = ""
    @Published var urlGetAvatarPhoto : String = ""
    @Published var urlGetUserName : String = ""
    @Published var urlGetUserEmail: String = ""
    
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
}
