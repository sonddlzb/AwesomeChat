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
import RxDataSources

class HomeViewController: UIViewController {
    var viewModel: HomeViewModel
    var disposeBag = DisposeBag()

    private lazy var containerView = UIView()
    private lazy var headerView = UIView()
    private lazy var imgBgHeader = UIImageView()
    private lazy var imgNewConversation = UIImageView()
    private lazy var titleLbl = UILabel()
    private lazy var containerSearch = UIView()
    private lazy var imgSearch = UIImageView()
    private lazy var searchTextField = UITextField()
    private lazy var contentView = UIView()
    private lazy var containerBottom = UIView()
    private lazy var menuView = UIView()
    private lazy var stackView = UIStackView()
    private lazy var messageView = UIView()
    private lazy var friendView = UIView()
    private lazy var profileView = UIView()
    private lazy var imgMessage = UIImageView()
    private lazy var lblMessage = UILabel()
    private lazy var imgFriend = UIImageView()
    private lazy var lblFriend = UILabel()
    private lazy var imgProfile = UIImageView()
    private lazy var lblProfile = UILabel()
    private lazy var tableView = UITableView()

    init(viewModel: HomeViewModel) {
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

        tableView.registerCell(type: MessageCell.self)
        tableView.rx.rowHeight.onNext(92)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerSearch.layer.cornerRadius = 21.0
        contentView.layer.cornerRadius = 30.0

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
            headerView
            contentView
        }

        headerView.subviews {
            imgBgHeader
            titleLbl
            imgNewConversation
            containerSearch
        }

        containerSearch.subviews {
            imgSearch
            searchTextField
        }

        contentView.subviews {
            tableView
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
        }

        friendView.subviews {
            imgFriend
            lblFriend
        }

        profileView.subviews {
            imgProfile
            lblProfile
        }
    }

    private func layoutViews() {
        containerView.centerInContainer()
        containerView.Width == view.Width
        containerView.Height == view.Height

        headerView
            .top(view.topAnchor)
            .leading(view.leadingAnchor)
            .trailing(view.trailingAnchor)
        headerView.Width == headerView.Height * (375.0/228.0)

        imgBgHeader.centerInContainer()
        imgBgHeader.Width == headerView.Width
        imgBgHeader.Height == headerView.Height

        titleLbl
            .leading(headerView.leadingAnchor, constant: 12.0)
            .top(headerView.topAnchor, constant: 64.0)

        imgNewConversation
            .trailing(headerView.trailingAnchor, constant: -12.0)
        imgNewConversation.Height == imgNewConversation.Width
        imgNewConversation.Height == headerView.Height * (35.0/228.0)
        imgNewConversation.CenterY == titleLbl.CenterY

        containerSearch.Width == headerView.Width * (351.0/375.0)
        containerSearch.Width == containerSearch.Height * (351.0/42.0)
        containerSearch.centerHorizontally()
        containerSearch.Top == titleLbl.Bottom + 24.0

        imgSearch
            .leading(containerSearch.leadingAnchor, constant: 17.0)
        imgSearch.centerVertically()
        imgSearch.Height == imgSearch.Width
        imgSearch.Height == containerSearch.Height * (18.0/41.0)

        searchTextField.centerVertically()
        searchTextField.Left == imgSearch.Right + 14.0
        searchTextField.Height == containerSearch.Height * (19.0/41.0)
        searchTextField.Right == containerSearch.Right - 17.0

        contentView
            .top(containerSearch.bottomAnchor, constant: 22.0)
            .leading(view.leadingAnchor)
            .trailing(view.trailingAnchor)
            .bottom(view.bottomAnchor)

        containerBottom
            .bottom(view.bottomAnchor)
            .leading(view.leadingAnchor)
            .trailing(view.trailingAnchor)
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

        lblFriend.centerHorizontally()
        lblFriend.Bottom == friendView.Bottom - 8.0

        imgFriend.centerHorizontally()
        imgFriend.Width == imgFriend.Height
        imgFriend.Height == friendView.Height * (28.0/70.0)
        imgFriend.Bottom == lblFriend.Top - 10.0

        lblProfile.centerHorizontally()
        lblProfile.Bottom == profileView.Bottom - 8.0

        imgProfile.centerHorizontally()
        imgProfile.Width == imgProfile.Height
        imgProfile.Height == profileView.Height * (28.0/70.0)
        imgProfile.Bottom == lblProfile.Top - 10.0

        tableView.centerInContainer()
        tableView.Width == contentView.Width
        tableView.Height == contentView.Height
    }

    private func styleViews() {
        view.style {
            $0.backgroundColor = .white
        }

        imgBgHeader.style {
            $0.image = R.image.bg_header_home()
        }

        titleLbl.style {
            $0.text = "Tin nhắn"
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 30.0, weight: .bold)
            $0.textAlignment = .left
        }

        imgNewConversation.style {
            $0.image = R.image.ic_new_message()
        }

        containerSearch.style {
            $0.backgroundColor = .white
        }

        imgSearch.style {
            $0.image = R.image.ic_search()
        }

        searchTextField.style {
            $0.placeholder = "Tìm kiếm tin nhắn..."
            $0.borderStyle = .none
            $0.font = .systemFont(ofSize: 16.0, weight: .medium)
        }

        contentView.style {
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

        tableView.style {
            $0.separatorStyle = .none
            $0.backgroundColor = .clear
            $0.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 110.0, right: 0.0)
        }
    }

    private func bindViewModel() {
        let viewWillAppear = rx
            .methodInvoked(#selector(viewWillAppear(_:)))
            .map { _ in () }

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Message>>(
            configureCell: { _, tableView, indexPath, message in
            let cell = tableView.dequeueCell(type: MessageCell.self, indexPath: indexPath)
            cell.bind(message: message)
            return cell
        })

        let output = viewModel.transform(.init(viewWillAppear: viewWillAppear))
        output.bindTableData
            .map {
                [SectionModel(model: "Section", items: $0)]
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
