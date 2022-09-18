//
//  UICollectionViewDiffableDataSource+.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 18/09/2022.
//

import UIKit

extension UICollectionViewDiffableDataSource {
    @MainActor public convenience init<Cell: UICollectionViewCell>(collectionView: UICollectionView, cellRegistrationHandler: @escaping UICollectionView.CellRegistration<Cell, ItemIdentifierType>.Handler) {
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)

        let cellProvider: CellProvider = { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
        
        self.init(collectionView: collectionView, cellProvider: cellProvider)
    }
}
