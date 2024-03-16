//
//  FriendViewController.swift
//  AwesomeChat
//
//  Created by đào sơn on 16/03/2024.
//

import UIKit

class FriendViewController: UIViewController {
    private var viewModel: FriendViewModel

    init(viewModel: FriendViewModel) {
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

    private func setUpViews() {
    }

    private func layoutViews() {
    }

    private func styleViews() {
        view.style {
            $0.backgroundColor = .blue
        }
    }

    private func bindViewModel() {
    }
}
