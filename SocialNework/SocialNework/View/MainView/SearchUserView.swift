//
//  SearchUserView.swift
//  SocialNework
//
//  Created by Oleksii Irzhavskyi on 04.01.2023.
//

import SwiftUI
import FirebaseFirestore

struct SearchUserView: View {
    //view properties
    @State private var fetchedUsers: [User] = []
    @State private var searchText: String = ""
//    var searchResults: [User]{
//        if searchText.isEmpty{
//            return []
//        }else{
//            return
//        }
//    }
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        List{
            ForEach(fetchedUsers){user in
                NavigationLink{
                    ReusableProfileContent(user: user)
                } label: {
                    Text(user.userName)
                        .font(.callout)
                        .hAlign(.leading)
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Search user")
        .searchable(text: $searchText)
        .onSubmit(of: .search, {
            //fetch user from firebase
            Task{await searchUsers()}
        })
        .onChange(of: searchText, perform: { newValue in
            if newValue.isEmpty{
                fetchedUsers = []
            }else{
                Task{await searchUsers()}
            }
        })
    }
    
    func searchUsers()async{
        do{
            let documents = try await Firestore.firestore().collection("Users")
                .whereField("userName", isGreaterThanOrEqualTo: searchText)
                .whereField("userName", isLessThanOrEqualTo: "\(searchText)\u{f8ff}")
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> User? in
                try doc.data(as: User.self)
            }
            //UI must be updated
            await MainActor.run(body: {
                fetchedUsers = users
            })
        }catch{
            print(error.localizedDescription)
        }
    }
}

struct SearchUserView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserView()
    }
}
