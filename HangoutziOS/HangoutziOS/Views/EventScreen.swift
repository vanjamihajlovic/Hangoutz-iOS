//
//  EventScreen.swift
//  HangoutziOS
//
//  Created by Aleksa on 11/20/24.
//

import SwiftUI

struct EventScreen: View {
    
    var body: some View {
        ZStack {
            Image.backgroundImage
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                AppBarView()
                Spacer()
            }
            
            Text("Event Screen")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    EventScreen()
}
