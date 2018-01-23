//
//  NSMutableData.swift
//  CheckInTime
//
//  Created by Dat Tran on 1/15/18.
//  Copyright © 2018 Dat Tran. All rights reserved.
//

import Foundation
import UIKit
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
