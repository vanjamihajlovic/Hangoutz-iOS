//
//  ProfileView.swift
//  HangoutziOS
//
//  Created by User03 on 11/21/24.
//

import SwiftUI

struct ProfileView: View {
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
            
            Text("Profile Screen")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    ProfileView()
}
