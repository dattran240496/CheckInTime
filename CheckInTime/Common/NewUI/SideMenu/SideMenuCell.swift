//
//  SideMenuCell.swift
//  CheckInTime
//
//  Created by Dat Tran on 1/23/18.
//  Copyright © 2018 Dat Tran. All rights reserved.
//

import UIKit

class SideMenuCell: UICollectionViewCell {

    @IBOutlet weak var imgOption: UIImageView!
    @IBOutlet weak var lblOption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setSideMenuCell(imgName: String, lblOption: String) {
        self.imgOption.image        = UIImage(named: imgName)
        self.lblOption.text         = lblOption
    }
    

}
