//
//  HangoutziOSApp.swift
//  HangoutziOS
//
//  Created by User01 on 11/14/24.
//

import SwiftUI

@main
struct HangoutziOSApp: App {
    var body: some Scene {
        WindowGroup {
            //NavigationView (in this view check if(isLoggedIn) ? redirect him to home : redirect to login) EMPTY SCREEN (SPLASH SCREEN)
            LoginView()
        }
    }
}
