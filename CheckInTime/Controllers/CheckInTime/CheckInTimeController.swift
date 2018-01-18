//
//  CheckInTime.swift
//  CheckInTime
//
//  Created by Dat Tran on 12/15/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import Foundation
import UIKit
class CheckInTimeController: UIViewController, ApiService{
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var collectionViewMemList: UICollectionView!
    @IBOutlet weak var imgViewSun: UIImageView!
    var numberOfRepeat:Double       = 1
    var dataMembers                 = NSArray()
    //var emojiPopup = EmojiPopup()
    var staffForCheckTime: AnyObject!
    var timer                       = Timer()
    let api                         = callApi()
    override func viewDidLoad() {
        super.viewDidLoad()
        api.deletgate = self
        // run animation Sun
        self.animateSun()
        let classNib    = UINib(nibName: "MembersCollectionViewCell", bundle: nil)
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
        // timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getTime(_:)), userInfo: nil, repeats: true)
        timer.fire()
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    override func viewWillAppear(_ animated: Bool) {
        lblDateTime.font = lblDateTime.font.withSize(self.view.frame.size.height / 10)
    }
    @objc func onChartAction() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StaffListChart") as! StaffListChart
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onChartAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StaffListChart") as! StaffListChart
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // timer
    @objc func getTime(_ sender: Timer){
        let dateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let result = formatter.string(from: dateTime)
        lblDateTime.text = "\(result)"
    }
    // sun animation
    func animateSun(){
        UIView.animate(withDuration: 6, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.imgViewSun.transform = CGAffineTransform(rotationAngle: -CGFloat(self.numberOfRepeat * Double.pi))
        }, completion: { _ in
            self.numberOfRepeat += 1
            self.animateSun()
        })
    }
    // get all staff
    func getDataMembers() {
        guard let url = URL(string: apiURL + "api/staff")  else { return }
        api.callApiGetStaff(url: url)
    }
    // reload collection view when check in time
    @objc func reloadCollectionView(notification: NSNotification){
        self.getDataMembers()
        DispatchQueue.main.async {
            self.collectionViewMemList.reloadData()
        }
    }
    // show alert if you press "Check In" button and you are "Check In"
    @objc func showAlertCheckIn(notification: NSNotification){
        let alertController = UIAlertController(title: "Warning", message: "You have already checked in.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in}
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // show alert if you press "Check Out" button and you are "Check Out"
    @objc func showAlertCheckOut(notification: NSNotification){
        let alertController = UIAlertController(title: "Warning", message: "You have already checked out.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in}
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setData(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            let dataStaff = json!["data"]! as! NSArray
            self.dataMembers = dataStaff
            DispatchQueue.main.async {
                self.collectionViewMemList.reloadData()
            }
        } catch {
            print(error)
        }
    }
    
    func setChartData(data: Data) {}
    func callBackAfterDelete(message: String) {}
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


// MARK: - implement CollectionView
extension CheckInTimeController: UICollectionViewDelegate{
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        self.view.layoutIfNeeded()
        self.view.setNeedsDisplay()
    }
    
}

