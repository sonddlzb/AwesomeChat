//
//  ImagePickerViewModel.swift
//  AwesomeChat
//
//  Created by đào sơn on 12/03/2024.
//

import Foundation
import Photos
import RxSwift
import RxCocoa

class ImagePickerViewModel {
    var navigator: ImagePickerNavigatorType
    var selectedPHassets: BehaviorRelay<[PHAsset]>
    var listMediaItems: [MediaItemViewModel] = []
    var disposeBag = DisposeBag()

    init(navigator: ImagePickerNavigatorType, selectedPHassets: BehaviorRelay<[PHAsset]>) {
        self.navigator = navigator
        self.selectedPHassets = selectedPHassets
    }
}

extension ImagePickerViewModel: ViewModelType {
    struct Input {
        var selectedIDs = BehaviorRelay<[String]>(value: [])
        let viewWillAppear: Observable<Void>
        let didSelectItem: Observable<Int>
        let isShowingImagePicker: Observable<Bool>
    }

    struct Output {
        let bindCollectionData: Observable<[MediaItemViewModel]>
    }

    func transform(_ input: Input) -> Output {
        let listMediaItems = self.listMediaItems

        input.selectedIDs
            .map { [weak self] listSelectedIds -> [PHAsset] in
                guard let self = self else {
                    return []
                }

                var listSelectedAssets: [PHAsset] = []
                for id in listSelectedIds {
                    self.listMediaItems.forEach {
                        if $0.asset.localIdentifier == id {
                            listSelectedAssets.append($0.asset)
                        }
                    }
                }

                return listSelectedAssets
            }.bind(to: selectedPHassets)
            .disposed(by: disposeBag)

        let bindCollectionData = input.viewWillAppear
            .filter {
                listMediaItems.isEmpty
            }
            .flatMapLatest { () -> Observable<[MediaItemViewModel]> in
                return Observable.create { observer in
                    PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                        guard let self = self else {
                            return
                        }
                        if status == .authorized || status == .limited {
                            self.listMediaItems.removeAll()
                            PHAsset.fetchAssets(with: nil).enumerateObjects { (object, _, _) in
                                let isSelecting = input.selectedIDs
                                    .asDriver()
                                    .map { selectedIDs -> Bool in
                                    return selectedIDs.contains(object.localIdentifier)
                                }

                                self.listMediaItems
                                    .append(MediaItemViewModel(asset: object,
                                                               isSelecting: isSelecting))
                            }

                            observer.onNext(self.listMediaItems)
                        }
                    }
                    return Disposables.create()
                }
            }

        input.didSelectItem
            .subscribe(onNext: { [weak self] index in
                guard let self = self else {
                    return
                }

                let id = self.listMediaItems[index].asset.localIdentifier
                let currentSelectedIDs = input.selectedIDs.value
                var newSelectedIDs = currentSelectedIDs
                if let indexToRemove = currentSelectedIDs.firstIndex(of: id) {
                    newSelectedIDs.remove(at: indexToRemove)
                } else {
                    newSelectedIDs.append(id)
                }

                input.selectedIDs.accept(newSelectedIDs)
            })
            .disposed(by: disposeBag)

        input.isShowingImagePicker
            .subscribe(onNext: { isShowingImagePicker in
                if !isShowingImagePicker {
                    input.selectedIDs.accept([])
                }
            })
            .disposed(by: disposeBag)

        return .init(bindCollectionData: bindCollectionData)
    }
}
