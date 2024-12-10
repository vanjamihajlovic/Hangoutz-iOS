//
//  EventModel.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/22/24.
//

import Foundation

struct eventModel : Identifiable, Encodable {
    var title : String?
    var description : String?
    var city : String?
    var street : String?
    var place : String?
    var date : Date?
    var id : String?
    var owner : String?
}
