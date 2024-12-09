//
//  CreateEventViewModel.swift
//  HangoutziOS
//
//  Created by Aleksa on 12/6/24.
//
import Foundation
import SwiftUICore
import SwiftUI

class CreateEventViewModel : ObservableObject {
    
    @Published var selectedDate = Date()
    @Published var selectedTime = Date()
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
    
}
