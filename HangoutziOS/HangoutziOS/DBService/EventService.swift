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
    let encoder = JSONEncoder()
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
    
    func updateInvitationStatus(fromURL url: String, changeTo: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let endpoint = URL(string: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = HTTPConstants.PATCH.rawValue
        request.setValue(SupabaseConfig.apiKey, forHTTPHeaderField: HTTPConstants.API_KEY.rawValue)
        request.setValue("Bearer \(SupabaseConfig.serviceRole)", forHTTPHeaderField: HTTPConstants.AUTHORIZATION.rawValue)
        
        let body: [String: Any] = ["event_status": changeTo]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 else {
                completion(.failure(NSError(domain: "Unexpected Response", code: 0, userInfo: nil)))
                return
            }
            
            completion(.success(()))
        }.resume()
    }
    
    func createEvent(newEvent: eventModel, fromURL urlString: String) async throws {
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        print("newEvent when it reaches the DBService: \(newEvent)")
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(SupabaseConfig.apiKey, forHTTPHeaderField: HTTPConstants.API_KEY.rawValue)
        request.setValue("Bearer \(SupabaseConfig.serviceRole)", forHTTPHeaderField: HTTPConstants.AUTHORIZATION.rawValue)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        encoder.dateEncodingStrategy = .formatted(formatter)
        
        let jsonData = try encoder.encode(newEvent)
        print("JSON encoded newEvent: \(jsonData)")
        request.httpBody = jsonData
        
        let(data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            let errorResponse = String(data:data, encoding: .utf8) ?? "Unknown error"
            print(errorResponse)
            throw URLError(.badServerResponse, userInfo: ["ErrorResponse": errorResponse])
        }
        
        print("Event created successfully!")
    }
}

