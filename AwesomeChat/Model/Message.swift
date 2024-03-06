//
//  Message.swift
//  AwesomeChat
//
//  Created by đào sơn on 05/03/2024.
//

import UIKit

struct Message {
    var id: String
    var name: String
    var message: String
    var time: String

    func image() -> UIImage? {
        return UIImage(named: "ic_avatar_" + id)
    }
}
