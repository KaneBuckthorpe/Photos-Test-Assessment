//
//  PhotoViewerViewController.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 21/08/2022.
//

import UIKit

protocol PhotoViewerImageProvider {
    var handler: ((UIImage?) -> Void)? { get set }
    func loadImage(size: CGSize)
}

protocol AttentionSaliencyImageService {
    func requestSalienceObjectBoundingRect(forImage image: CGImage, regionOfInterest: CGRect?, transfrom: CGAffineTransform) -> CGRect
}

class PhotoViewerViewController: UIViewController {
    
    private lazy var container = makeContainer()
    private lazy var imageView = makeImageView()
    
    private lazy var salientRegionView = UIView()
    private lazy var salientObjectBoxView = makeSalientObjectBoxView()
    
    private var imageContentMode: PhotoViewImageContentMode = .scaleAspectFit
    private var salientObjectRectTransform = CGAffineTransform.identity
    
    private var imageProvider: PhotoViewerImageProvider
    private var saliencyService: AttentionSaliencyImageService
    
    let uiHelper = PhotoViewerUIHelper.self
    
    init(imageProvider: PhotoViewerImageProvider, saliencyService: AttentionSaliencyImageService) {
        self.imageProvider = imageProvider
        self.saliencyService = saliencyService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUpBindings()
        loadImage()
    }
    
    override func viewDidLayoutSubviews() {
        updateLayout()
        super.viewDidLayoutSubviews()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        setupNavigationItem()
        view.addConstrainedSubview(container, by: .safeEdges())
        container.addSubview(imageView)
        imageView.addSubview(salientRegionView)
        salientRegionView.addSubview(salientObjectBoxView)
    }
    
    private func setupNavigationItem() {
        let action = UIAction { [unowned self] _ in
            imageContentMode.toggle()
            updateLayout()
        }
        let contentModeToggle = UIBarButtonItem(image: .scaleToggle(color: .white), primaryAction: action)
        navigationItem.setRightBarButton(contentModeToggle, animated: true)
        navigationItem.standardAppearance = .whitebackButton
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setUpBindings() {
        imageProvider.handler = { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
                self.updateLayout()
            }
        }
    }
    
    private func loadImage() {
        let targetSize = ImageSizeScaler.imageSize(for: view)
        imageProvider.loadImage(size: targetSize)
    }
    
    private func updateImageViewFrame() {
        let containerBounds = container.bounds
        
        switch imageContentMode {
        case .scaleAspectFit:
            imageView.frame = containerBounds
        case .scaleAspectFill:
            guard let image = imageView.image else { return }
            imageView.frame = uiHelper.aspectScaledToFillFrame(for: image, inVisbleRect: containerBounds)
        }
    }
    
    private func updateAttentionBasedSaliencyBox() {
        guard let image = imageView.image?.cgImage else { return }
        let regionOfInterest = imageContentMode == .scaleAspectFill ? salientRegionView.bounds : nil
        let rect = saliencyService.requestSalienceObjectBoundingRect(
            forImage: image,
            regionOfInterest: regionOfInterest,
            transfrom: self.salientObjectRectTransform
        )
        

        UIView.animate(withDuration: 0.1, delay: 0) {
            self.salientObjectBoxView.frame = rect
            self.salientObjectBoxView.alpha = 1
        } completion: { _ in
            self.salientObjectBoxView.isHidden = false
        }
    }
    
    private func updateLayout() {
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.updateImageViewFrame()
            self.updateSalientRegion()
            self.salientObjectBoxView.frame = self.salientRegionView.bounds
        } completion: { _ in
            self.updateAttentionBasedSaliencyBox()
        }
    }
}

extension PhotoViewerViewController {
    private func updateSalientRegion() {
        
        salientRegionView.frame = uiHelper.visibleImageRect(
            container: container,
            contentMode: imageContentMode,
            imageView: imageView
        )
        salientObjectRectTransform = uiHelper.transform(forSalientRegionView: salientRegionView)
    }
}

extension PhotoViewerViewController {
    private func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }
    
    private func makeContainer() -> UIView {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }
    
    private func makeSalientObjectBoxView() -> UIView {
        let view = UIView()
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 2
        return view
    }
}
