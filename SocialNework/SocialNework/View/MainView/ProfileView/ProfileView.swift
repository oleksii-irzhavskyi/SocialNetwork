//
//  ProfileView.swift
//  SocialNework
//
//  Created by Oleksii Irzhavskyi on 29.12.2022.
//

import SwiftUI
import Firebase
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

struct ProfileView: View {
    //Profeli data
    @State private var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false
    //Error Message
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    var body: some View {
        NavigationStack{
            VStack{
                if let myProfile{
                    ReusableProfileContent(user: myProfile)
                        .refreshable {
                            //refresh user data
                            self.myProfile = nil
                            await FetchUserData()
                        }
                }else{
                    ProgressView()
                }
            }
            .navigationTitle("My Profile")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        //Logout and Delete account
                        Button("Logout", action: logOutUser)
                        
                        Button("Delete Account", role: .destructive, action: deleteAccount)
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(.black)
                            .scaleEffect(0.8)
                    }

                }
            }
        }
        .overlay {
            LoadingView(show: $isLoading)
        }
        .alert(errorMessage, isPresented: $showError) {
        }
        .task {
            //This Modifer is like OnAppear
            //So Fetching for the First Time Only
            if myProfile != nil{return}
            //Initial Fetch user data
            await FetchUserData()
        }
    }
    
    //Fetching User Data
    func FetchUserData()async{
        guard let userUID = Auth.auth().currentUser?.uid else{return}
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self) else {return}
        await MainActor.run(body: {
            myProfile = user
        })
    }
    
    //Logging user out
    func logOutUser(){
        try? Auth.auth().signOut()
        logStatus = false
    }
    
    //Deleting User Account
    func deleteAccount(){
        isLoading = true
        Task{
            do{
                guard let userUID = Auth.auth().currentUser?.uid else {return}
                //delete profile photo
                let reference = Storage.storage().reference().child("Profile_Images").child(userUID)
                try await reference.delete()
                //delete firestore user
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                // delete auth account
                try await Auth.auth().currentUser?.delete()
                logStatus = false
            }catch{
                await setError(error)
            }
        }
    }
    
    //setting error
    func setError(_ error: Error)async{
        //UI Must be run on Main Thread
        await MainActor.run(body: {
            isLoading = false
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
