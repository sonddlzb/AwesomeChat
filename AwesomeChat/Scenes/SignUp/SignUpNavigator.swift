//
//  SignUpNavigator.swift
//  AwesomeChat
//
//  Created by đào sơn on 02/03/2024.
//

import UIKit

protocol SignUpNavigatorType {
    func presentAlert(signState: SignState) -> UIAlertController
}

struct SignUpNavigator: SignUpNavigatorType {
    func presentAlert(signState: SignState) -> UIAlertController {
        var title = ""
        var message = ""
        switch signState {
        case .duplicatedEmail:
            title = "Failed to sign up"
            message = "This email was registed before. Try another one!"
        case .emptyField:
            title = "Failed to sign up"
            message = "Fields must not be empty!"
        case .success:
            title = "Sign up successfully"
            message = "Please sign in to continue."
        default:
            break
        }

        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        alertVC.addAction(okAction)
        return alertVC
    }
}
