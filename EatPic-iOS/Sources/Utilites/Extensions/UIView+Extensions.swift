//
//  UIView+Extensions.swift
//  EatPic-iOS
//
//  Created by jaewon Lee on 8/18/25.
//

import UIKit

extension UIImage {
    var hasAlpha: Bool {
        guard let alpha = cgImage?.alphaInfo else { return false }
        switch alpha {
        case .first, .last, .premultipliedFirst, .premultipliedLast: return true
        default: return false
        }
    }

    /// 알파를 버려도 될 때 배경에 합성
    func flattened(background: UIColor) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = true
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { ctx in
            background.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
