//
//  UICollectionViewCompositionalLayout+.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 21/08/2022.
//

import UIKit

extension UICollectionViewCompositionalLayout {
    static func grid(columns: Int, interItemSpacing: CGFloat) -> UICollectionViewCompositionalLayout {
        let sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { _, environment in
            
            let containerWidth = environment.container.effectiveContentSize.width

            let totalPadding = CGFloat(columns - 1) * interItemSpacing
            let itemWidth: CGFloat = (containerWidth - totalPadding)/CGFloat(columns)

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemWidth),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: itemSize.widthDimension
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: columns
            )
            group.interItemSpacing = .fixed(interItemSpacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = interItemSpacing
            
            return section
        }
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)

        return layout
    }
}
