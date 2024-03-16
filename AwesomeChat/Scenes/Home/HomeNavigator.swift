//
//  HomeNavigator.swift
//  AwesomeChat
//
//  Created by đào sơn on 01/03/2024.
//

import Foundation

protocol HomeNavigatorType {
    func pushToChat(message: Message) -> ChatViewController
}

struct HomeNavigator: HomeNavigatorType {
    func pushToChat(message: Message) -> ChatViewController {
        let chatNavigator = ChatNavigator()
        let chatRepository = ChatRepository()
        let chatViewModel = ChatViewModel(navigator: chatNavigator,
                                          message: message,
                                          repository: chatRepository)
        return ChatViewController(viewModel: chatViewModel)
    }
}
