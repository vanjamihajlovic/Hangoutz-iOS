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
    case LOGIN = "Login"
}

class ValidationConstants {
    static let EMAIL_REGEX = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
    static let PASS_REGEX = "^(?=.*\\d)[A-Za-z0-9!@#$%^&*]{8,}$"
    static let MIN_NAME_LENGTH = 3
    static let MAX_NAME_LENGTH = 25
}

class StringConstants {
    static let APP_NAME = "Hangoutz"
}
