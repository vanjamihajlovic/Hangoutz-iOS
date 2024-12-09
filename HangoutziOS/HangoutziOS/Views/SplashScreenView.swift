//
//  SplashScreenView.swift
//  HangoutziOS
//
//  Created by Aleksa on 12/8/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            LoginView()
        }
        else{
            ZStack {
                
                VStack {
                    Image.hangoutz.resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 50)
                }.scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.0)){
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .applyBlurredBackground()
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation{
                            self.isActive = true
                        }
                    }
                }
        }
    }
}

#Preview {
    SplashScreenView()
}
