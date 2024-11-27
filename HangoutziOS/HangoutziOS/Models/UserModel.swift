//
//  UserModel.swift
//  HangoutziOS
//
//  Edited by alex64a on 11/17/24.
//

import Foundation

struct userData: Codable, Identifiable {

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
    
    typealias Welcome = [userData]

