//
//  SignInViewModel.swift
//  AwesomeChat
//
//  Created by đào sơn on 01/03/2024.
//

import Foundation
import RxSwift

class SignInViewModel {
    var navigator: SignInNavigatorType

    init(navigator: SignInNavigatorType) {
        self.navigator = navigator
    }
}

extension SignInViewModel: ViewModelType {
    struct Input {
        let didTapSignIn: Observable<(String?, String?)>
        let didChangeInfor: Observable<(String?, String?)>
        let didTapSignUp: Observable<Void>
    }

    struct Output {
        let pushToHome: Observable<UIViewController?>
        let changeInforStatus: Observable<Bool>
        let pushToSignUp: Observable<SignUpViewController?>
    }
}

extension SignInViewModel {
    func transform(_ input: Input) -> Output {
        let pushToHome: Observable<UIViewController?> = input.didTapSignIn
            .flatMap { [weak self] (email, password) in
                UserInfoHelper.shared.signIn(email: email ?? "", password: password ?? "")
                    .map { (userInfo, signState) in
                        if let userInfo = userInfo {
                            print("Sign in successfully with user \(userInfo.name)")
                            return self?.navigator.pushToHome(userInfo: userInfo)
                        } else {
                            return self?.navigator.presentAlert(signState: signState)
                        }

                    }
            }

        let changeInforStatus = input.didChangeInfor
            .map { (email, password)  in
                guard let email = email, let password = password else {
                    return false
                }

                return !email.isEmpty && !password.isEmpty
            }

        let pushToSignUp = input.didTapSignUp
            .map { [weak self] in
                return self?.navigator.pushToSignUp()
            }

        return .init(pushToHome: pushToHome, 
                     changeInforStatus: changeInforStatus,
                     pushToSignUp: pushToSignUp)
    }
}
