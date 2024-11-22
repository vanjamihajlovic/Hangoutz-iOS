//
//  AppBarView.swift
//  HangoutziOS
//
//  Created by User03 on 11/21/24.
//

import SwiftUI

struct AppBarView: View {
    let appBarColor = Color("AppBarColor")
    
    var body: some View {
        VStack{
            HStack{
                Text("Hangoutz")
                    .foregroundColor(.white)
                    .font(.title2 )
                    .fontWeight(.bold)
                    .padding(.leading, 25)
                    .padding(.bottom, 15)
                
                Spacer()
            }
            .background(Color(appBarColor))
            .frame(maxWidth:.infinity)
        }
        .background(Color(appBarColor))
    }
}
#Preview {
    AppBarView()
}
