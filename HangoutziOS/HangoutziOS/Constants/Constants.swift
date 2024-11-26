//
//  Constants.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/22/24.
//

import Foundation

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

class ValidationConstants {
    static let EMAIL_REGEX = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
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
}

class AccessibilityIdentifierConstants {
    static let USER_NAME : String = "userName"
    static let USER_PASSWORD : String = "userPassword"
    static let USER_EMAIL : String = "userEmail"
    static let LOGIN : String = "login"
    static let LOGOUT : String = "logout"
    static let PROFILE_PICTURE : String = "profilePicture"

}
