//
//  SignUpViewModel.swift
//  AwesomeChat
//
//  Created by đào sơn on 02/03/2024.
//

import Foundation
import RxSwift

class SignUpViewModel {
    var navigator: SignUpNavigatorType

    init(navigator: SignUpNavigatorType) {
        self.navigator = navigator
    }
}

extension SignUpViewModel: ViewModelType {
    struct Input {
        let didChangeInfor: Observable<(String?, String?, String?)>
        let didTapSignUp: Observable<(String?, String?, String?)>
    }

    struct Output {
        let changeInforStatus: Observable<SignState>
        let presentAlert: Observable<UIAlertController>
    }
}

extension SignUpViewModel {
    func transform(_ input: Input) -> Output {
        let changeInforStatus = input.didChangeInfor
            .flatMap { (name, email, password)  in
                guard let name = name, let email = email, let password = password else {
                    return Observable.just(SignState.emptyField)
                }

                let userInfor = UserInfo(name: name, email: email, password: password)
                return UserInfoHelper.shared.validInfo(userInfor: userInfor)
            }

        let presentAlert = input.didTapSignUp
            .flatMap { (name, email, password) in
                guard let name = name, let email = email, let password = password else {
                    return Observable.just(UIAlertController())
                }

                let userInfor = UserInfo(name: name, email: email, password: password)
                return UserInfoHelper.shared.signUp(userInfo: userInfor)
                    .map { [weak self] signState in
                        guard let self = self else {
                            return UIAlertController()
                        }
                        return self.navigator.presentAlert(signState: signState)
                }
            }
        return .init(changeInforStatus: changeInforStatus,
                     presentAlert: presentAlert)
    }
}
