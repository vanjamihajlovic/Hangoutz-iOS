//
//  eventModelDTO.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/26/24.
//

import Foundation

struct eventModelDTO : Decodable {
    let title : String?
    let description : String?
    let city : String?
    let street : String?
    let place : String?
    let date : Date?
    let id : String?
    let owner : String?
    let users: User?

        struct User: Codable {
            let avatar: String?
        }
    
}
