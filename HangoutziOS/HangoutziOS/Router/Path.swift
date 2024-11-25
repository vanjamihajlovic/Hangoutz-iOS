//
//  Path.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/20/24.
//

import Foundation
import SwiftUICore
import SwiftUI

final class Router: ObservableObject {
    
    @State var path = NavigationPath()
    
    static let shared = Router()
    private init() {}
    enum Destination: String, Hashable {
        
        case loginView
        case eventScreen
        case profileScreen
        case mainTabView
        
        var view: any View {
            
            switch self {
            case .loginView:
                return LoginView()
            case .eventScreen:
                return EventScreen()
            case .mainTabView:
                return MainTabView()
            case .profileScreen:
                return ProfileView()
            }
        }
    }
}
