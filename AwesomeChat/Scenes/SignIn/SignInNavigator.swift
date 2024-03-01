//
//  SignInNavigator.swift
//  AwesomeChat
//
//  Created by đào sơn on 01/03/2024.
//

import UIKit

protocol SignInNavigatorType {
    func pushToHome(userInfo: UserInfo) -> HomeViewController
    func pushToSignUp() -> SignUpViewController
    func presentAlert(signState: SignState) -> UIAlertController
}

struct SignInNavigator: SignInNavigatorType {
    func pushToHome(userInfo: UserInfo) -> HomeViewController {
        let homeNavigator = HomeNavigator()
        let homeViewModel = HomeViewModel(navigator: homeNavigator, userInfo: userInfo)
        return HomeViewController(viewModel: homeViewModel)
    }

    func pushToSignUp() -> SignUpViewController {
        let signUpNavigator = SignUpNavigator()
        let signUpViewModel = SignUpViewModel(navigator: signUpNavigator)
        return SignUpViewController(viewModel: signUpViewModel)
    }

    func presentAlert(signState: SignState) -> UIAlertController {
        var title = ""
        var message = ""
        switch signState {
        case .invalidInfor:
            title = "Failed to sign in"
            message = "This email was not valid. Try another one!"
        case .emptyField:
            title = "Failed to sign in"
            message = "Fields must not be empty!"
        case .invalidCredentials:
            title = "Failed to sign in"
            message = "Your email or password is incorrect. Please try again!"
        default:
            break
        }

        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        alertVC.addAction(okAction)
        return alertVC
    }
}
