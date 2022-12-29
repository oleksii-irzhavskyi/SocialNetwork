//
//  MainView.swift
//  SocialNework
//
//  Created by Oleksii Irzhavskyi on 29.12.2022.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        //TabView with posts and profile
        TabView{
            Text("Recent Posts")
                .tabItem {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Posts")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Profile")
                }
        }
        //Changing Tab Lable tint to black
        .tint(.black)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
