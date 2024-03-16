//
//  ChatItem.swift
//  AwesomeChat
//
//  Created by đào sơn on 15/03/2024.
//

import Foundation
import Photos

struct ChatItem {
    var content: String
    var isSender: Bool
    var time: String
    var asset: PHAsset?

    init(dict: NSDictionary) {
        self.content = dict.value(forKey: "content") as? String ?? ""
        self.isSender = dict.value(forKey: "isSender") as? Bool ?? false
        self.time = dict.value(forKey: "time") as? String ?? ""
    }

    init(content: String, isSender: Bool, time: String, asset: PHAsset? = nil) {
        self.content = content
        self.isSender = isSender
        self.time = time
        self.asset = asset
    }
}
