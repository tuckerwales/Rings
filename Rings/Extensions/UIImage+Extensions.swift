//
//  UIImage+Extensions.swift
//  Rings
//
//  Created by Joshua Tucker on 17/02/2018.
//  Copyright © 2018 Joshua Lee Tucker. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
  
  func rounded() -> UIImage {
    let layer = CALayer()
    layer.frame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
    layer.contents = self.cgImage!
    layer.masksToBounds = true
    layer.cornerRadius = self.size.height / 2
    layer.shouldRasterize = true
    UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return roundedImage!
  }
  
  func applyBorder(color: UIColor, width: Float) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
    let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
    self.draw(in: rect, blendMode: .normal, alpha: 1.0)
    let strokeRect = rect.insetBy(dx: CGFloat(width) / 2, dy: CGFloat(width) / 2)
    let context = UIGraphicsGetCurrentContext()
    context!.setLineWidth(CGFloat(width))
    context!.setStrokeColor(color.cgColor)
    context!.strokeEllipse(in: strokeRect)
    let outputImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return outputImage!
  }

}
