//
//  EventModel.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/22/24.
//

import Foundation

struct eventModel : Decodable, Identifiable {
    let title : String?
    let description : String?
    let city : String?
    let street : String?
    let place : String?
    let date : Date?
    let id : String?
    let owner : String?
}
