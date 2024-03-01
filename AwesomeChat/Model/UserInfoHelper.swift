//
//  UserInfoHelper.swift
//  AwesomeChat
//
//  Created by đào sơn on 03/03/2024.
//

import Foundation
import RxSwift

class UserInfoHelper {
    static let shared = UserInfoHelper()
    let userDefaults = UserDefaults.standard

    func validInfo(userInfor: UserInfo) -> Observable<SignState> {
        return Observable.create {[weak self] observer in
            if userInfor.name.isEmpty || userInfor.email.isEmpty || userInfor.password.isEmpty {
                observer.onNext(.emptyField)
            } else if let isValidData = self?.isValidEmail(email: userInfor.email), !isValidData {
                observer.onNext(.invalidInfor)
            } else {
                observer.onNext(.success)
            }

            return Disposables.create()
        }
    }

    func signUp(userInfo: UserInfo) -> Observable<SignState> {
        return Observable.create { [weak self] observer in
            if self?.userDefaults.value(forKey: userInfo.email) != nil {
                observer.onNext(.duplicatedEmail)
            } else {
                self?.userDefaults.setValue(userInfo.asDictionary(), forKey: userInfo.email)
                observer.onNext(.success)
            }

            return Disposables.create()
        }
    }

    func signIn(email: String, password: String) -> Observable<(UserInfo?, SignState)> {
        return Observable.create { [weak self] observer in
            if let dict = self?.userDefaults.dictionary(forKey: email) {
                let existedUser = UserInfo(dictionary: dict)
                if existedUser.password == password {
                    observer.onNext((existedUser, .success))
                } else {
                    observer.onNext((nil, .invalidCredentials))
                }
            } else {
                observer.onNext((nil, .invalidCredentials))
            }

            return Disposables.create()
        }
    }

    // MARK: - Helper
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        do {
            let regex = try NSRegularExpression(pattern: emailRegex)
            let nsString = email as NSString
            let results = regex.matches(in: email, 
                                        range: NSRange(location: 0, length: nsString.length))

            return !results.isEmpty
        } catch {
            return false
        }
    }
}
