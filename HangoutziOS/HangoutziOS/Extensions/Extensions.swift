//
//  Extensions.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/22/24.
//

import Foundation
import SwiftUICore
import SwiftUI


extension GroupBoxStyle where Self == ContainerGroupBoxStyle {
    static var contain: Self { Self() }
}

extension View {
    /// This method wraps the view inside a GroupBox
    /// and adds accessibilityIdentifier to it
    func groupBoxAccessibilityIdentifier(_ identifier: String) -> some View {
        GroupBox {
            self
        }
        .groupBoxStyle(.contain)
        .accessibilityIdentifier(identifier)
    }
}

extension Color {
   static let appBarColor = Color("AppBarColor")
   static let firstEventCardColor = Color("FirstEventCard")
   static let secondEventCardColor = Color("SecondEventCard")
   static let thirdEventCardColor = Color("ThirdEventCard")
   static let shadowColor = Color("ShadowColor")
   static let dividerColor = Color("Divider")
   static let filterBarPrimaryColor = Color("FilterBarPrimaryColor")
   static let filterBarAccentColor = Color("FilterBarAccentColor")
   static let filterBarSelectedTextColor = Color("FilterBarSelectedTextColor")
   static let acceptButtonColor = Color("AcceptButtonColor")
   static let declineButtonColor = Color("DeclineButtonColor")
}

extension UIColor {
    static let barColor = UIColor(named: "BottomBarColor")
}

extension Image {
    static let backgroundImage = Image("MainBackground")
    static let blurredImage = Image("BlurredBackground")
    static let profilePicturePen = Image("penProfileScreen")
    static let checkmark = Image(systemName: "person.fill.checkmark")
    static let doorRightHandOpen = Image(systemName: "door.right.hand.open")
    static let profilelines = Image("profilelines")
    static let plusImage = Image("EventViewPlusSign")
    static let avatarImage = Image("avatar_default")
}

extension Date {
//    func toSupabaseFormat() {
//        var formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        return formatter.date(from: self)
//    }
//    
    func toString(format: String = "dd/MM/yyyy, HH:mm:ss") -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter.string(from: self)
        }
    
    func justTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateConstants.JUST_TIME
        return formatter.string(from:self)
    }
    
    func formattedWithOrdinal() -> String {
            let formatter = DateFormatter()
        formatter.dateFormat = DateConstants.MONTH_DAY
            let dayWithSuffix = dayWithOrdinal()
            return formatter.string(from: self).replacingOccurrences(of: String(Calendar.current.component(.day, from: self)), with: dayWithSuffix)
    }
    
    private func dayWithOrdinal() -> String {
        let day = Calendar.current.component(.day, from: self)
        
        switch day {
        case 11...13:
            return "\(day)" + DateConstants.TH_SUFFIX
        default:
            switch day % 10 {
            case DaySuffix.DAY_1:
                return "\(day)" + DateConstants.ST_SUFFIX
            case DaySuffix.DAY_2:
                return "\(day)" + DateConstants.ND_SUFFIX
            case DaySuffix.DAY_3:
                return "\(day)" + DateConstants.RD_SUFFIX
            default:
                return "\(day)" + DateConstants.TH_SUFFIX
            }
        }
    }
}
