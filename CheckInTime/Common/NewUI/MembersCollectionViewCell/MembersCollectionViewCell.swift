//
//  MembersCollectionViewCell.swift
//  CheckInTime
//
//  Created by Dat Tran on 12/11/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit

class MembersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValueForCell(member: AnyObject) {
        self.lblName.text = member["name"] as? String
        let url = member["avatarUrl"] as? String!
        let imgURL = URL(string: apiURL + url!)
        let session = URLSession.shared
        session.dataTask(with: imgURL!) { (data, response, error) in
            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
            } else {
                //checking if the response contains an image
                if let imageData = data {
                    //getting the image
                    let image = UIImage(data: imageData)
                    //displaying the image
                    DispatchQueue.main.async(execute: {
                        self.imgAvatar.layer.masksToBounds = true
                        self.imgAvatar.layer.cornerRadius = 120
                        let state = member["state"] as? Int ?? 0
                        if state == 1{
                            self.imgAvatar.layer.borderColor = UIColor.green.cgColor
                        }else if state == 2{
                            self.imgAvatar.layer.borderColor = UIColor.red.cgColor
                        }else{
                            self.imgAvatar.layer.borderColor = UIColor.black.cgColor
                        }
                        self.imgAvatar.layer.borderWidth = 2
                        self.imgAvatar.image = image
                    })
                    
                } else {
                    print("Image file is currupted")
                }
            }
        }.resume()
    }
}
