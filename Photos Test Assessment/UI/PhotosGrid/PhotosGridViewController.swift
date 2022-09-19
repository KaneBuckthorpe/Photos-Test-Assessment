//
//  PhotosGridViewController.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 20/08/2022.
//

import UIKit

protocol PhotosGridImagesProvider {
    var numberOfImages: Int { get }
    func imageForItem(_ number: Int, targetSize: CGSize, completion: @escaping (UIImage?, Int) -> Void)
    func identifierForItem(index: Int) -> String
    func load() async throws
}

class PhotosGridViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<String, Int>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, Int>
    
    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource = DataSource(collectionView: collectionView,
                                             cellRegistrationHandler: cellRegistrationHandler)


    private let imageProvider: PhotosGridImagesProvider
    
    var photoTapHandler: ((String) -> Void)?
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
        let id = imageProvider.identifierForItem(index: imageNumber)
        photoTapHandler?(id)
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
    
    private func cellRegistrationHandler(cell: UICollectionViewCell, indexPath: IndexPath, id: Int) {
        let targetSize = ImageSizeScaler.imageSize(for: cell)

        self.imageProvider.imageForItem(id, targetSize: targetSize) { [weak cell] (image, number) in
            guard number == id, let cell else { return }
            DispatchQueue.main.async {
                var configuration = GridPhotoContentConfig()
                configuration.image = image
                cell.contentConfiguration = configuration
            }
        }
    }
}
