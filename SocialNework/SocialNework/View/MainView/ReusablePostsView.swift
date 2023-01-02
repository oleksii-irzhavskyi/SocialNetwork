//
//  ReusablePostsView.swift
//  SocialNework
//
//  Created by Oleksii Irzhavskyi on 02.01.2023.
//

import SwiftUI
import Firebase

struct ReusablePostsView: View {
    @Binding var posts: [Post]
    //View Properties
    @State var isFetching: Bool = false
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack{
                if isFetching{
                    ProgressView()
                        .padding(.top,30)
                }else{
                    if posts.isEmpty{
                        //No Posts in firebase
                        Text("No Posts Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top,30)
                    }else{
                        //Dispalying Posts
                        Posts()
                    }
                }
            }
            .padding(15)
        }
        .refreshable {
            isFetching = true
            posts = []
            await fetchPosts()
        }
        .task {
            //fetching posts
            guard posts.isEmpty else{return}
            await fetchPosts()
        }
    }
    
    //Dispaying posts
    @ViewBuilder
    func Posts()->some View{
        ForEach(posts){post in
            PostCardView(post: post) { updatedPost in
                //updating post in the array
                if let index = posts.firstIndex(where: { post in
                    post.id == updatedPost.id
                }){
                    posts[index].likedIDs = updatedPost.likedIDs
                    posts[index].dislikedIDs = updatedPost.dislikedIDs
                }
            } onDelete: {
                //removing post from the array
                withAnimation(.easeInOut(duration: 0.25)){
                    posts.removeAll{post.id == $0.id}
                }
            }
            
            Divider()
                .padding(.horizontal,-15)
        }
    }
    
    //fetching post
    func fetchPosts()async{
        do{
            var query: Query!
            query = Firestore.firestore().collection("Posts")
                .order(by: "publishedDate", descending: true)
                .limit(to: 20)
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap { doc -> Post? in
                try? doc.data(as: Post.self)
            }
            await MainActor.run(body: {
                posts = fetchedPosts
                isFetching = false
            })
        }catch{
            print(error.localizedDescription)
        }
    }
}

//struct ReusablePostsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReusablePostsView()
//    }
//}
