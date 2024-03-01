//
//  HomeViewController.swift
//  AwesomeChat
//
//  Created by đào sơn on 01/03/2024.
//

import UIKit
import Stevia
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    var viewModel: HomeViewModel
    var disposeBag = DisposeBag()

    private lazy var containerView = UIView()
    private lazy var nameLbL = UILabel()
    private lazy var signOutButton = UIButton()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        // Do any additional setup after loading the view.
        setUpViews()
        layoutViews()
        styleViews()
        bindViewModel()
    }

    private func setUpViews() {
        view.subviews {
            containerView
        }

        containerView.subviews {
            nameLbL
            signOutButton
        }
    }

    private func layoutViews() {
        containerView.centerInContainer()
        containerView.Width == view.Width
        containerView.Height == view.Height

        signOutButton.Height == 50.0
        signOutButton.Width == 200.0
        signOutButton.centerInContainer()

        nameLbL.Bottom == signOutButton.Top - 30.0
        nameLbL.centerHorizontally()
    }

    private func styleViews() {
        signOutButton.style {
            $0.setTitle("Sign out", for: .normal)
        }
    }

    private func bindViewModel() {
        let viewDidAppear = self.rx.methodInvoked(#selector(viewDidAppear(_:)))
            .map { _ in
            return ()
        }

        let output = self.viewModel.transform(.init(viewDidAppear: viewDidAppear))
        output.bindUserInfo
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] userInfo in
                guard let self = self, let userInfo = userInfo else {
                    return
                }

                self.nameLbL.text = "Welcome \(userInfo.name)"
            }
            .disposed(by: self.disposeBag)

        self.signOutButton.rx.tap
            .subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
            .disposed(by: self.disposeBag)
    }
}
