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
    @Published var isEditing : Bool = false
    @Published var urlToUpdateName : String = ""
    
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
        if(param.count >= 3 && param.count <= 25)
        {return true}
        else {return false}
    }
    func createUrlToUpdateName(id: String?){
        urlToUpdateName = SupabaseConfig.baseURL + "rest/v1/users?id=eq.\(id ?? "")"
    }
}
