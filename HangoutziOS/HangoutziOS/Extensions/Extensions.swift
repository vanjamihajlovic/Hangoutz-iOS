//
//  Extensions.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/22/24.
//

import Foundation
import SwiftUICore
import SwiftUI

extension Color {
   static let appBarColor = Color("AppBarColor")
   static let firstEventCardColor = Color("FirstEventCard")
   static let secondEventCardColor = Color("SecondEventCard")
   static let thirdEventCardColor = Color("ThirdEventCard")
   static let shadowColor = Color("ShadowColor")
}

extension UIColor {
    static let barColor = UIColor(named: "BottomBarColor")
}

extension Image {
   static let backgroundImage = Image("MainBackground")
}

extension Date {
    
    func justTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from:self)
    }
    
    func formattedWithOrdinal() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d"
            let dayWithSuffix = dayWithOrdinal()
            return formatter.string(from: self).replacingOccurrences(of: String(Calendar.current.component(.day, from: self)), with: dayWithSuffix)
        }
    
    private func dayWithOrdinal() -> String {
        let day = Calendar.current.component(.day, from: self)
        switch day {
        case 11...13:
            return "\(day)th"
        default:
            switch day % 10 {
            case 1:
                return "\(day)st"
            case 2:
                return "\(day)nd"
            case 3:
                return "\(day)rd"
            default:
                return "\(day)th"
            }
        }
    }
}
