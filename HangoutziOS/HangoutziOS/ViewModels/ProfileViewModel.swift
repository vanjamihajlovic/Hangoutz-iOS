//
//  EventViewModel.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/21/24.
//

/*API Call for user avatar: https://zsjxwfjutstrybvltjov.supabase.co/rest/v1/users?select=avatar&id=eq.\(loggedInUser))
 API Call for image in storage:
 https://zsjxwfjutstrybvltjov.supabase.co/storage/v1/object/public/avatar/\(imageName)*/
import Foundation

class ProfileViewModel: ObservableObject {
    @Published var urlGetAvatarJson: String = ""
    @Published var urlGetAvatarPhoto : String = ""
    @Published var urlGetUser : String = ""

    func createUrlToGetAvatarJson(id: String){
        urlGetAvatarJson = SupabaseConfig.baseURL + "rest/v1/users?select=avatar&id=eq.\(id)"
    }
    func createUrlToGetAvatarPhoto(imageName: String?) {
        urlGetAvatarPhoto = SupabaseConfig.baseURLStorage + "\(imageName ?? "error")"
    }
    func createUrlGetUser(param: String, id: String)  {
        urlGetUser = SupabaseConfig.baseURL + "rest/v1/users?select=\(param)&id=eq.\(id)"
    }
}
