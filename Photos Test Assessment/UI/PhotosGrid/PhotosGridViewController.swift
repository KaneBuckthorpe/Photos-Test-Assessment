//
//  PhotosGridViewController.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 20/08/2022.
//

import UIKit

protocol PhotosGridImagesProvider {
    func imageForItem(_ identifier: String, targetSize: CGSize) async throws -> (UIImage?)
    func fetchPhotoIdentifiers() async throws -> [String]
}

class PhotosGridViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<String, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, String>
    
    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource = DataSource(collectionView: collectionView,
                                             cellRegistrationHandler: cellRegistrationHandler)

    private let imageProvider: PhotosGridImagesProvider
    
    var photoTapHandler: ((String) -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    init(imageProvider: PhotosGridImagesProvider) {
        self.imageProvider = imageProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addConstrainedSubview(collectionView)
        collectionView.delegate = self
        navigationItem.backButtonDisplayMode = .minimal
        loadData()
    }
    
    private func loadData() {
        Task {
            do {
                let photoIdentifiers = try await imageProvider.fetchPhotoIdentifiers()
                updateGridUI(photoIdentifiers: photoIdentifiers)
            } catch(let error) {
                errorHandler?(error)
            }
        }
    }

    private func updateGridUI(photoIdentifiers: [String]) {
        guard photoIdentifiers.count > 0 else { return }
        var snapshot = Snapshot()
        let section = "Images"
        snapshot.appendSections([section])
        snapshot.appendItems(photoIdentifiers, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension PhotosGridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let identifier = dataSource.itemIdentifier(for: indexPath) else { return }
        photoTapHandler?(identifier)
    }
}

extension PhotosGridViewController {
    private func makeCollectionView() -> UICollectionView {
        let layout: UICollectionViewCompositionalLayout = .grid(columns: 4, interItemSpacing: 8)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        return collectionView
    }
    
    private func cellRegistrationHandler(cell: UICollectionViewCell, indexPath: IndexPath, id: String) {
        let image = imageCache.object(forKey: NSString(string: id))
        var background = cell.defaultBackgroundConfiguration()
        background.imageContentMode = .scaleAspectFill
        background.image = image
        cell.backgroundConfiguration = background
        
        Task { [weak cell] in
            guard let cell, image == nil else { return }
            do {
                try await loadCellImage(for: id, cell: cell)
                updateCell(id: id)
            } catch {
                errorHandler?(error)
            }
        }
    }
    
    private func loadCellImage(for photoId: String, cell: UICollectionViewCell) async throws {
        let targetSize = ImageSizeScaler.imageSize(for: cell)
        if let image = try await imageProvider.imageForItem(photoId, targetSize: targetSize) {
            imageCache.setObject(image, forKey: NSString(string: photoId))
        }
    }
    
    private func updateCell(id: String) {
        var updatedSnapshot = self.dataSource.snapshot()
        updatedSnapshot.reloadItems([id])
        self.dataSource.apply(updatedSnapshot, animatingDifferences: false)
    }
}
