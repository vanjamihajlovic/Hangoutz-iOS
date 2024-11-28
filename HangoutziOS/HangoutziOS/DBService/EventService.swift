//
//  EventService.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/25/24.
//

import Foundation

class EventService : ObservableObject {
    @Published var events: [eventModelDTO] = []
    @Published var count : [CountResponse] = []
    @Published var countint : Int = 0
    let decoder = JSONDecoder()
    let formatter = DateFormatter()
    let url: String = ""
    static let shared = EventService()
    
    private init() {
    }
    
    func getCount(from urlString: String) async -> Int?{
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return nil
        }
        let returnedData = await downloadData(fromURL: url)
        if let data = returnedData{
            guard let countResponse = try? JSONDecoder().decode([CountResponse].self, from: data) else {
                print("Failed to decode people count")
                return nil
            }
            guard let countValue = countResponse.first?.count else { return nil }
            await MainActor.run {
                self.countint = countValue
            }
            return countValue
        } else {
            return nil
        }
    }
    
    func getEvents(from urlString: String) async -> [eventModelDTO] {
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return []
        }
        let returnedData = await downloadData(fromURL: url)
        if let data = returnedData {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(formatter)
            guard let newEvents = try? decoder.decode([eventModelDTO].self, from: data) else {
                print("Failed to decode events data.")
                return []
            }
            print("Decoded events count: \(newEvents.count)")
            await MainActor.run {
                self.events = newEvents
            }
            return newEvents
        } else {
            return []
        }
    }
    
    func downloadData(fromURL url: URL) async -> Data? {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPConstants.GET.rawValue
        request.setValue(SupabaseConfig.apiKey, forHTTPHeaderField: HTTPConstants.API_KEY.rawValue)
        request.setValue("Bearer \(SupabaseConfig.serviceRole)", forHTTPHeaderField: HTTPConstants.AUTHORIZATION.rawValue)
        return await withCheckedContinuation { continuation in
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard
                    let data1 = data,
                    error == nil,
                    let response1 = response as? HTTPURLResponse,
                    response1.statusCode >= 200 && response1.statusCode < 300
                else {
                    print("Error downloading data.")
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: data1)
            }.resume()
        }
    }
}
