//
//  User.swift
//  SocialNework
//
//  Created by Oleksii Irzhavskyi on 28.12.2022.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable,Codable{
    @DocumentID var id: String?
    var userName: String
    var userBio: String
    var userBioLink: String
    var userUID: String
    var userEmail: String
    var userProfileURl: URL
    
    enum CodingKeys: CodingKey{        
        case id
        case userName
        case userBio
        case userBioLink
        case userUID
        case userEmail
        case userProfileURl
    }
}
