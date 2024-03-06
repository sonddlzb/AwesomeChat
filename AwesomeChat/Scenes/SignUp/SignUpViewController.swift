//
//  SignUpViewController.swift
//  AwesomeChat
//
//  Created by đào sơn on 02/03/2024.
//

import UIKit
import RxSwift
import Stevia

class SignUpViewController: UIViewController {
    var viewModel: SignUpViewModel
    var disposeBag = DisposeBag()

    private lazy var containerView = UIView()
    private lazy var backButton = UIButton()
    private lazy var titleLbl = UILabel()

    private lazy var nameContainer = UIView()
    private lazy var nameLbl = UILabel()
    private lazy var nameTextField = UITextField()
    private lazy var nameBorderView = UIView()
    private lazy var nameImgView = UIImageView()

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

    private lazy var checkImgView = UIImageView()
    private lazy var privacyLbl = UILabel()
    private lazy var signUpButton = UIButton()
    private lazy var signInContainer = UIView()
    private lazy var questionLbl = UILabel()
    private lazy var signInLbl = UILabel()
    private lazy var signInButton = UIButton()

    init(viewModel: SignUpViewModel) {
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
        signUpButton.layer.cornerRadius = 30.0
    }

    private func setUpViews() {
        view.subviews {
            containerView
        }

        containerView.subviews {
            backButton
            titleLbl
            nameContainer
            emailContainer
            passwordContainer
            checkImgView
            privacyLbl
            signUpButton
            signInContainer
        }

        signInContainer.subviews {
            signInLbl
            signInButton
            questionLbl
        }

        nameContainer.subviews {
            nameLbl
            nameImgView
            nameTextField
            nameBorderView
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
    }

    private func layoutViews() {
        containerView.centerInContainer()
        containerView.Height == view.Height
        containerView.Width == view.Width

        backButton.Left == containerView.Left + 19.0
        backButton.Height == backButton.Width
        backButton.Height == 24.0
        backButton.Top == containerView.Top + 64.0

        titleLbl.Left == containerView.Left + 24.0
        titleLbl.Top == backButton.Bottom + 48.0

        nameContainer.Top == titleLbl.Bottom + 60.0
        nameContainer.centerHorizontally()
        nameContainer.Left == containerView.Left + 24.0
        nameContainer.Height == 56.0

        emailContainer.Top == nameContainer.Bottom + 40.0
        emailContainer.centerHorizontally()
        emailContainer.Left == containerView.Left + 24.0
        emailContainer.Height == 56.0

        passwordContainer.Top == emailContainer.Bottom + 40.0
        passwordContainer.centerHorizontally()
        passwordContainer.Left == containerView.Left + 24.0
        passwordContainer.Height == 56.0

        nameLbl.Top == nameContainer.Top
        nameLbl.Left == nameContainer.Left

        nameBorderView.Height == 1
        nameBorderView.Left == nameContainer.Left
        nameBorderView.Bottom == nameContainer.Bottom
        nameBorderView.Right == nameContainer.Right

        nameTextField.Top == nameLbl.Bottom + 7.0
        nameTextField.Bottom == nameBorderView.Top - 7.0
        nameTextField.Left == nameContainer.Left
        nameTextField.Right == nameImgView.Left - 10.0

        nameImgView.Height == nameImgView.Width
        nameImgView.Height == 16.0
        nameImgView.CenterY == nameTextField.CenterY
        nameImgView.Right == nameContainer.Right

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

        checkImgView.Left == containerView.Left + 24.0
        checkImgView.Top == passwordContainer.Bottom + 30.0
        checkImgView.Height == checkImgView.Width
        checkImgView.Height == 22.0

        privacyLbl.Left == checkImgView.Right + 11.0
        privacyLbl.CenterY == checkImgView.CenterY

        signUpButton.centerHorizontally()
        signUpButton.Left == containerView.Left + 24.0
        signUpButton.Top == checkImgView.Bottom + 44.0
        signUpButton.Width == signUpButton.Height * (326.0/52.0)

        signInContainer.centerHorizontally()
        signInContainer.Bottom == containerView.Bottom - 38.0
        signInContainer.Height == 17.0

        questionLbl.Left == signInContainer.Left
        questionLbl.Bottom == signInContainer.Bottom
        questionLbl.Right == signInLbl.Left

        signInLbl.Top == signInContainer.Top
        signInLbl.Right == signInContainer.Right
        signInLbl.Bottom == signInContainer.Bottom

        signInButton.Top == signInLbl.Top
        signInButton.Bottom == signInLbl.Bottom
        signInButton.Left == signInLbl.Left
        signInButton.Right == signInLbl.Right
    }

    private func styleViews() {
        backButton.style {
            $0.setBackgroundImage(R.image.ic_back(), for: .normal)
        }

        titleLbl.style {
            $0.text = "Đăng ký"
            $0.font = .systemFont(ofSize: 32.0, weight: .bold)
            $0.textColor = R.color.violet_blue()
            $0.textAlignment = .left
        }

        nameLbl.style {
            $0.text = "HỌ VÀ TÊN"
            $0.textColor = R.color.spalish_gray()
            $0.font = .systemFont(ofSize: 14.0, weight: .medium)
            $0.textAlignment = .left
        }

        nameImgView.style {
            $0.image = R.image.ic_user()
        }

        nameBorderView.style {
            $0.backgroundColor = R.color.light_gray()
        }

        nameTextField.style {
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 18.0, weight: .medium)
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

        checkImgView.style {
            $0.image = R.image.ic_check()
        }

        privacyLbl.style {
            $0.attributedText = self.privacyText()
        }

        signUpButton.style {
            $0.setTitle("ĐĂNG KÝ", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = R.color.chinese_silver()
            $0.isUserInteractionEnabled = false
        }

        questionLbl.style {
            $0.text = "Đã có tài khoản?"
            $0.textColor = R.color.spalish_gray()
            $0.font = .systemFont(ofSize: 14.0, weight: .medium)
            $0.textAlignment = .left
        }

        signInLbl.style {
            $0.text = " Đăng nhập ngay"
            $0.textColor = R.color.violet_blue()
            $0.font = .systemFont(ofSize: 14.0, weight: .semibold)
            $0.textAlignment = .left
        }
    }

    // MARK: - Helper
    func privacyText() -> NSMutableAttributedString {
        let privacyText = "Tôi đồng ý với các chính sách và điều khoản"
        let privacyAtributedText = NSMutableAttributedString(string: privacyText)
        privacyAtributedText.addAttribute(.foregroundColor, 
                                          value: R.color.spalish_gray() as Any,
                                          range: NSRange(location: 0, length: 19))
        privacyAtributedText.addAttribute(.font, 
                                          value: UIFont.systemFont(ofSize: 14.0, weight: .medium), 
                                          range: NSRange(location: 0, length: 19))
        privacyAtributedText.addAttribute(.foregroundColor, 
                                          value: R.color.violet_blue() as Any,
                                          range: NSRange(location: 19, length: 10))
        privacyAtributedText.addAttribute(.font,
                                          value: UIFont.systemFont(ofSize: 14.0, weight: .semibold),
                                          range: NSRange(location: 19, length: 10))
        privacyAtributedText.addAttribute(.foregroundColor,
                                          value: R.color.spalish_gray() as Any,
                                          range: NSRange(location: 29, length: 4))
        privacyAtributedText.addAttribute(.font,
                                          value: UIFont.systemFont(ofSize: 14.0, weight: .medium),
                                          range: NSRange(location: 29, length: 4))
        privacyAtributedText.addAttribute(.foregroundColor,
                                          value: R.color.violet_blue() as Any,
                                          range: NSRange(location: 33, length: 10))
        privacyAtributedText.addAttribute(.font,
                                          value: UIFont.systemFont(ofSize: 14.0, weight: .semibold),
                                          range: NSRange(location: 33, length: 10))
        return privacyAtributedText
    }
}

extension SignUpViewController {
    private func bindViewModel() {
        let didTapBack = Observable.merge(backButton.rx.tap.asObservable(),
                                          signInButton.rx.tap.asObservable())
        didTapBack
            .asDriver(onErrorDriveWith: .empty())
            .drive( onNext: {[weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        let didChangeInfor = Observable.combineLatest(
            nameTextField.rx.text.asObservable(),
            emailTextField.rx.text.asObservable(),
            passwordTextField.rx.text.asObservable())

        // MARK: - use withLatestForm
        let didTapSignUp = signUpButton.rx.tap
            .asObservable()
            .map { [weak self] in
                (self?.nameTextField.text,
                 self?.emailTextField.text,
                 self?.passwordTextField.text)
        }

        let output = viewModel.transform(.init(didChangeInfor: didChangeInfor,
                                               didTapSignUp: didTapSignUp))

        output.changeInforStatus
            .subscribe(on: MainScheduler.asyncInstance)
            .map { signState in
                signState == .success ? R.color.violet_blue() : R.color.chinese_silver()
            }
            .bind(to: signUpButton.rx.backgroundColor)
            .disposed(by: self.disposeBag)

        output.changeInforStatus
            .subscribe(on: MainScheduler.asyncInstance)
            .map {
                $0 == .success
            }
            .bind(to: signUpButton.rx.isUserInteractionEnabled)
            .disposed(by: self.disposeBag)

        output.presentAlert
            .subscribe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] alertVC in
                self?.present(alertVC, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}
