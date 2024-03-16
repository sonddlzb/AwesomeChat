//
//  MainViewController.swift
//  AwesomeChat
//
//  Created by đào sơn on 16/03/2024.
//

import UIKit
import Stevia
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    private var viewModel: MainViewModel
    private var mainState = BehaviorRelay<MainState>(value: .message)
    private var disposeBag = DisposeBag()

    private lazy var containerView = UIView()
    private lazy var contentView = UIView()
    private lazy var containerBottom = UIView()
    private lazy var menuView = UIView()
    private lazy var stackView = UIStackView()
    private lazy var messageView = UIView()
    private lazy var friendView = UIView()
    private lazy var profileView = UIView()
    private lazy var imgMessage = UIImageView()
    private lazy var lblMessage = UILabel()
    private lazy var btnMessage = UIButton()
    private lazy var imgFriend = UIImageView()
    private lazy var lblFriend = UILabel()
    private lazy var btnFriend = UIButton()
    private lazy var imgProfile = UIImageView()
    private lazy var lblProfile = UILabel()
    private lazy var btnProfile = UIButton()

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        layoutViews()
        styleViews()
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stackView.layer.shadowOffset = CGSize(width: 0, height: 0)
        stackView.layer.shadowOpacity = 0.1
        stackView.layer.shadowRadius = 10.0
        stackView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        stackView.layer.cornerRadius = 12.0
    }

    private func setUpViews() {
        view.subviews {
            containerView
        }

        containerView.subviews {
            contentView
            containerBottom
        }

        containerBottom.subviews {
            stackView
        }

        stackView.arrangedSubviews {
            messageView
            friendView
            profileView
        }

        messageView.subviews {
            imgMessage
            lblMessage
            btnMessage
        }

        friendView.subviews {
            imgFriend
            lblFriend
            btnFriend
        }

        profileView.subviews {
            imgProfile
            lblProfile
            btnProfile
        }
    }

    private func layoutViews() {
        containerView.centerInContainer()
        containerView.Width == view.Width
        containerView.Height == view.Height

        contentView.centerInContainer()
        contentView.Width == containerView.Width
        contentView.Height == containerView.Height

        containerBottom
            .bottom(containerView.bottomAnchor)
            .leading(containerView.leadingAnchor)
            .trailing(containerView.trailingAnchor)
        containerBottom.Width == containerBottom.Height * (375.0/126.0)

        stackView.centerHorizontally()
        stackView.Width == stackView.Height * (351.0/70.0)
        stackView.Width == containerBottom.Width * (351.0/375.0)
        stackView.Bottom == containerBottom.Bottom - 30.0

        lblMessage.centerHorizontally()
        lblMessage.Bottom == messageView.Bottom - 8.0

        imgMessage.centerHorizontally()
        imgMessage.Width == imgMessage.Height
        imgMessage.Height == messageView.Height * (28.0/70.0)
        imgMessage.Bottom == lblMessage.Top - 10.0

        btnMessage.centerInContainer()
        btnMessage.Height == messageView.Height
        btnMessage.Width == messageView.Width

        lblFriend.centerHorizontally()
        lblFriend.Bottom == friendView.Bottom - 8.0

        imgFriend.centerHorizontally()
        imgFriend.Width == imgFriend.Height
        imgFriend.Height == friendView.Height * (28.0/70.0)
        imgFriend.Bottom == lblFriend.Top - 10.0

        btnFriend.centerInContainer()
        btnFriend.Height == friendView.Height
        btnFriend.Width == friendView.Width

        lblProfile.centerHorizontally()
        lblProfile.Bottom == profileView.Bottom - 8.0

        imgProfile.centerHorizontally()
        imgProfile.Width == imgProfile.Height
        imgProfile.Height == profileView.Height * (28.0/70.0)
        imgProfile.Bottom == lblProfile.Top - 10.0

        btnProfile.centerInContainer()
        btnProfile.Height == profileView.Height
        btnProfile.Width == profileView.Width
    }

    private func styleViews() {
        view.style {
            $0.backgroundColor = .white
        }

        containerView.style {
            $0.backgroundColor = .white
        }

        containerBottom.style {
            $0.backgroundColor = R.color.cultured_F6F6F6()
        }

        stackView.style {
            $0.distribution = .fillEqually
            $0.backgroundColor = .white
        }

        lblMessage.style {
            $0.text = "Tin nhắn"
            $0.textColor = R.color.violet_blue()
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 12.0, weight: .bold)
        }

        imgMessage.style {
            $0.image = R.image.ic_chat_filled()
        }

        lblFriend.style {
            $0.text = "Bạn bè"
            $0.textColor = R.color.spalish_gray()
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 12.0, weight: .bold)
        }

        imgFriend.style {
            $0.image = R.image.ic_friend_not_filled()
        }

        lblProfile.style {
            $0.text = "Trang cá nhân"
            $0.textColor = R.color.spalish_gray()
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 12.0, weight: .bold)
        }

        imgProfile.style {
            $0.image = R.image.ic_profile_not_filled()
        }
    }

    private func bindViewModel() {
        mainState
            .asDriver()
            .drive(onNext: { [weak self] mainState in
                self?.updateMainState(mainState)
            })
            .disposed(by: disposeBag)

        let didTapMessage = btnMessage.rx.tap.map { _ in
            return MainState.message
        }

        let didTapFriend = btnFriend.rx.tap.map { _ in
            return MainState.friend
        }

        let didTapProfile = btnProfile.rx.tap.map {
            _ in MainState.profile
        }

        let didLoadTrigger = rx.methodInvoked(#selector(viewWillAppear(_:)))
            .asObservable()
            .map { [weak self] _ in
                return self?.mainState.value ?? .message
            }

        let didTapState = Observable.merge(didTapMessage,
                                           didTapFriend,
                                           didTapProfile)
        .filter { [weak self] newState in
            let isNeedToRoute = newState != self?.mainState.value
            if isNeedToRoute {
                self?.mainState.accept(newState)
            }

            return isNeedToRoute
        }

        let output = self.viewModel.transform(.init(didLoadTrigger: didLoadTrigger,
                                                    didTapState: didTapState))

        output.pushToChild
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] childVC in
                guard let self = self else {
                    return
                }

                self.addChild(childVC, to: self.contentView)
            })
            .disposed(by: disposeBag)
    }

    func updateMainState(_ state: MainState) {
        imgMessage.image = MainState.message.image(currentState: state)
        imgProfile.image = MainState.profile.image(currentState: state)
        imgFriend.image = MainState.friend.image(currentState: state)

        lblMessage.textColor = MainState.message.color(currentState: state)
        lblProfile.textColor = MainState.profile.color(currentState: state)
        lblFriend.textColor = MainState.friend.color(currentState: state)
    }
}
