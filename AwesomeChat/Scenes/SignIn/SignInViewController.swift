//
//  SignInViewController.swift
//  AwesomeChat
//
//  Created by đào sơn on 01/03/2024.
//

import UIKit
import Stevia
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {
    var viewModel: SignInViewModel
    var disposeBag = DisposeBag()

    private lazy var containerView = UIView()
    private lazy var headerImgView = UIImageView()
    private lazy var titleLbl = UILabel()
    private lazy var signInLbl = UILabel()
    private lazy var emailContainer = UIView()
    private lazy var emailLbl = UILabel()
    private lazy var emailTextField = UITextField()
    private lazy var emailBorderView = UIView()
    private lazy var emailImgView = UIImageView()
    private lazy var passwordContainer = UIView()
    private lazy var passwordLbl = UILabel()
    private lazy var passwordTextField = UITextField()
    private lazy var passwordBorderView = UIView()
    private lazy var passwordImgView = UIImageView()
    private lazy var forgotLBl = UILabel()
    private lazy var forgotButton = UIButton()
    private lazy var signInButton = UIButton()
    private lazy var signUpContainer = UIView()
    private lazy var questionLbl = UILabel()
    private lazy var signUpLbl = UILabel()
    private lazy var signUpButton = UIButton()

    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpViews()
        layoutViews()
        styleViews()
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.layer.cornerRadius = 30.0
    }

    func setUpViews() {
        view.subviews {
            containerView
        }

        containerView.subviews {
            headerImgView
            titleLbl
            signInLbl
            emailContainer
            passwordContainer
            forgotLBl
            forgotButton
            signInButton
            signUpContainer
        }

        emailContainer.subviews {
            emailLbl
            emailImgView
            emailTextField
            emailBorderView
        }

        passwordContainer.subviews {
            passwordLbl
            passwordImgView
            passwordTextField
            passwordBorderView
        }

        signUpContainer.subviews {
            questionLbl
            signUpLbl
            signUpButton
        }
    }

    func layoutViews() {
        containerView.centerInContainer()
        containerView.Width == view.Width
        containerView.Height == view.Height

        headerImgView.Top == containerView.Top + 81.0
        headerImgView.Left == containerView.Left + 24.0
        headerImgView.Height == headerImgView.Width
        headerImgView.Width == containerView.Width * (124.0/375.0)

        titleLbl.Top == headerImgView.Bottom + 3.0
        titleLbl.Left == containerView.Left + 24.0

        signInLbl.Top == titleLbl.Bottom + 12.0
        signInLbl.Left == containerView.Left + 24.0

        emailContainer.Top == signInLbl.Bottom + 60.0
        emailContainer.centerHorizontally()
        emailContainer.Left == containerView.Left + 24.0
        emailContainer.Height == 56.0

        passwordContainer.Top == emailContainer.Bottom + 40.0
        passwordContainer.centerHorizontally()
        passwordContainer.Left == containerView.Left + 24.0
        passwordContainer.Height == 56.0

        emailLbl.Top == emailContainer.Top
        emailLbl.Left == emailContainer.Left

        emailBorderView.Height == 1
        emailBorderView.Left == emailContainer.Left
        emailBorderView.Bottom == emailContainer.Bottom
        emailBorderView.Right == emailContainer.Right

        emailTextField.Top == emailLbl.Bottom + 7.0
        emailTextField.Bottom == emailBorderView.Top - 7.0
        emailTextField.Left == emailContainer.Left
        emailTextField.Right == emailImgView.Left - 10.0

        emailImgView.Height == emailImgView.Width
        emailImgView.Height == 16.0
        emailImgView.CenterY == emailTextField.CenterY
        emailImgView.Right == emailContainer.Right

        passwordLbl.Top == passwordContainer.Top
        passwordLbl.Left == passwordContainer.Left

        passwordBorderView.Height == 1
        passwordBorderView.Left == passwordContainer.Left
        passwordBorderView.Bottom == passwordContainer.Bottom
        passwordBorderView.Right == passwordContainer.Right

        passwordTextField.Top == passwordLbl.Bottom + 7.0
        passwordTextField.Bottom == passwordBorderView.Top - 7.0
        passwordTextField.Left == passwordContainer.Left
        passwordTextField.Right == passwordImgView.Left - 10.0

        passwordImgView.Height == passwordImgView.Width
        passwordImgView.Height == 16.0
        passwordImgView.CenterY == passwordTextField.CenterY
        passwordImgView.Right == passwordContainer.Right

        forgotLBl.Right == containerView.Right - 24.0
        forgotLBl.Top == passwordContainer.Bottom + 15.0

        forgotButton.Top == forgotLBl.Top
        forgotButton.Bottom == forgotLBl.Bottom
        forgotButton.Left == forgotLBl.Left
        forgotButton.Right == forgotLBl.Right

        signInButton.centerHorizontally()
        signInButton.Left == containerView.Left + 24.0
        signInButton.Top == forgotLBl.Bottom + 47.0
        signInButton.Width == signInButton.Height * (326.0/52.0)

        signUpContainer.centerHorizontally()
        signUpContainer.Bottom == containerView.Bottom - 38.0
        signUpContainer.Height == 17.0

        questionLbl.Left == signUpContainer.Left
        questionLbl.Bottom == signUpContainer.Bottom
        questionLbl.Right == signUpLbl.Left

        signUpLbl.Top == signUpContainer.Top
        signUpLbl.Right == signUpContainer.Right
        signUpLbl.Bottom == signUpContainer.Bottom

        signUpButton.Top == signUpLbl.Top
        signUpButton.Bottom == signUpLbl.Bottom
        signUpButton.Left == signUpLbl.Left
        signUpButton.Right == signUpLbl.Right
    }

    func styleViews() {
        signInButton.style {
            $0.setTitle("Đăng nhập", for: .normal)
            $0.isUserInteractionEnabled = false
        }

        headerImgView.style {
            $0.image = R.image.ic_sign_in_header()
        }

        titleLbl.style {
            $0.text = "Trải nghiệm Awesome chat"
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 26.0, weight: .thin)
            $0.textAlignment = .left
        }

        signInLbl.style {
            $0.text = "Đăng nhập"
            $0.textColor = R.color.violet_blue()
            $0.font = .systemFont(ofSize: 32.0, weight: .bold)
            $0.textAlignment = .left
        }

        emailLbl.style {
            $0.text = "EMAIL"
            $0.textColor = R.color.spalish_gray()
            $0.font = .systemFont(ofSize: 14.0, weight: .medium)
            $0.textAlignment = .left
        }

        emailImgView.style {
            $0.image = R.image.ic_mail()
        }

        emailBorderView.style {
            $0.backgroundColor = R.color.light_gray()
        }

        emailTextField.style {
            $0.placeholder = "yourname@gmail.com"
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 18.0, weight: .medium)
        }

        passwordLbl.style {
            $0.text = "MẬT KHẨU"
            $0.textColor = R.color.spalish_gray()
            $0.font = .systemFont(ofSize: 14.0, weight: .medium)
            $0.textAlignment = .left
        }

        passwordImgView.style {
            $0.image = R.image.ic_key()
        }

        passwordBorderView.style {
            $0.backgroundColor = R.color.light_gray()
        }

        passwordTextField.style {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 18.0, weight: .medium)
            $0.isSecureTextEntry = true
        }

        forgotLBl.style {
            $0.text = "Quên mật khẩu?"
            $0.textColor = R.color.violet_blue()
            $0.font = .systemFont(ofSize: 14.0, weight: .semibold)
            $0.textAlignment = .right
        }

        signInButton.style {
            $0.setTitle("ĐĂNG NHẬP", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = R.color.chinese_silver()
        }

        questionLbl.style {
            $0.text = "Chưa có tài khoản?"
            $0.textColor = R.color.spalish_gray()
            $0.font = .systemFont(ofSize: 14.0, weight: .medium)
            $0.textAlignment = .left
        }

        signUpLbl.style {
            $0.text = " Đăng ký ngay"
            $0.textColor = R.color.violet_blue()
            $0.font = .systemFont(ofSize: 14.0, weight: .semibold)
            $0.textAlignment = .left
        }
    }

    func bindViewModel() {
        let didTapSignIn = signInButton.rx.tap
            .asObservable()
            .map { [weak self] in
                 (self?.emailTextField.text, self?.passwordTextField.text)
        }

        let didChangeInfor = Observable.combineLatest(
            emailTextField.rx.text.asObservable(),
            passwordTextField.rx.text.asObservable())
        let didTapSignUp = signUpButton.rx.tap.asObservable()

        let output = viewModel.transform(
            .init(didTapSignIn: didTapSignIn,
                  didChangeInfor: didChangeInfor,
                  didTapSignUp: didTapSignUp))

        output.pushToHome
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] viewController in
                if let alertVC = viewController as? UIAlertController {
                    self?.present(alertVC, animated: true)
                } else if let mainVC = viewController as? MainViewController {
                    self?.navigationController?.pushViewController(mainVC, animated: true)
                }
            }
            .disposed(by: self.disposeBag)

        output.changeInforStatus
            .subscribe(on: MainScheduler.asyncInstance)
            .map {
                $0 ? R.color.violet_blue() : R.color.chinese_silver()
            }
            .bind(to: signInButton.rx.backgroundColor)
            .disposed(by: self.disposeBag)

        output.changeInforStatus
            .subscribe(on: MainScheduler.asyncInstance)
            .bind(to: signInButton.rx.isUserInteractionEnabled)
            .disposed(by: self.disposeBag)

        output.pushToSignUp
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] signUpVC in
                guard let self = self, let signUpVC = signUpVC else {
                    return
                }

                self.navigationController?.pushViewController(signUpVC, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}
