//
//  SocialNeworkApp.swift
//  SocialNework
//
//  Created by Oleksii Irzhavskyi on 22.12.2022.
//

import SwiftUI
import Firebase

@main
struct SocialNeworkApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
