//
//  PhotosGridViewController.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 20/08/2022.
//

import UIKit

protocol PhotosGridImagesService {
    func image(for identifier: String, targetSize: CGSize) async throws -> (UIImage?)
    func loadPhotoIdentifiers() async throws -> [String]
}

class PhotosGridViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<String, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, String>
    
    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource = DataSource(collectionView: collectionView,
                                             cellRegistrationHandler: cellRegistrationHandler)

    private let service: PhotosGridImagesService
    
    var photoTapHandler: ((String) -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    private let imageCache = Cache<String, UIImage>()
    
    init(imageProvider: PhotosGridImagesService) {
        self.service = imageProvider
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
        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            do {
                let photoIdentifiers = try await self.service.loadPhotoIdentifiers()
                await self.updateGridUI(photoIdentifiers: photoIdentifiers)
            } catch(let error) {
                await self.errorHandler?(error)
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
        let image = imageCache[id]
        var background = cell.defaultBackgroundConfiguration()
        background.imageContentMode = .scaleAspectFill
        background.image = image
        cell.backgroundConfiguration = background
        
        Task.detached(priority: .userInitiated) { [weak self, weak cell] in
            guard let self, let cell, image == nil else { return }
            do {
                try await self.loadCellImage(for: id, cell: cell)
                await self.updateCell(id: id)
            } catch {
                await self.errorHandler?(error)
            }
        }
    }
    
    private nonisolated func loadCellImage(for photoId: String, cell: UICollectionViewCell) async throws {
        let targetSize = await ImageSizeScaler.imageSize(for: cell)
        guard let image = try await service.image(for: photoId, targetSize: targetSize) else { return }
        imageCache[photoId] = image
    }
    
    private func updateCell(id: String) {
        var updatedSnapshot = self.dataSource.snapshot()
        updatedSnapshot.reloadItems([id])
        self.dataSource.apply(updatedSnapshot, animatingDifferences: false)
    }
}
