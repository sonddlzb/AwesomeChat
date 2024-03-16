//
//  ChatViewModel.swift
//  AwesomeChat
//
//  Created by đào sơn on 07/03/2024.
//

import Foundation
import RxSwift
import RxCocoa
import Photos

class ChatViewModel {
    var navigator: ChatNavigatorType
    var repository: ChatRepositoryType
    var message: Message
    var disposeBag = DisposeBag()

    init(navigator: ChatNavigatorType, message: Message, repository: ChatRepositoryType) {
        self.navigator = navigator
        self.message = message
        self.repository = repository
    }

    func getHeightForRow(at index: Int) -> CGFloat {
        let listChatItems = repository.getData()
        if listChatItems[index].asset != nil {
            return 160.0
        } else {
            let cellWidth = UIScreen.main.bounds.width * 285.0 / 375.0 - 30.0
            let content = listChatItems[index].content
            let font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
            let attributes: [NSAttributedString.Key: Any] = [.font: font]
            let size = (content.trimmingCharacters(in: .whitespacesAndNewlines) as NSString)
                .size(withAttributes: attributes)
            let numberOfLines = Int(ceil(size.width / cellWidth))
            let cellHeight = Double(numberOfLines) * 24.0 + 70.0
            return CGFloat(cellHeight)
        }
    }
}

extension ChatViewModel: ViewModelType {
    struct Input {
        let viewWillAppear: Observable<Void>
        let didTapChatMessage: Observable<(String, [PHAsset])>
        let didTapChatImage: Observable<[PHAsset]>
        let didTapAddMedia: Observable<Bool>
        let selectedPHassets: BehaviorRelay<[PHAsset]>
    }

    struct Output {
        let bindMessageData: Observable<Message>
        let bindTableData: Observable<[ChatItem]>
        let didSentMessage: Observable<[ChatItem]>
        let showImagePicker: Observable<ImagePickerViewController?>
        let message: Message
    }

    func transform(_ input: Input) -> Output {
        let message = message
        let listChatItems = repository.getData()
        let navigator = navigator

        let bindMessageData = input.viewWillAppear
            .map {
                return message
            }

        let bindTableData = input.viewWillAppear
            .map {
                return listChatItems
            }

        let didSentMessage: Observable<[ChatItem]> = input.didTapChatMessage
            .map { [weak self] message, selectedAssets in
                guard let self = self else {
                    return []
                }

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"

                if !message.isEmpty {
                    let newItem = ChatItem(content: message,
                                           isSender: true,
                                           time: dateFormatter.string(from: Date()))
                    self.repository.addNewItem(newItem)
                }

                selectedAssets.forEach { asset in
                    let newItem = ChatItem(content: "",
                                           isSender: true,
                                           time: dateFormatter.string(from: Date()),
                                           asset: asset)
                    self.repository.addNewItem(newItem)
                }

                return self.repository.getData()
            }

        let showImagePicker: Observable<ImagePickerViewController?> = input.didTapAddMedia
            .map { isShowingImagePicker in
                if !isShowingImagePicker {
                    let imagePickerVC = navigator.showImagePicker(
                        isShowingImagePicker: input.didTapAddMedia,
                        selectedPHassets: input.selectedPHassets)
                    return imagePickerVC
                } else {
                    return nil
                }
            }

        return .init(bindMessageData: bindMessageData,
                     bindTableData: bindTableData,
                     didSentMessage: didSentMessage,
                     showImagePicker: showImagePicker,
                     message: message)
    }
}
