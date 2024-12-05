//
//  FriendModel.swift
//  HangoutziOS
//
//  Created by User01 on 11/29/24.
//

import Foundation

struct APIResponse: Codable{
    let users: Friend
}

struct Friend: Codable, Identifiable {
    let id: String
    let name: String
    let avatar: String?
}

