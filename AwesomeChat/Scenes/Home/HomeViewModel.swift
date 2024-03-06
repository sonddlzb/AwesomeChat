//
//  HomeViewModel.swift
//  AwesomeChat
//
//  Created by đào sơn on 01/03/2024.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    var navigator: HomeNavigatorType
    var userInfo: UserInfo
    var listMessages: [Message] = []

    init(navigator: HomeNavigatorType, userInfo: UserInfo) {
        self.userInfo = userInfo
        self.navigator = navigator
        createMessages()
    }

    func createMessages() {
        self.listMessages = [
            Message(id: "1", 
                    name: "Phạm Long",
                    message: "Chào em. Anh đứng đây từ chiều", 
                    time: "11:52"),
            Message(id: "2",
                    name: "Johnson Baby",
                    message: "Xin chào bạn. Tên tôi là Johnson", 
                    time: "10:09"),
            Message(id: "3",
                    name: "Trần Hương Mai",
                    message: "Tớ sẽ liên hệ với bạn sớm nhất có thể", 
                    time: "08:00"),
            Message(id: "4",
                    name: "Kevin Dinh Khanh",
                    message: "Ông biết chuyện gì chưa. Vụ này căng lắm", 
                    time: "Hôm qua"),
            Message(id: "5",
                    name: "Hải Anh",
                    message: "Hôm qua chị quên k đưa cho em tiền mặt", 
                    time: "05/03/2024"),
            Message(id: "6",
                    name: "Ánh Ngọc Nguyễn",
                    message: "Chào em. Anh là Minh đến từ công ty Yopaz", 
                    time: "05/03/2024"),
            Message(id: "7", 
                    name: "Quang Huy",
                    message: "Tôi đã liên hệ cho bạn từ hôm qua nhưng không được",
                    time: "04/03/2024"),
            Message(id: "8", 
                    name: "Xuân Anh",
                    message: "Gọi cho tôi khi cậu đến nơi nhé",
                    time: "02/03/2024")
        ]
    }
}

extension HomeViewModel: ViewModelType {
    struct Input {
        let viewDidLoad: Observable<Void>
    }

    struct Output {
        let bindTableData: Observable<[Message]>
    }

    func transform(_ input: Input) -> Output {
        let listMessages = self.listMessages
        let bindTableData: Observable<[Message]> = input.viewDidLoad
            .map {
                return listMessages
            }

        return .init(bindTableData: bindTableData)
    }
}
