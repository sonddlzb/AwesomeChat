//
//  MainViewModel.swift
//  AwesomeChat
//
//  Created by đào sơn on 16/03/2024.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    var navigator: MainNavigatorType
    var userInfo: UserInfo
    var disposeBag = DisposeBag()

    init(navigator: MainNavigatorType, userInfo: UserInfo) {
        self.userInfo = userInfo
        self.navigator = navigator
    }
}

extension MainViewModel: ViewModelType {
    struct Input {
        let didLoadTrigger: Observable<MainState>
        let didTapState: Observable<MainState>
    }

    struct Output {
        let pushToChild: Observable<UIViewController>
    }

    func transform(_ input: Input) -> Output {
        let userInfo = userInfo
//        input.didLoadTrigger.subscribe(onNext: { state in
//            print("main appear with \(state)")
//        })
//        .disposed(by: disposeBag)

        let pushToChild = Observable.merge(input.didTapState, input.didLoadTrigger)
            .map { [weak self] state in
                guard let self = self else {
                    return UIViewController()
                }

                switch state {
                case .message:
                    return self.navigator.pushToHome(userInfo: userInfo)
                case .friend:
                    return self.navigator.pushToFriend()
                case .profile:
                    return self.navigator.pushToProfile()
                }
            }

        return .init(pushToChild: pushToChild)
    }
}
