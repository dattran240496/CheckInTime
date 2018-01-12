//
//  File.swift
//  CheckInTime
//
//  Created by Dat Tran on 12/26/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import Foundation
import UIKit
extension UIImage{
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
