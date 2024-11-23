//
//  Path.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/20/24.
//

import Foundation
import SwiftUICore
import SwiftUI

class Router: ObservableObject {
    
    @State private var path = NavigationPath()
    
    enum Destination: String, Hashable {
        
        case loginView
        case eventScreen
        case profileScreen
        
        var view: any View {
            
            switch self {
            case .loginView:
                return LoginView()
            case .eventScreen:
                return EventScreen()
            case .profileScreen:
                return ProfileView()
            }
        }
    }
}
