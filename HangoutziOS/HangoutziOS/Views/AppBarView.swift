//
//  AppBarView.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/21/24.
//

import SwiftUI

struct AppBarView: View {
    
    var body: some View {
        VStack{
            HStack{
                Text(StringConstants.APP_NAME)
                    .foregroundColor(.white)
                    .font(.title2 )
                    .fontWeight(.bold)
                    .padding(.leading, 25)
                    .padding(.bottom, 15)
                    .accessibilityIdentifier("topBarText")
                
                Spacer()
            }
            .background(Color(Color.appBarColor))
            .frame(maxWidth:.infinity)
            .accessibilityIdentifier("topBar")
        }
        .background(Color.appBarColor)
    }
}
#Preview {
    AppBarView()
}
