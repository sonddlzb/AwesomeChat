//
//  ReceiverChatCell.swift
//  AwesomeChat
//
//  Created by đào sơn on 07/03/2024.
//

import UIKit
import Stevia

class ReceiverChatCell: ChatCell {
    private lazy var avtImgView = UIImageView()

    override func setUpViews() {
        super.setUpViews()
        containerView.subviews {
            avtImgView
        }
    }

    override func layoutViews() {
        super.layoutViews()

        avtImgView.Top == containerView.Top + 12.0
        avtImgView.Leading == containerView.Leading + 12.0
        avtImgView.Height == avtImgView.Width
        avtImgView.Height == 35.0

        containerMessage.Top == avtImgView.Top
        containerMessage.Leading == avtImgView.Trailing + 9.0
        containerMessage.Width <= containerView.Width * (285.0/375.0)

        timeLbl.Left == containerMessage.Left
        timeLbl.Top == containerMessage.Bottom + 3.0
        timeLbl.Height == 15.0
        timeLbl.Bottom == containerView.Bottom - 12.0

        messageLbl.Top == containerMessage.Top + 15.0
        messageLbl.Bottom == containerMessage.Bottom - 15.0
        messageLbl.Left == containerMessage.Left + 15.0
        messageLbl.Right == containerMessage.Right - 15.0
    }

    override func styleViews() {
        super.styleViews()

        containerMessage.style {
            $0.backgroundColor = R.color.gray_F5F5F5()
        }

        messageLbl.style {
            $0.textColor = .black
            $0.textAlignment = .left
            $0.font = .systemFont(ofSize: 16.0, weight: .medium)
            $0.numberOfLines = 0
        }

        timeLbl.style {
            $0.textColor = R.color.spalish_gray()
            $0.textAlignment = .left
            $0.font = .systemFont(ofSize: 12.0, weight: .regular)
        }
    }

    func bind(message: Message, chatItem: ChatItem) {
        timeLbl.text = chatItem.time
        messageLbl.text = chatItem.content
        avtImgView.image = message.image()
    }
}
