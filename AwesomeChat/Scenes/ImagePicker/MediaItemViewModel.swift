//
//  MediaItemViewModel.swift
//  AwesomeChat
//
//  Created by đào sơn on 13/03/2024.
//

import Photos
import RxSwift
import RxCocoa

struct MediaItemViewModel {
    var asset: PHAsset
    var isSelecting: Driver<Bool>
}
