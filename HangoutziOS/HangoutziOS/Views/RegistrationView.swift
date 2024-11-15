//
//  RegistrationView.swift
//  HangoutziOS
//
//  Created by User01 on 11/15/24.
//

import SwiftUI

struct RegistrationView: View {
    var body: some View {
        ZStack {
            VStack{
                GlobalLogoView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .applyGlobalBackground()
        
    }
}

#Preview {
    RegistrationView()
}
