//
//  FriendViewModel.swift
//  AwesomeChat
//
//  Created by đào sơn on 16/03/2024.
//

import Foundation

class FriendViewModel {
    var navigator: FriendNavigatorType

    init(navigator: FriendNavigatorType) {
        self.navigator = navigator
    }
}

extension FriendViewModel: ViewModelType {
    struct Input {
    }

    struct Output {
    }

    func transform(_ input: Input) -> Output {
        return .init()
    }
}
