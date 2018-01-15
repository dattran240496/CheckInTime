//
//  ChartCell.swift
//  CheckInTime
//
//  Created by Dat Tran on 1/11/18.
//  Copyright © 2018 Dat Tran. All rights reserved.
//

import UIKit

class ChartCell: UICollectionViewCell, ApiService {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewCircleCheckIn: UIView!
    @IBOutlet weak var viewCircleCheckOut: UIView!
    @IBOutlet weak var lblPercentCheckIn: UILabel!
    @IBOutlet weak var lblPercentCheckOut: UILabel!
    var api = callApi()
    var member: AnyObject!
    override func awakeFromNib() {
        super.awakeFromNib()
        api.deletgate = self
        // Initialization code
    }
    func setValueForCell(member: AnyObject, dateIn: String, dateOut: String) {
        let staffId = member["_id"] as? String
        self.member = member
        self.viewCircleCheckIn.layer.cornerRadius = viewCircleCheckIn.frame.size.width / 2
        self.viewCircleCheckOut.layer.cornerRadius = viewCircleCheckOut.frame.size.width / 2
        self.lblName.text = member["name"] as? String
        api.deletgate = self
        let url = member["avatarUrl"] as? String!
        let imgURL = URL(string: apiURL + url!)
        guard let urls = imgURL else {
            return
        }
        api.callApiGetStaff(url: urls)
        let urlMotivationWithStaff = URL(string: apiURL + "api/time-tracking?limit=all&dateStart=\(dateIn)&dateEnd=\(dateOut)&type=checkIn&staffId=\(staffId!)")
        guard let _ = urlMotivationWithStaff else {
            return
        }
        api.callApiChartStaff(url: urlMotivationWithStaff!)
    }
    
    func setData(data: Data){
        let image = UIImage(data: data)
        self.imgAvatar.layer.masksToBounds = true
        self.imgAvatar.layer.cornerRadius = 120
        let state = member["state"] as? Int ?? 0
        if state == 1{
            self.imgAvatar.layer.borderColor = UIColor.green.cgColor
        }else if state == 2{
            self.imgAvatar.layer.borderColor = UIColor.red.cgColor
        }
        self.imgAvatar.layer.borderWidth = 2
        self.imgAvatar.image = image
    }
    
    func setChartData(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            let arrData = json!["data"]! as! NSArray
            var arrMotivationCheckIn = [Int]()
            var arrMotivationCheckOut = [Int]()
            var numberMotivationCheckIn = 0
            var numberMotivationCheckOut = 0
            if arrData.count != 0{
                for i in 0...arrData.count - 1{
                    let data = arrData[i] as AnyObject
                    let motivationCheckInt = data["motivationCheckIn"] as? Int
                    let motivationCheckOut = data["motivationCheckOut"] as? Int
                    arrMotivationCheckIn.append(motivationCheckInt!)
                    arrMotivationCheckOut.append(motivationCheckOut!)
                    numberMotivationCheckIn += motivationCheckInt!
                    numberMotivationCheckOut += motivationCheckOut!
                }
                DispatchQueue.main.async(execute: {
                    self.lblPercentCheckIn.text = String(numberMotivationCheckIn * 100 / (arrMotivationCheckIn.count * 5)) + "%"
                    self.lblPercentCheckOut.text = String(numberMotivationCheckOut * 100 / (arrMotivationCheckOut.count * 5)) + "%"
                })
            }else{
                DispatchQueue.main.async(execute: {
                    self.lblPercentCheckIn.text = String(0)
                    self.lblPercentCheckOut.text = String(0)
                })
            }
        } catch {
            print(error)
        }
    }
}










