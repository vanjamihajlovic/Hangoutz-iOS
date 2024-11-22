//
//  FriendsView.swift
//  HangoutziOS
//
//  Created by User03 on 11/21/24.
//

import SwiftUI

struct FriendsView: View {
    let backgroundImage: String = "MainBackground"

    var body: some View {
        ZStack {
            Image(backgroundImage)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                AppBarView()
                Spacer()
            }
            
            Text("Friends screen")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    FriendsView()
}
