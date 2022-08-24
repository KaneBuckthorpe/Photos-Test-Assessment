//
//  PhotosGridViewController.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 20/08/2022.
//

import UIKit

protocol PhotosGridImagesProvider {
    var numberOfImages: Int { get }
    func imageForItem(_ number: Int, targetSize: CGSize, completion:  @escaping (UIImage?, Int) -> Void)
    
    func load() async throws
}

class PhotosGridViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<String, Int>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, Int>
    
    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource = makeDataSource()

    private let imageProvider: PhotosGridImagesProvider
    
    var photoTapHandler: ((Int) -> Void)?
    var errorHandler: ((Error) -> Void)?
    
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
                try await imageProvider.load()
                await MainActor.run {
                    updateGridUI()
                }
            } catch(let error) {
                errorHandler?(error)
            }
        }
    }
    
    private func updateGridUI() {
        guard imageProvider.numberOfImages > 0 else { return }
        
        var snapshot = Snapshot()
        let section = "Images"
        snapshot.appendSections([section])
        let items = Array(0...imageProvider.numberOfImages-1)
        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension PhotosGridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageNumber = dataSource.itemIdentifier(for: indexPath) else { return }
        photoTapHandler?(imageNumber)
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
    
    private func makeDataSource() -> DataSource {
        let photosCellRegistration = PhotosGridCellRegistration<Int> { [weak self] cell, indexPath, itemIdentifier in
            guard let self = self else { return }
            
            cell.imageView.image = nil
    
            let targetSize = ImageSizeScaler.imageSize(for: cell)
            
            self.imageProvider.imageForItem(itemIdentifier, targetSize: targetSize) { [weak cell] (image, number) in
                guard number == itemIdentifier else { return }
                DispatchQueue.main.async {
                    cell?.imageView.image = image
                }
            }
        }
        
        let cellProvider: DataSource.CellProvider = { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: photosCellRegistration,
                for: indexPath,
                item: item
            )
        }
        
        return DataSource(collectionView: collectionView, cellProvider: cellProvider)
    }
}
