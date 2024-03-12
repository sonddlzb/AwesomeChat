//
//  ImagePickerViewController.swift
//  AwesomeChat
//
//  Created by đào sơn on 12/03/2024.
//

import UIKit
import RxSwift
import Stevia
import RxCocoa
import RxDataSources
import Photos

private struct Const {
    static let cellPadding = 4.0
    static let cellSpacing = 4.0
}

class ImagePickerViewController: UIViewController {

    var viewModel: ImagePickerViewModel
    var isShowingImagePicker: Observable<Bool>
    var disposeBag = DisposeBag()

    private lazy var containerView = UIView()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    init(viewModel: ImagePickerViewModel, isShowingImagePicker: Observable<Bool>) {
        self.viewModel = viewModel
        self.isShowingImagePicker = isShowingImagePicker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpViews()
        layoutViews()
        styleViews()
        bindViewModel()
    }

    private func setUpViews() {
        view.subviews {
            containerView
        }

        containerView.subviews {
            collectionView
        }
    }

    private func layoutViews() {
        containerView.centerInContainer()
        containerView.Height == view.Height
        containerView.Width == view.Width

        collectionView.centerInContainer()
        collectionView.Height == containerView.Height
        collectionView.Width == containerView.Width
    }

    private func styleViews() {
        collectionView.style {
            $0.contentInset = .zero
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.registerCell(type: MediaCell.self)
            $0.rx.setDelegate(self)
                .disposed(by: disposeBag)
        }
    }

    private func bindViewModel() {
        let viewWillAppear = rx
            .methodInvoked(#selector(viewWillAppear(_:)))
            .map { _ in () }

        let didSelectItem = collectionView.rx.itemSelected
            .map {
                $0.row
            }

        let output = self.viewModel.transform(.init(viewWillAppear: viewWillAppear, 
                                                    didSelectItem: didSelectItem,
                                                    isShowingImagePicker: isShowingImagePicker))

        let dataSource = RxCollectionViewSectionedReloadDataSource
        <SectionModel<String, MediaItemViewModel>>(configureCell: {
            _, collectionView, indexPath, item in
            let cell = collectionView.dequeueCell(type: MediaCell.self, indexPath: indexPath)
            cell.bind(itemViewModel: item)
            return cell
        })

        output.bindCollectionData
            .map {
                [SectionModel(model: "Section", items: $0)]
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImagePickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (collectionView.frame.width - 2 * Const.cellPadding)/3
        return CGSize(width: cellSize, height: cellSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Const.cellPadding
    }
}
