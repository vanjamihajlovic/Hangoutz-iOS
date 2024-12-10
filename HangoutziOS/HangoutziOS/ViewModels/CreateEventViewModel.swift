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

    @ObservedObject var eventService = EventService.shared
    @AppStorage("currentUserId") var currentUserId : String?
    @Published var title : String = ""
    @Published var description : String = ""
    @Published var city : String = ""
    @Published var street : String = ""
    @Published var place : String = ""
    @Published var assembledDate = Date()
    @Published var emptyError: String? = nil
    @Published var dateError: String? = nil
    @Published var descriptionError: String? = nil
    @Published var url: String = ""
    private let validation = Validation()
    @Published var errorMessage = ""
    @Published var allFieldsFilled = true
    @Published var isTitleValid = true
    @Published var isPlaceValid = true
    @Published var isDateValid = true
    @Published var isTimeValid = true
    @Published var hasValidationErrors = false
    
    enum FieldsCategory: String {
        case title = "Title*"
        case description = "Description"
        case city = "City"
        case street = "Street"
        case place = "Place*"
    }
    
    func createEventInstance() -> eventModel {
        var readyEvent : eventModel = eventModel()
        readyEvent.title = title
        readyEvent.description = description
        readyEvent.city = city
        readyEvent.street = street
        readyEvent.place = place
        readyEvent.owner = currentUserId
        assembleDate()
        readyEvent.date = assembledDate
        
        print(readyEvent)
        return readyEvent
    }
    
    func assembleDate(){
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: selectedTime)
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        dateComponents.second = timeComponents.second
        dateComponents.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let combined = calendar.date(from: dateComponents) else {
            return
        }
        assembledDate = combined
    }
    
    func createCreateEventURLAndInstance() {
        url = SupabaseConfig.baseURL + SupabaseConstants.CREATE_EVENT
    }
    
    func createEvent() {
       if validateFields(){
            Task{
                try? await eventService.createEvent(newEvent: createEventInstance(), fromURL: url)
            }
        } else {
            print(StringConstants.VALIDATION_FAILED)
        }
    }
    
    func validateFields() -> Bool{
        allFieldsFilled = true
        hasValidationErrors = false
        emptyError = nil
        dateError = nil
        descriptionError = nil
        
        if validation.isEmpty(title) ||
            validation.isEmpty(place) ||
            validation.isEmpty(selectedDate.toString()) ||
            validation.isEmpty(selectedTime.toString()) {
            emptyError = StringConstants.EMPTY_ERROR
            allFieldsFilled = false
        }
        
        assembleDate()
        
        if !validation.isDateAndTimeValid(dateAndTime: assembledDate){
            dateError = StringConstants.DATE_ERROR
            hasValidationErrors = true
        }
        
        if description.count > 100 {
            descriptionError = StringConstants.DESCRIPTION_ERROR
            hasValidationErrors = true
        }

        return allFieldsFilled && !hasValidationErrors
    }
}
