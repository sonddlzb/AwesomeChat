//
//  HomeViewModel.swift
//  AwesomeChat
//
//  Created by đào sơn on 01/03/2024.
//

import Foundation
import RxSwift

class HomeViewModel {
    var navigator: HomeNavigatorType
    var userInfo: UserInfo

    init(navigator: HomeNavigatorType, userInfo: UserInfo) {
        self.userInfo = userInfo
        self.navigator = navigator
    }
}

extension HomeViewModel: ViewModelType {
    struct Input {
        let viewDidAppear: Observable<Void>
    }

    struct Output {
        let bindUserInfo: Observable<UserInfo?>
    }

    func transform(_ input: Input) -> Output {
        let bindUserInfo = input.viewDidAppear
            .map { [weak self] in
                return self?.userInfo
            }

        return .init(bindUserInfo: bindUserInfo)
    }
}
