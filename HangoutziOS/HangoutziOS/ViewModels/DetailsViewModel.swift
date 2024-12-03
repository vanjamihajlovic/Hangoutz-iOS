//
//  DetailsViewModel.swift
//  HangoutziOS
//
//  Created by Aleksa on 12/1/24.
//

import Foundation
import SwiftUI

class DetailsViewModel: ObservableObject  {
    
    @AppStorage("currentUserId") var currentUserId : String?
    @Published var title : String = ""
    @Published var description : String = ""
    @Published var city : String = ""
    @Published var street : String = ""
    @Published var place : String = ""

    enum FieldsCategory: String {
        case title = "Title*"
        case description = "Description"
        case city = "City"
        case street = "Street"
        case place = "Place*"
    }
    func checkIfUserIsOwner(ownerOfEvent: String?) -> Bool {
        if(currentUserId == ownerOfEvent) {
            return true
        }
        else {return false}
    }
}
