//
//  UserModel.swift
//  HangoutziOS
//
//  Edited by alex64a on 11/17/24.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - userData
struct userData: Codable {
    let name: String?
    let avatar: String?
    let id, email: String?
    let passwordHash: String?

    enum CodingKeys: String, CodingKey {
        case name, avatar, id, email
        case passwordHash = "password_hash"
    }
}

typealias Welcome = [userData]


