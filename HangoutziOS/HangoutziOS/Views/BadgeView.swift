//
//  BadgeView.swift
//  HangoutziOS
//
//  Created by User03 on 12/4/24.
//

import SwiftUI

struct BadgeView: View {
    @ObservedObject var eventViewModel = EventViewModel.shared
    
    var body: some View {
        ZStack {
            if eventViewModel.badgeCount > 0 {
                Circle()
                    .fill(Color.red)
                    .frame(width: 20, height: 20)
                Text("\(eventViewModel.badgeCount)")
                    .foregroundColor(.white)
                    .font(.caption)
                    .bold()
            }
        }
        .offset(x: 40, y: -10)
    }
}

#Preview {
    BadgeView()
}
