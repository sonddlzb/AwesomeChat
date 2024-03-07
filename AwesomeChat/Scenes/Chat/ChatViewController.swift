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

class ChatViewController: UIViewController {
    var viewModel: ChatViewModel
    var disposeBag = DisposeBag()

    private lazy var containerView = UIView()
    private lazy var headerView = UIView()
    private lazy var contentView = UIView()
    private lazy var containerChat = UIView()
    private lazy var avtImgView = UIImageView()
    private lazy var backButton = UIButton()
    private lazy var backImgView = UIImageView()
    private lazy var nameLbl = UILabel()
    private lazy var timeLbl = UILabel()
    private lazy var bottomView = UIView()
    private lazy var containerTime = UIView()
    private lazy var tableView = UITableView()

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
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.containerChat.layer.cornerRadius = 30.0
        self.containerTime.layer.cornerRadius = 15.0
    }

    private func setUpViews() {
        view.subviews {
            containerView
        }

        containerView.subviews {
            headerView
            contentView
            bottomView
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
        }

        containerTime.subviews {
            timeLbl
        }

        containerChat.subviews {
            tableView
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
        tableView.Bottom == containerChat.Bottom
        tableView.Leading == containerChat.Leading
        tableView.Trailing == containerChat.Trailing
    }

    private func styleViews() {
        view.style {
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
        }
    }

    private func bindViewModel() {
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        let viewWillAppear = rx
            .methodInvoked(#selector(viewWillAppear(_:)))
            .map { _ in () }

        let output = viewModel.transform(.init(viewWillAppear: viewWillAppear))

        output.bindMessageData
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] message in
                self?.avtImgView.image = message.image()
                self?.nameLbl.text = message.name
            }
            .disposed(by: disposeBag)

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ChatItem>>(
            configureCell: { _, tableView, indexPath, chatItem in
                if chatItem.isSender {
                    let cell = tableView.dequeueCell(type: SenderChatCell.self, 
                                                     indexPath: indexPath)
                    cell.bind(chatItem: chatItem)
                    return cell
                } else {
                    let cell = tableView.dequeueCell(type: ReceiverChatCell.self, 
                                                     indexPath: indexPath)
                    cell.bind(message: self.viewModel.message, chatItem: chatItem)
                    return cell
                }
        })

        output.bindTableData
            .map {
                [SectionModel(model: "Section", items: $0)]
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        output.bindTableCellHeight
            .flatMap { Observable.from($0) }
            .bind(to: tableView.rx.rowHeight)
            .disposed(by: disposeBag)
    }
}
