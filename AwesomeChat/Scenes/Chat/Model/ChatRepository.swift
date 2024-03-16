//
//  ChatRepository.swift
//  AwesomeChat
//
//  Created by đào sơn on 15/03/2024.
//

import Foundation
import Photos

protocol ChatRepositoryType {
    mutating func getData() -> [ChatItem]
    mutating func addNewItem(_ chatItem: ChatItem)
}

struct ChatRepository: ChatRepositoryType {
    var listChatItems: [ChatItem] = []

    mutating func getData() -> [ChatItem] {
        if listChatItems.isEmpty {
            let chatItems = self.fetchChatData()
            listChatItems = chatItems
            return chatItems
        } else {
            return listChatItems
        }
    }

    mutating func addNewItem(_ chatItem: ChatItem) {
        listChatItems.append(chatItem)
    }

    func fetchChatData() -> [ChatItem] {
        var chatItems: [ChatItem] = []
        guard let chatFilePath = Bundle.main.path(forResource: "ChatData",
                                                  ofType: "json") else {
            return []
        }

        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: chatFilePath))
            guard let dataDict = try JSONSerialization
                .jsonObject(with: jsonData, options: []) as? NSDictionary else {
                return []
            }

            guard let dataArr = dataDict.value(forKey: "data") as? NSArray else {
                return []
            }

            dataArr.forEach {
                if let dict = $0 as? NSDictionary {
                    chatItems.append(ChatItem(dict: dict))
                }
            }

        } catch {
            print("Lỗi khi đọc tệp JSON: \(error.localizedDescription)")
        }

        return chatItems
    }
}
