//
//  PhotoViewImageContentMode.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 22/08/2022.
//

import Foundation

enum PhotoViewImageContentMode {
    case scaleAspectFit
    case scaleAspectFill
}

extension PhotoViewImageContentMode {
    mutating func toggle() {
        switch self {
        case .scaleAspectFit:
            self = .scaleAspectFill
        case .scaleAspectFill:
            self = .scaleAspectFit
        }
    }
}
