//
//  AddButtonView.swift
//  HangoutziOS
//
//  Created by User01 on 11/28/24.
//

import SwiftUI

struct AddButtonView: View {
    var size: CGFloat = 50  // Veličina dugmeta
        var thickness: CGFloat = 4  // Debljina "+" znaka

        var body: some View {
            ZStack {
                Color(.systemGray5).edgesIgnoringSafeArea(.all)
                            Circle()
                                .fill(Color.yellow) // Žuto dugme
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Text("+")
                                        .font(.system(size: 90, weight: .bold)) // Veliki + znak
                                        .foregroundColor(.yellow) // Ista boja kao dugme
                                        .blendMode(.destinationOut)
                                )
                                .compositingGroup() // Omogućava maskiranje
                                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
            }
            .frame(width: size, height: size)
            .shadow(radius: 5) // Opcioni senka za dugme
            .padding()
        }
}

#Preview {
    AddButtonView()
}
