//
//  eventModelDTO.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/26/24.
//

import Foundation

struct eventModelDTO: Decodable {
    let title: String?
    let description: String?
    let city: String?
    let street: String?
    let place: String?
    let date: Date?
    let id: String?
    let owner: String?
    let users: User?
    let invites: [Invite]?
    var count: Int?

    struct User: Codable {
        let id: String?
        let avatar: String?
        let name: String?
    }
    
    struct Invite: Codable {
        let event_status: String?
        let user_id: String?
        let event_id: String?
        let id: String?
    }
}
