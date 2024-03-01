//
//  ViewModelType.swift
//  AwesomeChat
//
//  Created by đào sơn on 01/03/2024.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(_ input: Input) -> Output
}
