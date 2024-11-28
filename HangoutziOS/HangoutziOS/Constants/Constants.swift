//
//  Constants.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/22/24.
//

import Foundation
import SwiftUICore

enum HTTPConstants : String {
    case GET = "GET"
    case PUT = "PUT"
    case POST = "POST"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
    case API_KEY = "apikey"
    case BEARER = "Bearer "
    case AUTHORIZATION = "Authorization"
}

enum DaySuffix {
    static let DAY_1 = 1
    static let DAY_2 = 2
    static let DAY_3 = 3
}

class DateConstants {
    static let JUST_TIME = "HH:mm"
    static let MONTH_DAY = "MMMM d"
    static let TH_SUFFIX = "th"
    static let ST_SUFFIX = "st"
    static let ND_SUFFIX = "nd"
    static let RD_SUFFIX = "rd"
    
}

class ValidationConstants {
    static let EMAIL_REGEX = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.com$"   //"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
    static let PASS_REGEX = "^(?=.*\\d)[A-Za-z0-9!@#$%^&*]{8,}$"
    static let MIN_NAME_LENGTH = 3
    static let MAX_NAME_LENGTH = 25
}

class StringConstants {
    static let APP_NAME = "Hangoutz"
    static let LOGIN : String = "Login"
    static let LOGOUT : String = "Logout"
    static let CREATE_ACCOUNT : String = "Create account"
}

class SupabaseConstants {
    static let SELECT_AVATAR : String = "rest/v1/users?select=avatar&id=eq."
    static let SELECT_EVENTS : String = "rest/v1/events?select=*,users(avatar)&order=date"
    static let SELECT_PEOPLE_COUNT : String = "rest/v1/invites?select=count&event_status=eq.accepted&event_id=eq."
}

class AccessibilityIdentifierConstants {
    static let USER_NAME : String = "userName"
    static let USER_PASSWORD : String = "userPassword"
    static let USER_EMAIL : String = "userEmail"
    static let LOGIN : String = "login"
    static let LOGOUT : String = "logout"
    static let PROFILE_PICTURE : String = "profilePicture"
    static let PEN : String = "pen"

}

class ColorConstants {
   static let eventCardColors: [Color] = [Color.firstEventCard, Color.secondEventCard, Color.thirdEventCard]
}
