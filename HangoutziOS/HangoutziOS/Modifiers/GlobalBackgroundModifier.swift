//
//  GlobalBackgroundModifier.swift
//  HangoutziOS
//
//  Created by User01 on 11/15/24.
//

import Foundation
import SwiftUI

struct GlobalBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Image("MainBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
            )
    }
}

struct GlobalBlurredBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Image("BlurredBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
            )
    }
}

extension View {
    func applyGlobalBackground() -> some View {
        self.modifier(GlobalBackgroundModifier())
    }
    func applyBlurredBackground() -> some View {
        self.modifier(GlobalBlurredBackgroundModifier())
    }
}

