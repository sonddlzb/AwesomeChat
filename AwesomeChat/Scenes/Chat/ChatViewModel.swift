//
//  ChatViewModel.swift
//  AwesomeChat
//
//  Created by đào sơn on 07/03/2024.
//

import Foundation
import RxSwift
import RxCocoa

struct ChatItem {
    var content: String
    var isSender: Bool
    var time: String
}

class ChatViewModel {
    var navigator: ChatNavigatorType
    var message: Message
    var listChatItems: [ChatItem] = []

    init(navigator: ChatNavigatorType, message: Message) {
        self.navigator = navigator
        self.message = message
        self.createFakeData()
    }

    func createFakeData() {
        self.listChatItems = [
            ChatItem(content: "Làm xong bài tập thầy Hoàng giao chưa??",
                     isSender: false, 
                     time: "10:03"),
            ChatItem(content: "Ko biết làm. Tí tôi qua nhà bà chép",
                     isSender: true,
                     time: ""),
            ChatItem(content: "Đc ko nè :(",
                     isSender: true,
                     time: "10:05"),
            ChatItem(content: "Mang trà sữa đến thì cho chép nha",
                     isSender: false,
                     time: "10:06"),
            ChatItem(content: "OK luôn",
                     isSender: true,
                     time: "10:07"),
            ChatItem(content: "Đến chưa vậy?",
                     isSender: false,
                     time: "11:52")
        ]
    }
}

extension ChatViewModel: ViewModelType {
    struct Input {
        let viewWillAppear: Observable<Void>
    }

    struct Output {
        let bindMessageData: Observable<Message>
        let bindTableData: Observable<[ChatItem]>
        let bindTableCellHeight: Observable<[CGFloat]>
    }

    func transform(_ input: Input) -> Output {
        let message = self.message
        let listChatItems = self.listChatItems
        let bindMessageData = input.viewWillAppear
            .map {
                return message
            }

        let bindTableData = input.viewWillAppear
            .map {
                return listChatItems
            }

        let bindTableCellHeight = input.viewWillAppear
            .map {
                listChatItems.map {
                    var cellWidth = UIScreen.main.bounds.width * 285.0 / 375.0 - 30.0
                    let content = $0.content
                    let font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
                    let attributes: [NSAttributedString.Key: Any] = [.font: font]
                    let size = (content.trimmingCharacters(in: .whitespacesAndNewlines) as NSString)
                        .size(withAttributes: attributes)
                    let numberOfLines = Int(ceil(size.width / cellWidth))
                    let cellHeight = Double(numberOfLines) * 64.0 + 32.0
                    return CGFloat(cellHeight)
                }
            }

        return .init(bindMessageData: bindMessageData,
                     bindTableData: bindTableData,
                     bindTableCellHeight: bindTableCellHeight)
    }
}
