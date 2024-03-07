//
//  SenderChatCell.swift
//  AwesomeChat
//
//  Created by đào sơn on 07/03/2024.
//

import UIKit
import Stevia

class SenderChatCell: ChatCell {
    override func layoutViews() {
        super.layoutViews()

        containerMessage.Top == containerView.Top + 12.0
        containerMessage.Trailing == containerView.Trailing - 12.0
        containerMessage.Width <= containerView.Width * (285.0/375.0)

        timeLbl.Right == containerMessage.Right
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
            $0.backgroundColor = R.color.violet_blue()
        }

        messageLbl.style {
            $0.textColor = .white
            $0.textAlignment = .right
            $0.font = .systemFont(ofSize: 16.0, weight: .medium)
            $0.numberOfLines = 0
        }

        timeLbl.style {
            $0.textColor = R.color.spalish_gray()
            $0.textAlignment = .right
            $0.font = .systemFont(ofSize: 12.0, weight: .regular)
        }
    }

    func bind(chatItem: ChatItem) {
        self.messageLbl.text = chatItem.content
        self.timeLbl.text = chatItem.time
    }
}
