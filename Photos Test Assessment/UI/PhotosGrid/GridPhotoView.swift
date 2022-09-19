//
//  PhotosGridCell.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 21/08/2022.
//

import UIKit

struct GridPhotoContentConfig: UIContentConfiguration {

    var image: UIImage? = nil

    func makeContentView() -> UIView & UIContentView {
        GridPhotoView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> GridPhotoContentConfig {
        self
    }
}


class GridPhotoView: UIView, UIContentView {
    var configuration: UIContentConfiguration = GridPhotoContentConfig() {
        didSet { configure(configuration: configuration) }
    }
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    convenience init(configuration: GridPhotoContentConfig) {
        self.init()
    }
    
    init() {
        super.init(frame: .zero)
        addConstrainedSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? GridPhotoContentConfig else { return }
        self.imageView.image = configuration.image
    }
}
