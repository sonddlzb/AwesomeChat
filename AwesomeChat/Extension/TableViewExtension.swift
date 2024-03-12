//
//  TableViewExtension.swift
//  AwesomeChat
//
//  Created by đào sơn on 06/03/2024.
//

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(type: T.Type) {
        let name = String(describing: type)
        self.register(T.self, forCellReuseIdentifier: name)
    }

    func registerNibCell<T: UITableViewCell>(type: T.Type, bundle: Bundle = Bundle.main) {
        let name = String(describing: type)
        let nib = UINib(nibName: name, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: name)
    }

    func dequeueCell<T: UITableViewCell>(type: T.Type, indexPath: IndexPath) -> T {
        let name = String(describing: type)
        return self.dequeueReusableCell(withIdentifier: name, for: indexPath) as! T
    }
}

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(type: T.Type) {
        let name = String(describing: type)
        self.register(T.self, forCellWithReuseIdentifier: name)
    }

    func registerNibCell<T: UICollectionViewCell>(type: T.Type, bundle: Bundle = Bundle.main) {
        let name = String(describing: type)
        let nib = UINib(nibName: name, bundle: bundle)
        self.register(nib, forCellWithReuseIdentifier: name)
    }

    func dequeueCell<T: UICollectionViewCell>(type: T.Type, indexPath: IndexPath) -> T {
        let name = String(describing: type)
        return self.dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as! T
    }
}
