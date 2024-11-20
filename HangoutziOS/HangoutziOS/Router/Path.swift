//
//  Path.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/20/24.
//

import Foundation
import SwiftUICore
import SwiftUI

//Router.Destination.eventScreen.view
class Router: ObservableObject {
    
    //MARK: NavigationPath
    @State private var path = NavigationPath()
    
    ///Enum for all the screens in app
    enum Destination: String, Hashable {
        
        case loginView
        case eventScreen
        
        var view: any View {
            
            switch self {
            case .loginView:
                return LoginView()
            case .eventScreen:
                return EventScreen()
            }
        }
    }
}
