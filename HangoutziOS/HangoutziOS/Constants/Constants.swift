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

class IdentifierConstants {
    static let BOTTOM_BAR = "bottomBar"
    static let EVENT_ICON = "eventIcon"
    static let FRIENDS_ICON = "friendsIcon"
    static let SETTINGS_ICON = "settingsIcon"
    static let TOP_BAR = "topBar"
    static let TOP_BAR_TEXT = "topBarText"
    static let FILTER_BAR = "filterBar"
    static let GOING = "going"
    static let INVITED = "invited"
    static let MINE = "mine"
    static let CARD = "card"
    static let CARD_IMAGE = "cardImage"
    static let CARD_PLACE = "cardPlace"
    static let CARD_TITLE = "cardTitle"
    static let CARD_TIME = "cardTime"
    static let CARD_PEOPLE_GOING = "cardPeopleGoing"
    static let DECLINE_BUTTON = "declineButton"
    static let ACCEPT_BUTTON = "acceptButton"
    static let NEW_EVENT_BUTTON = "newEventButton"
}

class UIConstants {
    static let MIN_HORIZONTAL_SWIPE: CGFloat = 50
    static let AVATAR_FRAME_WIDTH: CGFloat = 90
    static let AVATAR_FRAME_HEIGHT: CGFloat = 90
    static let AVATAR_PADDING_BOTTOM: CGFloat = 20
    static let AVATAR_PADDING_TRAILING: CGFloat = 10
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
    static let CAMERA : String = "Camera"
    static let GALLERY : String = "Gallery"
    static let PHOTO : String = "photo"
}

class SupabaseConstants {
    static let SELECT_AVATAR : String = "rest/v1/users?select=avatar&id=eq."
    static let SELECT_EVENTS : String = "rest/v1/events?select=*,users(avatar)&order=date"
    static let SELECT_PEOPLE_COUNT : String = "rest/v1/invites?select=count&event_status=eq.accepted&event_id=eq."
    static let SELECT_GOING_EVENTS :  String = "rest/v1/events?select=*,invites!inner(event_status,user_id),users!owner(id,avatar,name)&invites.event_status=eq.accepted&invites.user_id=eq."
    static let SELECT_INVITED_EVENTS :  String = "rest/v1/events?select=*,invites!inner(event_status,user_id),users!owner(id,avatar,name)&invites.event_status=eq.invited&invites.user_id=eq."
    static let SELECT_MINE_EVENTS : String = "rest/v1/events?select=*,users(avatar)&owner=eq."
    static let GET_FIRENDS_VIA_ID : String = "rest/v1/friends?select=users!friend_id(name,avatar)&user_id=eq."

}

class AccessibilityIdentifierConstants {
    static let USER_NAME : String = "userName"
    static let USER_PASSWORD : String = "userPassword"
    static let USER_EMAIL : String = "userEmail"
    static let LOGIN : String = "login"
    static let LOGOUT : String = "logoutButton"
    static let PROFILE_PICTURE : String = "image"
    static let PEN : String = "pencil"
    static let CHECKMARK : String = "checkmark"
    static let EMAIL_LABEL : String = "emailLabel"
    static let NAME_LABEL : String = "nameLabel"
}

class ColorConstants {
   static let eventCardColors: [Color] = [Color.firstEventCard, Color.secondEventCard, Color.thirdEventCard]
}
