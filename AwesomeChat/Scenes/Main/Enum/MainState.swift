//
//  MainState.swift
//  AwesomeChat
//
//  Created by đào sơn on 16/03/2024.
//

import UIKit

enum MainState {
    case message
    case friend
    case profile

    func image(currentState: MainState) -> UIImage? {
        let isSelect = self == currentState
        switch self {
        case .message:
            return UIImage(named: "ic_chat_" + (isSelect ? "filled" : "not_filled"))
        case .friend:
            return UIImage(named: "ic_friend_" + (isSelect ? "filled" : "not_filled"))
        case .profile:
            return UIImage(named: "ic_profile_" + (isSelect ? "filled" : "not_filled"))
        }
    }

    func color(currentState: MainState) -> UIColor? {
        return self == currentState ? R.color.violet_blue() : R.color.spalish_gray()
    }
}
