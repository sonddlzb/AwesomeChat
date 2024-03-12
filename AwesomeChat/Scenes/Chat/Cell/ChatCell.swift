//
//  ChatCell.swift
//  AwesomeChat
//
//  Created by đào sơn on 07/03/2024.
//

import UIKit
import Stevia

class ChatCell: UITableViewCell {
    lazy var containerView = UIView()
    lazy var containerMessage = UIView()
    lazy var messageLbl = UILabel()
    lazy var timeLbl = UILabel()

    override func layoutSubviews() {
        super.layoutSubviews()
        containerMessage.layer.cornerRadius = containerMessage.frame.height/2
    }

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

    func setUpViews() {
        self.subviews {
            containerView
        }

        containerView.subviews {
            containerMessage
            timeLbl
        }

        containerMessage.subviews {
            messageLbl
        }
    }

    func layoutViews() {
        containerView.centerInContainer()
        containerView.Width == self.Width
        containerView.Height == self.Height
    }

    func styleViews() {
        self.style {
            $0.backgroundColor = .clear
        }

        containerView.style {
            $0.backgroundColor = .clear
        }
    }
}
