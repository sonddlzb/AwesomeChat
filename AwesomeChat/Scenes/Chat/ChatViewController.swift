//
//  ChatViewController.swift
//  AwesomeChat
//
//  Created by đào sơn on 07/03/2024.
//

import UIKit
import RxSwift
import RxCocoa
import Stevia
import RxDataSources
import Photos

class ChatViewController: UIViewController {
    var viewModel: ChatViewModel
    var disposeBag = DisposeBag()

    private lazy var containerView = UIView()
    private lazy var headerView = UIView()
    private lazy var bgHeaderView = UIView()
    private lazy var contentView = UIView()
    private lazy var containerChat = UIView()
    private lazy var avtImgView = UIImageView()
    private lazy var backButton = UIButton()
    private lazy var backImgView = UIImageView()
    private lazy var nameLbl = UILabel()
    private lazy var timeLbl = UILabel()
    private lazy var containerTime = UIView()
    private lazy var tableView = UITableView()
    private lazy var containerMessage = UIView()
    private lazy var addMediaImgView = UIImageView()
    private lazy var addMediaButton = UIButton()
    private lazy var containerEnterChat = UIView()
    private lazy var chatTextField = UITextField()
    private lazy var iconImgView = UIImageView()
    private lazy var containerAddMedia = UIView()
    private lazy var sendImgView = UIImageView()
    private lazy var sendButton = UIButton()
    private lazy var containerImagePicker = UIView()

    private var imagePickerVC: ImagePickerViewController?

    var isMovingUp = false
    var movingSpace = 316.0

    // MARK: - use BehaviorRelay
    var isShowingImagePicker = BehaviorRelay<Bool>(value: false)

    init(viewModel: ChatViewModel) {
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

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notification in
                self?.keyboardWillShow(notification: notification)
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] notification in
                self?.keyboardWillHide(notification: notification)
            })
            .disposed(by: disposeBag)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerChat.layer.cornerRadius = 30.0
        containerTime.layer.cornerRadius = 15.0
        containerAddMedia.layer.cornerRadius = 26.0
        containerEnterChat.layer.cornerRadius = 26.0
    }

    func keyboardWillShow(notification: Notification) {
        self.containerImagePicker.isHidden = true
        let keyboardKey = UIResponder.keyboardFrameEndUserInfoKey
        guard let userInfo = notification.userInfo,
              let keyboardFrameValue = userInfo[keyboardKey] as? NSValue else {
            return
        }

        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardHeight = keyboardFrame.size.height
        movingSpace = keyboardHeight - 24.0
        moveUp()
    }

    func keyboardWillHide(notification: Notification) {
        self.containerImagePicker.isHidden = false
        let keyboardKey = UIResponder.keyboardFrameEndUserInfoKey
        guard let userInfo = notification.userInfo,
                let keyboardFrameValue = userInfo[keyboardKey] as? NSValue else {
            return
        }

        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardHeight = keyboardFrame.size.height
        movingSpace = keyboardHeight - 24.0
        moveDown()
    }

    func moveUp() {
        guard !isMovingUp else {
            return
        }

        self.isMovingUp = true
        UIView.animate(withDuration: 0.2) {
            self.containerChat.bottomConstraint?.constant = -self.movingSpace
            self.tableView.contentOffset.y += self.movingSpace
            self.view.layoutIfNeeded()
        }
    }

    func moveDown() {
        guard isMovingUp else {
            return
        }

        self.isMovingUp = false
        UIView.animate(withDuration: 0.2) {
            self.containerChat.bottomConstraint?.constant = 0
            self.tableView.contentOffset.y -= self.movingSpace
            self.view.layoutIfNeeded()
        }
    }
}

extension ChatViewController {
    private func setUpViews() {
        view.subviews {
            containerView
        }

        containerView.subviews {
            bgHeaderView
            headerView
            contentView
        }

        headerView.subviews {
            backImgView
            backButton
            avtImgView
            nameLbl
        }

        contentView.subviews {
            containerChat
            containerTime
            containerImagePicker
        }

        containerTime.subviews {
            timeLbl
        }

        containerChat.subviews {
            tableView
            sendImgView
            sendButton
            containerMessage
        }

        containerMessage.subviews {
            containerAddMedia
            containerEnterChat
        }

        containerEnterChat.subviews {
            chatTextField
            iconImgView
        }

        containerAddMedia.subviews {
            addMediaImgView
            addMediaButton
        }
    }

    private func layoutViews() {
        containerView.Width == view.Width
        containerView.Height == view.Height
        containerView.centerInContainer()

        headerView.Top == containerView.Top + 55.0
        headerView.Leading == containerView.Leading + 10.0
        headerView.centerHorizontally()
        headerView.Height == 42.0

        bgHeaderView.Top == containerView.Top
        bgHeaderView.Left == containerView.Left
        bgHeaderView.Right == containerView.Right
        bgHeaderView.Height == 150.0

        backImgView.centerVertically()
        backImgView.Left == headerView.Left
        backImgView.Height == backImgView.Width
        backImgView.Height == headerView.Height * (24.0/42.0)

        backButton.Left == backImgView.Left
        backButton.Right == backImgView.Right
        backButton.Top == backImgView.Top
        backButton.Bottom == backImgView.Bottom

        avtImgView.Left == backImgView.Right + 14.0
        avtImgView.Height == avtImgView.Width
        avtImgView.Top == headerView.Top
        avtImgView.Bottom == headerView.Bottom

        nameLbl.Left == avtImgView.Right + 13.0
        nameLbl.CenterY == headerView.CenterY

        contentView.Top == headerView.Bottom + 12.0
        contentView.Left == containerView.Left
        contentView.Right == containerView.Right
        contentView.Bottom == containerView.Bottom

        timeLbl.Top == containerTime.Top + 6.0
        timeLbl.Left == containerTime.Left + 13.0
        timeLbl.Right == containerTime.Right - 13.0
        timeLbl.Bottom == containerTime.Bottom - 6.0

        containerTime.Top == contentView.Top
        containerTime.centerHorizontally()

        containerChat.Top == timeLbl.CenterY
        containerChat.Left == contentView.Left
        containerChat.Right == contentView.Right
        containerChat.Bottom == contentView.Bottom

        tableView.Top == containerChat.Top
        tableView.Bottom == containerMessage.Top
        tableView.Leading == containerChat.Leading
        tableView.Trailing == containerChat.Trailing

        containerMessage.Left == containerChat.Left + 12.0
        containerMessage.Right == containerChat.Right - 60.0
        containerMessage.Height == 52.0
        containerMessage.Bottom == containerChat.Bottom - 30.0

        containerAddMedia.Top == containerMessage.Top
        containerAddMedia.Left == containerMessage.Left
        containerAddMedia.Bottom == containerMessage.Bottom
        containerAddMedia.Height == containerAddMedia.Width

        addMediaImgView.centerInContainer()
        addMediaImgView.Width == addMediaImgView.Height
        addMediaImgView.Width == containerAddMedia.Width * (24.0/52.0)

        addMediaButton.Top == addMediaImgView.Top
        addMediaButton.Bottom == addMediaImgView.Bottom
        addMediaButton.Left == addMediaImgView.Left
        addMediaButton.Right == addMediaImgView.Right

        containerEnterChat.Left == containerAddMedia.Right + 10.0
        containerEnterChat.Top == containerMessage.Top
        containerEnterChat.Bottom == containerMessage.Bottom
        containerEnterChat.Right == containerMessage.Right

        chatTextField.Left == containerEnterChat.Left + 20.0
        chatTextField.centerVertically()

        iconImgView.centerVertically()
        iconImgView.Height == iconImgView.Width
        iconImgView.Height == 24.0
        iconImgView.Right == containerEnterChat.Right - 14.0

        sendImgView.CenterY == containerMessage.CenterY
        sendImgView.Height == sendImgView.Width
        sendImgView.Height == 24.0
        sendImgView.Right == containerChat.Right - 12.0

        sendButton.Top == sendImgView.Top
        sendButton.Bottom == sendImgView.Bottom
        sendButton.Left == sendImgView.Left
        sendButton.Right == sendImgView.Right

        containerImagePicker.Top == containerChat.Bottom
        containerImagePicker.Left == contentView.Left
        containerImagePicker.Right == contentView.Right
        containerImagePicker.Bottom == contentView.Bottom
    }

    private func styleViews() {
        view.style {
            $0.backgroundColor = .white
        }

        bgHeaderView.style {
            $0.backgroundColor = R.color.gray_E5E5E5()
        }

        backImgView.style {
            $0.image = R.image.ic_back()
        }

        nameLbl.style {
            $0.textColor = .black
            $0.textAlignment = .left
            $0.font = .systemFont(ofSize: 18.0, weight: .bold)
        }

        containerChat.style {
            $0.backgroundColor = .white
        }

        containerTime.style {
            $0.backgroundColor = R.color.cultured_F6F6F6()
        }

        timeLbl.style {
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 14.0, weight: .medium)
            $0.text = "Hôm nay"
        }

        tableView.style {
            $0.separatorStyle = .none
            $0.registerCell(type: SenderChatCell.self)
            $0.registerCell(type: ReceiverChatCell.self)
            $0.registerCell(type: ImageChatCell.self)
            $0.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
            $0.rx.setDelegate(self)
                .disposed(by: disposeBag)
        }

        containerAddMedia.style {
            $0.backgroundColor = R.color.cultured_F6F6F6()
        }

        addMediaImgView.style {
            $0.image = R.image.ic_image_gray()
        }

        containerEnterChat.style {
            $0.backgroundColor = R.color.cultured_F6F6F6()
        }

        chatTextField.style {
            $0.placeholder = "Nhập tin nhắn..."
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 16.0, weight: .regular)
            $0.textAlignment = .left

            $0.rx.controlEvent(.editingDidEndOnExit)
                .subscribe(onNext: { [weak self] in
                    self?.chatTextField.resignFirstResponder()
                })
                .disposed(by: disposeBag)
        }

        iconImgView.style {
            $0.image = R.image.ic_smile()
        }

        sendImgView.style {
            $0.image = R.image.ic_send()
        }

        containerImagePicker.style {
            $0.isHidden = true
        }
    }
}

extension ChatViewController {
    private func bindViewModel() {
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        isShowingImagePicker
            .subscribe(onNext: { [weak self] isShowingImagePicker in
                self?.containerImagePicker.isHidden = !isShowingImagePicker
                if isShowingImagePicker {
                    self?.moveUp()
                } else {
                    self?.moveDown()
                }
            })
            .disposed(by: disposeBag)

        let viewWillAppear = rx
            .methodInvoked(#selector(viewWillAppear(_:)))
            .map { _ in () }

        let selectedPHassets = BehaviorRelay<[PHAsset]>(value: [])
        let didTapChatMessage = sendButton.rx.tap
            .filter { [weak self] in
                !(self?.chatTextField.text?.isEmpty ?? true) || !selectedPHassets.value.isEmpty
            }
            .map { [weak self] in
                guard let self = self else { return ("", selectedPHassets.value) }
                DispatchQueue.main.async {
                    let lastSection = self.tableView.numberOfSections - 1
                    let lastRow = self.tableView.numberOfRows(inSection: lastSection) - 1
                    let indexPath = IndexPath(row: lastRow, section: lastSection)

                    if lastRow >= 0 {
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }

                let message = self.chatTextField.text ?? ""
                self.chatTextField.text = ""
                return (message, selectedPHassets.value)
        }

        let didTapChatImage = sendButton.rx.tap
            .withLatestFrom(selectedPHassets.asObservable())

        let isShowingImagePicker = self.isShowingImagePicker
        let didTapAddMedia: Observable<Bool> = addMediaButton.rx.tap
            .withLatestFrom(isShowingImagePicker)

        let output = viewModel.transform(.init(viewWillAppear: viewWillAppear,
                                               didTapChatMessage: didTapChatMessage,
                                               didTapChatImage: didTapChatImage, 
                                               didTapAddMedia: didTapAddMedia,
                                               selectedPHassets: selectedPHassets))

        output.bindMessageData
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] message in
                self?.avtImgView.image = message.image()
                self?.nameLbl.text = message.name
            }
            .disposed(by: disposeBag)

        output.showImagePicker
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] imagePickerVC in
                guard let self = self else {
                    return
                }

                self.isShowingImagePicker.accept(!self.isShowingImagePicker.value)

                if let imagePickerVC = imagePickerVC {
                    if self.imagePickerVC == nil {
                        self.chatTextField.resignFirstResponder()
                        self.imagePickerVC = imagePickerVC
                        self.addChild(imagePickerVC, to: self.containerImagePicker)
                    } else {
                        self.imagePickerVC?.view.isHidden = false
                    }
                } else {
                    self.imagePickerVC?.view.isHidden = true
                }
            })
            .disposed(by: disposeBag)

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ChatItem>>(
            configureCell: { _, tableView, indexPath, chatItem in
                if chatItem.isSender {
                    if chatItem.asset != nil {
                        let cell = tableView.dequeueCell(type: ImageChatCell.self,
                                                         indexPath: indexPath)
                        cell.bind(chatItem: chatItem)
                        return cell
                    } else {
                        let cell = tableView.dequeueCell(type: SenderChatCell.self,
                                                         indexPath: indexPath)
                        cell.bind(chatItem: chatItem)
                        return cell
                    }
                } else {
                    let cell = tableView.dequeueCell(type: ReceiverChatCell.self,
                                                     indexPath: indexPath)
                    cell.bind(message: output.message, chatItem: chatItem)
                    return cell
                }
        })

        Observable.merge(output.bindTableData, output.didSentMessage)
            .map {
                [SectionModel(model: "Section", items: $0)]
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.getHeightForRow(at: indexPath.row)
    }
}

extension ChatViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
