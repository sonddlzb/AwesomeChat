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

struct ChatItem {
    var content: String
    var isSender: Bool
    var time: String
    var asset: PHAsset?
}

class ChatViewModel {
    var navigator: ChatNavigatorType
    var message: Message
    var listChatItems: [ChatItem] = []
    var disposeBag = DisposeBag()

    init(navigator: ChatNavigatorType, message: Message) {
        self.navigator = navigator
        self.message = message
        self.createFakeData()
    }

    func createFakeData() {
        self.listChatItems = [
            ChatItem(content: "Làm xong bài tập thầy Hoàng giao chưa??",
                     isSender: false, 
                     time: "10:03"),
            ChatItem(content: "Ko biết làm. Tí tôi qua nhà bà chép",
                     isSender: true,
                     time: ""),
            ChatItem(content: "Đc ko nè :(",
                     isSender: true,
                     time: "10:05"),
            ChatItem(content: "Mang trà sữa đến thì cho chép nha",
                     isSender: false,
                     time: "10:06"),
            ChatItem(content: "OK luôn",
                     isSender: true,
                     time: "10:07"),
            ChatItem(content: "Đến chưa vậy?",
                     isSender: false,
                     time: "11:52")
        ]
    }

    func getHeightForRow(at index: Int) -> CGFloat {
        if self.listChatItems[index].asset != nil {
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
        let message = self.message
        let listChatItems = self.listChatItems
        let navigator = self.navigator

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
                    self.listChatItems.append(newItem)
                }

                selectedAssets.forEach { asset in
                    let newItem = ChatItem(content: "",
                                           isSender: true,
                                           time: dateFormatter.string(from: Date()),
                                           asset: asset)
                    self.listChatItems.append(newItem)
                }

                return self.listChatItems
            }

        let showImagePicker: Observable<ImagePickerViewController?> = input.didTapAddMedia
            .map { isShowingImagePicker in
                if !isShowingImagePicker {
                    let imagePickerVC = navigator.showImagePicker(isShowingImagePicker: input.didTapAddMedia,
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
