//
//  Candidate.swift
//  CheckInTime
//
//  Created by Dat Tran on 1/16/18.
//  Copyright © 2018 Dat Tran. All rights reserved.
//

import Foundation
import UIKit
class Candicate {
    var name:String!
    var avatar:UIImage!
    init() {
        self.name = ""
        self.avatar = nil
    }
    init(name:String, avatar:UIImage) {
        self.name   = name
        self.avatar   = avatar
    }
}
