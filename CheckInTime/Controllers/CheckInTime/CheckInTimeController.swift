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
    //var emojiPopup = EmojiPopup()
    var staffForCheckTime: AnyObject!
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // run animation Sun
        self.animateSun()
        let classNib = UINib(nibName: "MembersCollectionViewCell", bundle: nil)
        self.collectionViewMemList?.register(classNib, forCellWithReuseIdentifier: "Cell")
        // get info employee
        self.getDataMembers()

        self.collectionViewMemList.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: NSNotification.Name(rawValue: "reload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAlertCheckIn), name: NSNotification.Name(rawValue: "alertCheckIn"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAlertCheckOut), name: NSNotification.Name(rawValue: "alertCheckOut"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getTime(_:)), userInfo: nil, repeats: true)
        timer.fire()
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    @objc func getTime(_ sender: Timer){
        let dateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let result = formatter.string(from: dateTime)
     
        lblDateTime.text = "\(result)"
        print(result)
    }
    
    func animateSun(){
        UIView.animate(withDuration: 6, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.imgViewSun.transform = CGAffineTransform(rotationAngle: -CGFloat(self.numberOfRepeat * Double.pi))
        }, completion: { _ in
            self.numberOfRepeat += 1
            self.animateSun()
        })
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
                    let data = json!["data"]! as! NSArray
                    self.dataMembers = data
                    DispatchQueue.main.async {
                        self.collectionViewMemList.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
            }.resume()
        
    }
    
    @objc func reloadCollectionView(notification: NSNotification){
        self.getDataMembers()
        DispatchQueue.main.async {
            self.collectionViewMemList.reloadData()
        }
    }
    
    @objc func showAlertCheckIn(notification: NSNotification){
        let alertController = UIAlertController(title: "Warning", message: "You have already checked in.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in}
        alertController.addAction(yesAction)
       self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func showAlertCheckOut(notification: NSNotification){
        let alertController = UIAlertController(title: "Warning", message: "You have already checked out.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in}
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
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
        cell.setValueForCell(member: self.dataMembers[indexPath.row] as AnyObject)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let popup = CheckInTimePopUp()
        popup.staff = dataMembers[indexPath.row] as AnyObject
        popup.frame = self.view.bounds
        self.view.addSubview(popup)
    }
}

extension CheckInTimeController: UICollectionViewDelegate{
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        self.view.layoutIfNeeded()
        self.view.setNeedsDisplay()
    }
    
}

