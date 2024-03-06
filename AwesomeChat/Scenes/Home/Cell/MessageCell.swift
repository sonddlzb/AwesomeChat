//
//  MessageCell.swift
//  AwesomeChat
//
//  Created by đào sơn on 05/03/2024.
//

import UIKit
import Stevia

class MessageCell: UITableViewCell {
    private lazy var containerView = UIView()
    private lazy var avtImg = UIImageView()
    private lazy var nameLbl = UILabel()
    private lazy var messageLbl = UILabel()
    private lazy var timeLbl = UILabel()
    private lazy var borderView = UIView()

    override func layoutSubviews() {
        super.layoutSubviews()
        avtImg.layer.cornerRadius = self.avtImg.frame.height/2
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    private func commonInit() {
        setUpViews()
        layoutViews()
        styleViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        self.subviews {
            containerView
        }

        containerView.subviews {
            avtImg
            nameLbl
            messageLbl
            timeLbl
            borderView
        }
    }

    private func layoutViews() {
        containerView.centerInContainer()
        containerView.Width == self.Width
        containerView.Height == self.Height

        avtImg.Left == containerView.Left + 12.0
        avtImg.centerVertically()
        avtImg.Width == avtImg.Height
        avtImg.Height == containerView.Height * (58.0/92.0)

        timeLbl.Top == avtImg.Top + 8.0
        timeLbl.Right == containerView.Right - 12.0

        nameLbl.Left == avtImg.Right + 19.0
        nameLbl.Top == avtImg.Top + 8.0
        nameLbl.Right == containerView.Right - 80.0

        messageLbl.Top == nameLbl.Bottom + 5.0
        messageLbl.Left == nameLbl.Left
        messageLbl.Right == containerView.Right - 30.0

        borderView.Left == nameLbl.Left
        borderView.Bottom == containerView.Bottom
        borderView.Right == containerView.Right - 12.0
        borderView.Height == 1
    }

    private func styleViews() {
        self.style {
            $0.backgroundColor = .clear
        }

        containerView.style {
            $0.backgroundColor = .clear
        }

        avtImg.style {
            $0.layer.cornerRadius = self.avtImg.frame.height/2
        }

        nameLbl.style {
            $0.font = .systemFont(ofSize: 16.0, weight: .bold)
            $0.textAlignment = .left
        }

        messageLbl.style {
            $0.font = .systemFont(ofSize: 14.0, weight: .semibold)
            $0.textAlignment = .left
        }

        timeLbl.style {
            $0.font = .systemFont(ofSize: 12.0, weight: .medium)
            $0.textAlignment = .left
        }

        borderView.style {
            $0.backgroundColor = R.color.light_gray()
        }
    }

    func bind(message: Message) {
        avtImg.image = message.image()
        nameLbl.text = message.name
        messageLbl.text = message.message
        timeLbl.text = message.time
    }
}
