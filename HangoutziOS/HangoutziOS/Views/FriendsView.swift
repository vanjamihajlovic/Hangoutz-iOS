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
    @State var showSheet: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    TextField("", text: $friendViewModel.searchText,prompt:
                                Text("Search...")
                        .foregroundColor(Color.gray)
                    )
                    .accessibilityIdentifier("friendsSearchField")
                    if !friendViewModel.searchText.isEmpty {
                        Button(action: {
                            friendViewModel.searchText = ""
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
                
                if friendViewModel.sortedFriends.isEmpty{
                    Spacer()
                    Text("No friends found.")
                        .foregroundColor(Color.white)
                    Spacer()
                }
                else {
                    List {
                        ForEach(friendViewModel.sortedFriends) { friend in
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
                        .onDelete(perform: deleteFriend)
                        .listRowSeparator(.hidden)
                        
                    }
                    .scrollContentBackground(.hidden)
                    
                    
                }
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
//    func deleteFriend(at offsets: IndexSet) {
//        for index in offsets {
//            // Dohvatanje prijatelja koji se briše
//            let friend = friendViewModel.sortedFriends[index]
//            
//            Task {
//                // Poziv API-ja za brisanje prijatelja
//                let statusCode = await friendViewModel.deleteFriend(friendId: friend.id)
//                
//                if statusCode == 200 {
//                    print("Friend deleted successfully.")
//                    // Nakon uspešnog brisanja, ponovo preuzmi sve prijatelje
//                    await friendViewModel.getFriends()
//                } else {
//                    print("Failed to delete friend. API returned status code \(statusCode)")
//                    // Ovde možete prikazati notifikaciju korisniku ako želite.
//                }
//            }
//        }
//    }
//    func deleteFriend(at offsets: IndexSet) {
//        Task {
//            for index in offsets {
//                guard index < friendViewModel.sortedFriends.count else { continue }
//                let friendToDelete = friendViewModel.sortedFriends[index]
//                
//                let statusCode = await friendViewModel.deleteFriend(friendId: friendToDelete.id)
//                if statusCode == 200 {
//                    DispatchQueue.main.async {
//                        friendViewModel.sortedFriends.remove(at: index)
//                    }
//                } else {
//                    print("Failed to delete friend. API returned status code \(statusCode)")
//                }
//            }
//            // Opcionalno osvežavanje svih prijatelja
//            DispatchQueue.main.async {
//                Task {
//                    await friendViewModel.getFriends()
//                }
//            }
//        }
//    }
    func deleteFriend(at offsets: IndexSet) {
        Task {
            for index in offsets {
                guard index < friendViewModel.sortedFriends.count else { continue }
                let friendToDelete = friendViewModel.sortedFriends[index]
                
                let statusCode = await friendViewModel.deleteFriend(friendId: friendToDelete.id)
                if statusCode == 200 {
                    print("Successfully deleted friend: \(friendToDelete.name)")
                } else {
                    print("Deleting friend with ID: \(friendToDelete.id)")
                    print("Failed to delete friend. API returned status code \(statusCode)")
                }
            }
            // Osveži celu listu prijatelja
            DispatchQueue.main.async {
                Task {
                    await friendViewModel.getFriends()
                }
            }
        }
    }



}


#Preview {
    FriendsView()
}

struct PopupView: View {
    @ObservedObject var friendViewModel = FriendsViewModel()
    @State private var excludedFriendIds: [String] = []
    
    var body: some View {
        ZStack {
            Color("AddFriendsPopupColor")
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    TextField("", text: $friendViewModel.searchUser,prompt:
                                Text("Search...")
                        .foregroundColor(Color.black)
                    )
                    .accessibilityIdentifier("usersSearchField")
                    .padding()
                    .onChange(of: friendViewModel.searchUser) { newValue in
                        if newValue.count >= 3 {
                            Task {
                                await friendViewModel.getUsersWhoAreNotFriends()
                            }
                        }
                    }
                    
                    if !friendViewModel.searchUser.isEmpty {
                        Button(action: {
                            friendViewModel.searchUser = ""
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
                
                if friendViewModel.searchUser.count >= 3{
                    ScrollView{
                        ForEach(friendViewModel.notFriends){ user in
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
                                Text(user.name ?? "")
                                    .font(.title3).padding(.leading, 10)
                                    .foregroundColor(Color("FriendFontColor"))
                                    .accessibilityIdentifier("userName")
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        Task {
                                            await friendViewModel.addFriend(friendId: user.id ?? "")
                                            await friendViewModel.reverseAddFriend(friendId: user.id ?? "")
                                            await friendViewModel.getFriends()
                                            await friendViewModel.getUsersWhoAreNotFriends()
                                        }
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
            .onAppear {
                Task {
                    await friendViewModel.getFriends()
                    await friendViewModel.getUsersWhoAreNotFriends()
                }
            }
        }
    }
}
