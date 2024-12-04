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
    
    var filteredFriends: [Friend] {
        if searchText.count >= 3 {
            return friendViewModel.friends.filter { friend in
                let firstWord = friend.name.components(separatedBy: " ").first ?? ""
                return firstWord.localizedCaseInsensitiveContains(searchText)
            }
        } else {
            return friendViewModel.friends
        }
    }
    var sortedFriends: [Friend] {
        filteredFriends.sorted {
            let firstWord1 = $0.name.components(separatedBy: " ").first ?? $0.name
            let firstWord2 = $1.name.components(separatedBy: " ").first ?? $1.name
            return firstWord1.localizedCompare(firstWord2) == .orderedAscending
        }
    }
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    TextField("", text: $searchText,prompt:
                        Text("Search...")
                        .foregroundColor(Color.gray)
                    )
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }){
                            Image(systemName: "x.circle")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                .padding(12)
                .background(Color("SearchBarColor").cornerRadius(20))
                .frame(width: 340, height:60, alignment: .center)
                .padding(.top, 10)

                List {
                    ForEach(sortedFriends) { friend in
                        HStack {
                            if let avatarImage = friend.avatar {
                                AsyncImage(url: URL(string: SupabaseConfig.baseURLStorage + avatarImage),
                                    content:{ Image in
                                        Image
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                            .stroke(Color("FriendAddButton"), lineWidth: 4)
                                        )
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                }, placeholder: {
                                    Image("DefaultImage")
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                            .stroke(Color("FriendAddButton"), lineWidth: 2)
                                        )
                                        .frame(width: 50, height: 50)
                                        .accessibilityIdentifier("friendImagePlaceholder")
                                }
                                )
                                .accessibilityIdentifier("friendImage")
                            } else {
                                Image("DefaultImage")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                        .stroke(Color("FriendAddButton"), lineWidth: 2)
                                    )
                                    .frame(width: 50, height: 50)
                                    .accessibilityIdentifier("defaultFriendImage")

                            }
                            Text(friend.name)
                                .accessibilityIdentifier("friendName")
                                .font(.headline)
                                .foregroundColor(Color("FriendFontColor"))
                        }
                        .groupBoxAccessibilityIdentifier("friendListItem")
                        .listRowBackground(
                            Rectangle()
                                .fill(Color("FriendsColor"))
                                .frame(width: 340, height: 65)
                                .cornerRadius(25)
                        )
                        .padding(.vertical, 8)
                    }
                    .listRowSeparator(.hidden)
                }
                .scrollContentBackground(.hidden)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image("AddButtonImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .padding()
                    }
                    .accessibilityIdentifier("AddFriendButton")
                }
            }
        }
        .onAppear(){
            Task {
                await friendViewModel.getFriends()
            }
        }
        .applyGlobalBackground()
    }
}

#Preview {
    FriendsView()
}
