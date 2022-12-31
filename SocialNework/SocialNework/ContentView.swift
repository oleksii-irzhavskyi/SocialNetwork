//
//  ContentView.swift
//  SocialNework
//
//  Created by Oleksii Irzhavskyi on 22.12.2022.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        //Redirecting user based on log status
        if logStatus{
            MainView()
        }else{
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
