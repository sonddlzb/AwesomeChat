//
//  UserInfo.swift
//  AwesomeChat
//
//  Created by đào sơn on 03/03/2024.
//

import Foundation

struct UserInfo {
    var name: String
    var email: String
    var password: String

    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }

    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
    }

    func asDictionary() -> [String: Any] {
        return ["name": name, "email": email, "password": password]
    }
}

enum SignState {
    case invalidCredentials
    case duplicatedEmail
    case emptyField
    case success
    case invalidInfor
}
