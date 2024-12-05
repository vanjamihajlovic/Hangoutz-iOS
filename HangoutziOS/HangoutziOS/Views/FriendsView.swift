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
    @State var showSheet: Bool = false
    
    
    
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
                    .accessibilityIdentifier("friendsSearchField")
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }){
                            Image(systemName: "x.circle")
                                .foregroundColor(Color.gray)
                        }
                        .accessibilityIdentifier("friendsSearchFieldClearButton")
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
                    Button(action: {
                        showSheet.toggle()
                    })
                    {
                        Image("AddButtonImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .padding()
                    }
                    .accessibilityIdentifier("AddFriendButton")
                    .sheet(isPresented: $showSheet){
                        PopupView()
                        
                    }
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

struct PopupView: View {
    @State private var searchUser = ""
    @State private var users: [Friend] = [
        Friend(name: "Ana Perić", avatar: "https://via.placeholder.com/50"),
        Friend(name: "Marko Jovanović", avatar: "https://via.placeholder.com/50"),
        Friend(name: "Ivana Stanković", avatar: nil),
        Friend(name: "Bojan Petrović", avatar: "https://via.placeholder.com/50"),
        Friend(name: "Ana Kovačević", avatar: nil),
        Friend(name: "Luka Milenković", avatar: "https://via.placeholder.com/50"),
        Friend(name: "Mila Nikolić", avatar: nil),
        Friend(name: "Nikola Ilić", avatar: "https://via.placeholder.com/50"),
        Friend(name: "Jovana Lukić", avatar: nil),
        Friend(name: "Petar Đorđević", avatar: "https://via.placeholder.com/50")
    ]
    var filteredUsers: [Friend] {
        if searchUser.count >= 3 {
            return users.filter { friend in
                let firstWord = friend.name.components(separatedBy: " ").first ?? ""
                return firstWord.localizedCaseInsensitiveContains(searchUser)
            }
        } else {
            return users
        }
    }
    var sortedUsers: [Friend] {
        filteredUsers.sorted {
            let firstWord1 = $0.name.components(separatedBy: " ").first ?? $0.name
            let firstWord2 = $1.name.components(separatedBy: " ").first ?? $1.name
            return firstWord1.localizedCompare(firstWord2) == .orderedAscending
        }
    }
    
    var body: some View {
        ZStack {
            Color("AddFriendsPopupColor")
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    TextField("", text: $searchUser,prompt:
                                Text("Search...")
                        .foregroundColor(Color.black)
                    )
                    .accessibilityIdentifier("usersSearchField")
                    .padding()
                    
                    if !searchUser.isEmpty {
                        Button(action: {
                            searchUser = ""
                        }){
                            Image(systemName: "x.circle")
                                .foregroundColor(Color.gray)
                        }
                        .accessibilityIdentifier("usersSearchFieldClearButton")
                    }
                }
                .padding(12)
                .cornerRadius(20)
                .frame(width: 320, height:60, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 1)
                        .frame(height: 40)
                )
                .padding(.top, 15)
                
                if searchUser.count >= 3{
                    ScrollView{
                        ForEach(sortedUsers){ user in
                            HStack{
                                if let avatarURL = user.avatar{
                                    AsyncImage(url: URL(string: avatarURL), content: {image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 47, height: 47)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color("FriendAddButton"), lineWidth: 2))
                                    }, placeholder: {
                                        Image("DefaultImage")
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(Color("FriendAddButton"), lineWidth: 2)
                                            )
                                            .frame(width: 47, height: 47)
                                            .accessibilityIdentifier("userImagePlaceholder")
                                    }
                                    )
                                    .accessibilityIdentifier("userImage")
                                } else {
                                    Image("DefaultImage")
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color("FriendAddButton"), lineWidth: 2)
                                        )
                                        .frame(width: 47, height: 47)
                                        .accessibilityIdentifier("defaultUserImage")
                                }
                                Text(user.name)
                                    .font(.title3).padding(.leading, 10)
                                    .foregroundColor(Color("FriendFontColor"))
                                    .accessibilityIdentifier("userName")
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                    })
                                    {
                                        Image("AddButtonImage")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                            .padding()
                                    }
                                    .accessibilityIdentifier("addUserButton")
                                }
                            }
                            .frame(maxWidth: 340, maxHeight: 50, alignment: .leading)
                            .padding(.leading, 35)
                            .groupBoxAccessibilityIdentifier("userListItem")
                            Divider()
                                .frame(height: 1)
                                .background(Color.black)
                                .frame(width: 340)
                                .shadow(color: .black.opacity(0.4), radius: 4, x: 2, y: 2)
                        }
                        Spacer()
                    }
                    .padding(.top, 30)
                }
                else {
                    Spacer()
                    Text("Search for new friends...")
                        .bold()
                    Spacer()
                }
            }
            .presentationDetents([.fraction(0.7)])
        }
    }
}
