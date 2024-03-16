//
//  ProfileViewModel.swift
//  AwesomeChat
//
//  Created by đào sơn on 16/03/2024.
//

import Foundation

class ProfileViewModel {
    var navigator: ProfileNavigatorType

    init(navigator: ProfileNavigatorType) {
        self.navigator = navigator
    }
}

extension ProfileViewModel: ViewModelType {
    struct Input {
    }

    struct Output {
    }

    func transform(_ input: Input) -> Output {
        return .init()
    }
}
