//
//  ApplicationNavigator.swift
//  AwesomeChat
//
//  Created by đào sơn on 01/03/2024.
//

import UIKit

protocol ApplicationNavigatorType {
    func makeViewController() -> SignInViewController
}

struct ApplicationNavigator: ApplicationNavigatorType {
    func makeViewController() -> SignInViewController {
        let navigator = SignInNavigator()
        let viewModel = SignInViewModel(navigator: navigator)
        return SignInViewController(viewModel: viewModel)
    }
}
