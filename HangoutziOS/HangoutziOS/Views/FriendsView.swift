//
//  FriendsView.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/21/24.
//
import SwiftUI

struct FriendsView: View {
    @State private var searchText = ""
    @State private var friends: [String] = [
        "Bojan Rajin",
        "Nikola Grujic",
        "Mirjana Lakic",
        "Jelisaveta BG",
        "Ivana Korpak",
        "Srki",
        "Mladen"
    ]

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                TextField("", text: $searchText,
                          prompt:
                            Text("Search...")
                            .foregroundColor(Color.gray)
                    )
                    .padding(12)
                    .background(Color("SearchBarColor"))
                    .cornerRadius(20)
                    .padding(.horizontal, 16)
                    .overlay(
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.trailing, 25)
                        }
                    )
                    .padding(.top, 30)

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredFriends, id: \.self) { friend in
                            HStack {
                                Circle()
                                    .strokeBorder(Color.orange, lineWidth: 3)
                                    .background(Circle().fill(Color.white))
                                    .frame(width: 40, height: 40)

                                Text(friend)
                                    .font(.system(size: 18))
                                    .foregroundColor(.black)
                                    .bold()
                                    .padding(.leading, 10)

                                Spacer()
                            }
                            .padding()
                            .background(Color("FriendsColor"))
                            .cornerRadius(22)
                            .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.top, 10)
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.orange)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .padding()
                    }
                }
            }
        }
        .applyGlobalBackground()
    }

    var filteredFriends: [String] {
        if searchText.isEmpty {
            return friends
        } else {
            return friends.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
}

#Preview {
    FriendsView()
}
