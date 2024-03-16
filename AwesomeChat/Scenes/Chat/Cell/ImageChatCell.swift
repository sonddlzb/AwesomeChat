//
//  ImageChatCell.swift
//  AwesomeChat
//
//  Created by đào sơn on 14/03/2024.
//

import UIKit
import Stevia
import RxSwift
import RxCocoa
import Photos

class ImageChatCell: UITableViewCell {
    private lazy var containerView = UIView()
    private lazy var containerImage = UIView()
    private lazy var imgView = UIImageView()
    private lazy var timeLbl = UILabel()

    private var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    func commonInit() {
        setUpViews()
        layoutViews()
        styleViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerImage.layer.cornerRadius = 12.0
        imgView.layer.cornerRadius = 12.0
    }

    func setUpViews() {
        self.subviews {
            containerView
        }

        containerView.subviews {
            containerImage
            timeLbl
        }

        containerImage.subviews {
            imgView
        }
    }

    func layoutViews() {
        containerView.centerInContainer()
        containerView.Width == self.Width
        containerView.Height == self.Height

        containerImage.Top == containerView.Top + 10.0
        containerImage.Right == containerView.Right - 12.0
        containerImage.Bottom == containerView.Bottom - 20.0

        imgView.Top == containerImage.Top
        imgView.Bottom == containerImage.Bottom
        imgView.Left == containerImage.Left
        imgView.Right == containerImage.Right

        timeLbl.Right == containerImage.Right
        timeLbl.Top == containerImage.Bottom + 3.0
        timeLbl.Height == 15.0
    }

    func styleViews() {
        self.style {
            $0.backgroundColor = .clear
        }

        containerView.style {
            $0.backgroundColor = .clear
        }

        containerImage.style {
            $0.backgroundColor = .clear
            $0.layer.cornerRadius = 12.0
        }

        timeLbl.style {
            $0.textColor = R.color.spalish_gray()
            $0.textAlignment = .left
            $0.font = .systemFont(ofSize: 12.0, weight: .regular)
        }

        imgView.style {
            $0.layer.cornerRadius = 12.0
        }
    }

    func bind(chatItem: ChatItem) {
        self.timeLbl.text = chatItem.time
        if let asset = chatItem.asset {
            asset.fetchImage()
                .asDriver(onErrorDriveWith: .empty())
                .drive(onNext: { [weak self] image in
                    self?.imgView.image = image
                    guard let self = self, let image = image else {
                        return
                    }
                    
                    let width = image.size.width
                    let height = image.size.height
                    self.containerImage.Width == containerView.Width * (width > height ? 0.5 : 0.25)
                    self.layoutIfNeeded()
                    self.containerImage.layer.cornerRadius = 12.0
                })
                .disposed(by: disposeBag)
        }
    }
}
