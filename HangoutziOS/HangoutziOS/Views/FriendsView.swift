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
    var sortedFriends: [Friend] {
        friendViewModel.friends.sorted {
            let firstWord1 = $0.name.components(separatedBy: " ").first ?? $0.name
            let firstWord2 = $1.name.components(separatedBy: " ").first ?? $1.name
            return firstWord1.localizedCompare(firstWord2) == .orderedAscending
        }
    }
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                TextField("", text: $searchText,
                          prompt:
                            Text("Search...")
                    .foregroundColor(Color.gray)
                )
                .accessibilityIdentifier("friendsSearchField")
                .padding(12)
                .background(Color("SearchBarColor"))
                .cornerRadius(20)
                .padding(.horizontal, 16)
                .padding(.top, 30)
                
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
                        .accessibilityIdentifier("friendListItem")
                        .listRowBackground(
                            Rectangle()
                                .fill(Color("FriendsColor"))
                                .frame(width: 360, height: 65)
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
                    .accessibilityIdentifier("dddFriendButton")
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
