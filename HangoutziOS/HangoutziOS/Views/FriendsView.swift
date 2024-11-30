//
//  FriendsView.swift
//  HangoutziOS
//
//  Created by strahinjamil on 11/21/24.
//
import SwiftUI

struct FriendsView: View {
    @AppStorage("currentUserId") var currentUserId: String?
    @ObservedObject var friendViewModel = FriendsViewModel()
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
//        print (friendViewModel.getFriends())
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
                    .padding(.top, 30)

                ScrollView {
                    VStack(spacing: 15) {
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
                            
                            .padding(10)
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
        .onAppear(){
            Task{
                await print (friendViewModel.getFriends())
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
