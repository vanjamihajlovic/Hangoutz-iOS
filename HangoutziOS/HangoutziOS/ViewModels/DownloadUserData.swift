//
//  downloadUserData.swift
//  HangoutziOS
//
//  Created by alex64a on 11/17/24.
//

import Foundation

class DownloadUserData: ObservableObject {
    
    //array of type struct userData
    @Published var users: [userData] = []
    
    init() {
        getUserData()
    }
    
    func getUserData() {
        
        //URL for all users in database
        guard let url = URL(string: baseUrlLogin) else { return }
        downloadData(fromURL: url) { (returnedData) in
            if let data = returnedData {
                guard let newUsers = try? JSONDecoder().decode([userData].self, from: data) else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.users = newUsers
                }
            } else {
                print("No data returned.")
            }
        }
    }
    func downloadData(fromURL url: URL, completionHandler: @escaping (_ data: Data?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
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
}//DownloadUserData
