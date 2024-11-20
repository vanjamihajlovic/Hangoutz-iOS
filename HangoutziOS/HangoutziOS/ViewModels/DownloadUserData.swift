//
//  DownloadWithEscapingBootcamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Nick Sarno on 4/10/21.
//

import SwiftUI

//struct PostModel: Identifiable, Codable {
//    let userId: Int
//    let id: Int
//    let title: String
//    let body: String
//}

// MARK: - userData
struct HangoutzUserData: Codable, Identifiable {
    let name: String?
    let avatar: String?
    let email: String?
    let id : String?
    let passwordHash: String?
    
    enum CodingKeys: String, CodingKey {
        case name, avatar, id, email
        case passwordHash = "password_hash"
    }
}

//typealias Welcome = [HangoutzUserData]

class DownloadWithEscapingViewModel: ObservableObject {
    
    @Published var usersHangoutz: [HangoutzUserData] = []
    
    init() {
        getUsers()
    }
    
    func getUsers() {
        
        guard let url = URL(string: "https://zsjxwfjutstrybvltjov.supabase.co/rest/v1/users?select=id,email,password_hash&email=eq.zvonko@gmail.com&password_hash=eq.62b762fd7d63c7fd741b2c200d523bf91dae1b340d8ee6b727a282e39a09e978") else { return }
        
        downloadData(fromURL: url) { (returnedData) in
            if let data = returnedData {
                guard let newUsers = try? JSONDecoder().decode([HangoutzUserData].self, from: data) else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.usersHangoutz = newUsers
            
                }
            } else {
                print("No data returned.")
            }
        }
        
    }
    
    
    func downloadData(fromURL url: URL, completionHandler: @escaping (_ data: Data?) -> ()) {
        
        guard let urlSupabase = URL(string: "https://zsjxwfjutstrybvltjov.supabase.co/rest/v1/users?select=id,email,password_hash&email=eq.zvonko@gmail.com&password_hash=eq.62b762fd7d63c7fd741b2c200d523bf91dae1b340d8ee6b727a282e39a09e978") else { return }
        var request = URLRequest(url: urlSupabase)
        request.httpMethod = "GET"
        request.setValue(SupabaseConfig.apiKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(SupabaseConfig.serviceRole)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                print("Error downloading data.")
                completionHandler(nil)
                return
            }


            
            completionHandler(data)
            
        }.resume()
    }
    
}

struct DownloadWithEscapingBootcamp: View {
    
    @StateObject var vm = DownloadWithEscapingViewModel()
    var body: some View {
        ZStack {
            List {
                ForEach(vm.usersHangoutz) { user in
                    VStack(alignment: .leading) {
                        Text(user.email ?? "nothing")
                            .font(.headline)
                        Text(user.passwordHash ?? "nothing")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
            }
            Text("User id is : \(vm.usersHangoutz.first?.id ?? "nothing")")
        }
        
    }
}

struct DownloadWithEscapingBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWithEscapingBootcamp()
    }
}
