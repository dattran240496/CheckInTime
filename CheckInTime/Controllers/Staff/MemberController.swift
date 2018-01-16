//
//  MemberController.swift
//  CheckInTime
//
//  Created by Dat Tran on 12/8/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import Foundation
import UIKit
class MemberController: UIViewController, ApiService{
    
    var dataMembers = NSArray()
    //let indexImgTapped:Int
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var collectionViewMembers: UICollectionView!
    //var dataMembers: AnyObject
    @IBOutlet weak var lblDateTime: UILabel!
    var timer           = Timer()
     let api            = callApi()
    override func viewDidLoad() {
        super.viewDidLoad()
        api.deletgate = self
        let classNib = UINib(nibName: "MembersCollectionViewCell", bundle: nil)
        self.collectionViewMembers?.register(classNib, forCellWithReuseIdentifier: "Cell")
        self.getDataMembers()
        collectionViewMembers.dataSource = self
        collectionViewMembers.delegate = self
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(MemberController.getTime(_:)), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        btnAdd.layer.cornerRadius = btnAdd.frame.size.width / 2
        btnAdd.titleLabel?.font = btnAdd.titleLabel?.font.withSize(btnAdd.frame.size.width / 1.5)
        lblDateTime.font = lblDateTime.font.withSize(btnAdd.frame.size.width / 2)
    }
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getTime(_:)), userInfo: nil, repeats: true)
        timer.fire()
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        self.collectionViewMembers.reloadData()
    }
    
    func getDataMembers() {
        guard let url = URL(string: apiURL + "api/staff")  else { return }
        api.callApiGetStaff(url: url)
    }
    
    @IBAction func onAddNewMemAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNewMemController") as! AddNewMemController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func getTime(_ sender: Timer){
        let dateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let result = formatter.string(from: dateTime)
        lblDateTime.text = result
    }
    
    func setData(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            let dataStaff = json!["data"]! as! NSArray
            self.dataMembers = dataStaff
            DispatchQueue.main.async {
                self.collectionViewMembers.reloadData()
            }
        } catch {
            print(error)
        }
    }
    
    func setChartData(data: Data) {
        
    }
}


// MARK: - Implement UICollectionViewDelegateFlowLayout
extension MemberController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 280)
    }
}


// MARK: - Implement UICollectionViewDataSource
extension MemberController: UICollectionViewDataSource, UIGestureRecognizerDelegate{
    func editMem(name: String, email: String, avatar: UIImage) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewMembers.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MembersCollectionViewCell
        cell.setValueForCell(member: dataMembers[indexPath.row] as AnyObject)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "AddNewMemController") as! AddNewMemController
        let person = dataMembers[indexPath.row]
        vc.memberName           = (person as AnyObject)["name"] as? String
        vc.memberEmail          = (person as AnyObject)["email"] as? String
        vc.memberAvatar         = (person as AnyObject)["avatarUrl"] as? String
        vc.staffId              = (person as AnyObject)["_id"] as? String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func imgTapped(_ sender: UITapGestureRecognizer){
        print("Image tapped")
    }
}

// MARK: - Implement UICollectionViewDelegate
extension MemberController: UICollectionViewDelegate{
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        self.view.layoutIfNeeded()
        self.view.setNeedsDisplay()
    }
    
}
