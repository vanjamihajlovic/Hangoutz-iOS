//
//  FriendModel.swift
//  HangoutziOS
//
//  Created by User01 on 11/29/24.
//

import Foundation

struct APIResponse: Codable{
    var users: Friend
}

struct Friend: Codable, Identifiable {
    let id: String
    let name: String
    let avatar: String?
    var isChecked: Bool?
}

