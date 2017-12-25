//
//  CheckInTime.swift
//  CheckInTime
//
//  Created by Dat Tran on 12/15/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import Foundation
import UIKit
class CheckInTimeController: UIViewController{
    
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var collectionViewMemList: UICollectionView!
    @IBOutlet weak var imgViewSun: UIImageView!
    var numberOfRepeat:Double = 1
    var dataMembers = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animateSun()
        
        let classNib = UINib(nibName: "MembersCollectionViewCell", bundle: nil)
        self.collectionViewMemList?.register(classNib, forCellWithReuseIdentifier: "Cell")
        
        self.getDataMembers()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(getTime(_:)), userInfo: nil, repeats: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionViewMemList.reloadData()
    }
    
    @objc func getTime(_ sender: Timer){
        let dateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let result = formatter.string(from: dateTime)
        lblDateTime.text = result
        //self.getTime()
    }
    
    func animateSun(){
        UIView.animate(withDuration: 6, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.imgViewSun.transform = CGAffineTransform(rotationAngle: -CGFloat(self.numberOfRepeat * Double.pi))
        }, completion: { _ in
            self.numberOfRepeat += 1
            self.animateSun()
        }
        )
    }
    
    func getDataMembers() {
        guard let url = URL(string: apiURL + "api/staff")  else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Hello! I am mobile", forHTTPHeaderField: "x-access-token-mobile")
        
        let session = URLSession.shared
        session.dataTask(with: request){ (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    //print(json!["data"]!)
                    let data = json!["data"]! as! NSArray
                    self.dataMembers = data
                    //self.collectionViewMemList.reloadData()
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
}

// MARK: - Implement UICollectionViewDelegate
extension CheckInTimeController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 280)
    }
}

// MARK: - Implement UICollectionViewDataSource
extension CheckInTimeController: UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataMembers.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewMemList.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MembersCollectionViewCell
        let person = dataMembers[indexPath.row]
        cell.lblName.text = (person as AnyObject)["name"] as? String
        
        let url = (person as AnyObject)["avatarUrl"] as? String!
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
                        cell.imgAvatar.layer.masksToBounds = true
                        cell.imgAvatar.layer.cornerRadius = 120
                        cell.imgAvatar.layer.borderColor = UIColor.red.cgColor
                        cell.imgAvatar.layer.borderWidth = 1
                        cell.imgAvatar.image = image
                    })
                    
                } else {
                    print("Image file is currupted")
                }
            }
            }.resume()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let popup = CheckInTimePopUp()
     
        popup.frame = self.view.bounds
        self.view.addSubview(popup)
    }
}
