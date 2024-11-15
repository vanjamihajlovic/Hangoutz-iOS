//
//  GlobalLogoView.swift
//  HangoutziOS
//
//  Created by User01 on 11/15/24.
//

import SwiftUI

struct GlobalLogoView: View {
    var body: some View {
               Image("Hangoutz")
                   .resizable()
                   .scaledToFit()
                   .frame(width: 215, height: 50)
           }
    }

#Preview {
    GlobalLogoView()
}
