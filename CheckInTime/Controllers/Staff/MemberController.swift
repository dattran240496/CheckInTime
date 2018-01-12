//
//  MemberController.swift
//  CheckInTime
//
//  Created by Dat Tran on 12/8/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import Foundation
import UIKit
class MemberController: UIViewController{
    
    var dataMembers = NSArray()
    //let indexImgTapped:Int
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var collectionViewMembers: UICollectionView!
    //var dataMembers: AnyObject
    @IBOutlet weak var lblDateTime: UILabel!
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        let classNib = UINib(nibName: "MembersCollectionViewCell", bundle: nil)
        self.collectionViewMembers?.register(classNib, forCellWithReuseIdentifier: "Cell")
        // Do any additional setup after loading the view, typically from a nib.
        
        self.getDataMembers()
        collectionViewMembers.dataSource = self
        collectionViewMembers.delegate = self
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(MemberController.getTime(_:)), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getTime(_:)), userInfo: nil, repeats: true)
        timer.fire()
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        
        btnAdd.layer.cornerRadius = btnAdd.frame.size.width / 2
        btnAdd.titleLabel?.font = btnAdd.titleLabel?.font.withSize(btnAdd.frame.size.width / 1.5)
        lblDateTime.font = lblDateTime.font.withSize(btnAdd.frame.size.width / 2)
        self.collectionViewMembers.reloadData()
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
                } catch {
                    print(error)
                }
            }
            }.resume()
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
        vc.memberName = (person as AnyObject)["name"] as? String
        vc.memberEmail = (person as AnyObject)["email"] as? String
        vc.memberAvatar = (person as AnyObject)["avatarUrl"] as? String
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
