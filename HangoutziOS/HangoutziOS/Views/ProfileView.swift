//
//  ProfileView.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/21/24.
//

import SwiftUI

struct ProfileView: View {
    
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
            
            Text("Profile Screen")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    ProfileView()
}
