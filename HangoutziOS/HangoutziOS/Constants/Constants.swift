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
    static let NO_EVENTS_TEXT = "noEventsText"
}

class UIConstants {
    static let MIN_HORIZONTAL_SWIPE: CGFloat = 50
    static let AVATAR_FRAME_WIDTH: CGFloat = 90
    static let AVATAR_FRAME_HEIGHT: CGFloat = 90
    static let AVATAR_PADDING_BOTTOM: CGFloat = 20
    static let AVATAR_PADDING_TRAILING: CGFloat = 10
    static let PLUS_SIGN_FRAME_WIDTH: CGFloat = 80
    static let PLUS_SIGN_FRAME_HEIGHT: CGFloat = 80
    static let PLUS_SIGN_PADDING_TRAILING: CGFloat = 20
    static let PLUS_SIGN_PADDING_BOTTOM: CGFloat = 15
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
    static let CREATE : String = "Create"
    static let LEAVE_EVENT : String = "Leave event"
    static let UPDATE : String = "Update"
    static let PARTICIPANTS : String = "Participants"
    static let CAMERA : String = "camera"
    static let GALLERY : String = "Gallery"
    static let PHOTO : String = "photo"
    static let NO_EVENTS : String = "No events available"
    static let LOADING_EVENTS : String = "Loading events..."
    static let ACCEPT : String = "Accept"
    static let DECLINE : String = "Decline"
    static let ACCEPTED : String = "accepted"
    static let DECLINED : String = "declined"
    static let DELETE: String = "Delete"
    static let ADD_BUTTON: String = "AddButtonImage"
    static let VALIDATION_FAILED: String = "Validation failed"
    static let ASSEMBLE_FAILED: String = "Failed to assemble date"
    static let EMPTY_ERROR: String = "Title, place, date and time fields can't be empty!"
    static let DATE_ERROR: String = "Invalid date and time input!"
    static let DESCRIPTION_ERROR: String = "Description must be no longer than 3 lines of text!"

}

class SupabaseConstants {
    static let SELECT_AVATAR : String = "rest/v1/users?select=avatar&id=eq."
    static let SELECT_EVENTS : String = "rest/v1/events?select=*,users(avatar)&order=date"
    static let SELECT_PEOPLE_COUNT : String = "rest/v1/invites?select=count&event_status=eq.accepted&event_id=eq."
    static let SELECT_GOING_EVENTS :  String = "rest/v1/events?select=*,invites!inner(event_status,user_id),users!owner(id,avatar,name)&invites.event_status=eq.accepted&invites.user_id=eq."
    static let SELECT_INVITED_EVENTS :  String = "rest/v1/events?select=*,invites!inner(event_status,user_id),users!owner(id,avatar,name)&invites.event_status=eq.invited&invites.user_id=eq."
    static let SELECT_MINE_EVENTS : String = "rest/v1/events?select=*,users(avatar)&owner=eq."
    static let GET_FIRENDS_VIA_ID : String = "rest/v1/friends?select=users!friend_id(id,name,avatar)&user_id=eq."
    static let GET_USERS_WHO_ARE_NOT_FRIENDS: String = "rest/v1/users?select=id,name,avatar&id=not.in.("
    static let SET_EVENT_STATUS_ACC_DEC_1 : String = "rest/v1/invites?event_id=eq."
    static let SET_EVENT_STATUS_ACC_DEC_2 : String = "&user_id=eq."
    static let SELECT_INVITED_COUNT : String = "rest/v1/invites?select=count&event_status=eq.invited&user_id=eq."
    static let CREATE_EVENT : String = "rest/v1/events"

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
    static let DESCRIPTION : String = "description"
    static let PLACE : String = "place"
    static let CITY : String = "city"
    static let TIME : String = "time"
    static let DATE : String = "date"
    static let STREET : String = "street"
    static let TITLE : String = "title"
    static let PARTICIPANTS : String = "participants"
}

class ColorConstants {
    static let eventCardColors: [Color] = [Color.firstEventCard, Color.secondEventCard, Color.thirdEventCard]
}

class NumberConstants {
    static let BADGE_NANOSECONDS: UInt64 = 5_000_000_000
}

class ImageConstants {
    
    static let CALENDAR : String = "calendar"
    static let CLOCK : String = "clock"
    
}
