//
//  PHAssetExtensions.swift
//  AwesomeChat
//
//  Created by đào sơn on 13/03/2024.
//

import UIKit
import Photos
import RxSwift

// swiftlint: disable all
extension PHAsset {
    func fetchImage() -> Observable<UIImage?> {
        return Observable<UIImage?>.create { observer in
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true

            if #available(iOS 13, *) {
                PHCachingImageManager().requestImageDataAndOrientation(for: self, options: options) { (imageData, _, _, _) in
                    if let data = imageData {
                        let image = UIImage(data: data)
                        observer.onNext(image)
                    } else {
                        observer.onNext(nil)
                    }

                    observer.onCompleted()
                }
            } else {
                PHCachingImageManager().requestImageData(for: self, options: options) { (imageData, _, _, _) in
                    if let data = imageData {
                        let image = UIImage(data: data)
                        observer.onNext(image)
                    } else {
                        observer.onNext(nil)
                    }

                    observer.onCompleted()
                }
            }

            return Disposables.create()
        }
    }
}
