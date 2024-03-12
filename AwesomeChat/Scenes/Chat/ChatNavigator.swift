//
//  ChatNavigator.swift
//  AwesomeChat
//
//  Created by đào sơn on 07/03/2024.
//

import Foundation
import RxSwift
import RxCocoa
import Photos

protocol ChatNavigatorType {
    func showImagePicker(isShowingImagePicker: Observable<Bool>, selectedPHassets: BehaviorRelay<[PHAsset]>) -> ImagePickerViewController
}

struct ChatNavigator: ChatNavigatorType {
    func showImagePicker(isShowingImagePicker: Observable<Bool>, selectedPHassets: BehaviorRelay<[PHAsset]>) -> ImagePickerViewController {
        let imagePickerNavigator = ImagePickerNavigator()
        let imagePickerViewModel = ImagePickerViewModel(navigator: imagePickerNavigator, 
                                                        selectedPHassets: selectedPHassets)
        return ImagePickerViewController(viewModel: imagePickerViewModel, 
                                         isShowingImagePicker: isShowingImagePicker)
    }
}
