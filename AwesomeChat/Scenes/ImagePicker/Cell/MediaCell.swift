//
//  MediaCell.swift
//  AwesomeChat
//
//  Created by đào sơn on 13/03/2024.
//

import UIKit
import Stevia
import RxSwift
import RxCocoa
import Photos

class MediaCell: UICollectionViewCell {
    
    private var disposeBag = DisposeBag()

    private lazy var containerView = UIView()
    private lazy var loadingIndicator = UIActivityIndicatorView()
    private lazy var imgView = UIImageView()
    private lazy var blurView = UIView()
    private lazy var selectImg = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setUpViews()
        layoutViews()
        styleViews()
        loadingIndicator.startAnimating()
    }

    private func setUpViews() {
        self.subviews {
            containerView
        }

        containerView.subviews {
            imgView
            blurView
            selectImg
            loadingIndicator
        }
    }

    private func layoutViews() {
        containerView.centerInContainer()
        containerView.Height == self.Height
        containerView.Width == self.Width

        imgView.centerInContainer()
        imgView.Height == containerView.Height
        imgView.Width == containerView.Width

        blurView.centerInContainer()
        blurView.Height == containerView.Height
        blurView.Width == containerView.Width

        selectImg.centerInContainer()
        selectImg.Height == containerView.Height * 0.2
        selectImg.Width == containerView.Width * 0.2

        loadingIndicator.centerInContainer()
        loadingIndicator.Height == containerView.Height
        loadingIndicator.Width == containerView.Width
    }

    private func styleViews() {
        blurView.style {
            $0.backgroundColor = .black.withAlphaComponent(0.4)
            $0.isHidden = true
        }

        selectImg.style {
            $0.image = R.image.ic_selected()
            $0.isHidden = true
        }

        loadingIndicator.style {
            $0.backgroundColor = .black.withAlphaComponent(0.5)
            $0.color = .white
        }
    }

    func bind(itemViewModel: MediaItemViewModel) {
        let asset = itemViewModel.asset
        let isSelecting = itemViewModel.isSelecting
        asset.fetchImage()
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] image in
                self?.imgView.image = image
                self?.loadingIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)

        isSelecting
            .drive(onNext: {[weak self] isSelect in
                if isSelect {
                    self?.blurView.isHidden = false
                    self?.selectImg.isHidden = false
                } else {
                    self?.blurView.isHidden = true
                    self?.selectImg.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
}
