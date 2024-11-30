//
//  FriendModel.swift
//  HangoutziOS
//
//  Created by User01 on 11/29/24.
//

import Foundation

    struct FriendModel: Codable {
        let users: Friend
    }

    struct Friend: Codable {
        let name: String
        let avatar: String?
    }



