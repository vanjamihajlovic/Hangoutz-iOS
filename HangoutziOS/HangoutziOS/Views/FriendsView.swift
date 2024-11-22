//
//  FriendsView.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/21/24.
//

import SwiftUI

struct FriendsView: View {

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
            
            Text("Friends screen")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    FriendsView()
}
