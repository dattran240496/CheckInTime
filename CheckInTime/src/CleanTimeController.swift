//
//  CleanTimeController.swift
//  CheckInTime
//
//  Created by Dat Tran on 12/18/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AudioToolbox
class CleanTimeController: UIViewController{
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var imgLever: UIImageView!
    @IBOutlet weak var imgViewClean1: UIImageView!
    @IBOutlet weak var imgViewClean2: UIImageView!
    @IBOutlet weak var imgViewClean3: UIImageView!
    @IBOutlet weak var imgViewClean4: UIImageView!
    var seconds = 0
    var dataMembers = NSArray()
    var arrCleanPerson = [Int]()
    var timerCleanTime = Timer()
    var soundLever = AVAudioPlayer()
    var soundRandom = AVAudioPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSetting.layer.cornerRadius = 15
        btnSetting.layer.masksToBounds = true
        self.loadViewIfNeeded()
        imgLever.isUserInteractionEnabled = true
        self.imgLever.contentMode = .scaleAspectFit
        self.getDataMembers()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.imgLever.layoutIfNeeded()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.imgLever.layer.removeAllAnimations()
    }
    @IBAction func onLeverDownAction(_ sender: UISwipeGestureRecognizer) {
        self.view.layer.removeAllAnimations()
        
        let url = Bundle.main.path(forResource: "lever", ofType: "mp3")!
        do{
            self.soundLever = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
            self.soundLever.prepareToPlay()
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch{
            print("error")
        }
        self.leverAnimateDown(index: 1)
    }
    
    func leverAnimateDown(index: Int){
        self.soundLever.play()
        UIImageView.transition(with: self.imgLever, duration: 0.05, options: .transitionCrossDissolve, animations: {
            self.imgLever.image = UIImage(named: "leverR0\(index).jpg")
        }, completion: { _ in
            if index <= 7 {
                self.leverAnimateDown(index: index + 1)
            }else{
                self.leverAnimateUp(index: index)
            }
        })
    }
    
    func leverAnimateUp(index: Int){
        
        UIImageView.transition(with: self.imgLever, duration: 0.05, options: .transitionCrossDissolve, animations: {
            self.imgLever.image = UIImage(named: "leverR0\(index).jpg")
        }, completion: { _ in
            if index >= 2 {
                self.leverAnimateUp(index: index - 1)
            }else{
                //self.leverAnimateUp(index: index)
                //self.getDataMembers()
                let url = Bundle.main.path(forResource: "slot_machine_sounds", ofType: "mp3")!
                do{
                    self.soundRandom = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
                    self.soundRandom.prepareToPlay()
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    try AVAudioSession.sharedInstance().setActive(true)
                }catch{
                    print("error")
                }
                self.timerCleanTime = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(CleanTimeController.startRandom(_:)), userInfo: nil, repeats: true)
                self.arrCleanPerson = []
                self.soundLever.pause()
            }
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
                    //print(json!["data"]!)
                    let data = json!["data"]! as! NSArray
                    self.dataMembers = data
                    for _ in 1...4{
                        self.random(arrMem: self.dataMembers)
                    }
                    self.setImgInit(arrRandom: self.arrCleanPerson, arrMem: self.dataMembers)
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
    @objc func startRandom(_ sender: Timer){
        self.seconds += 1
        if (seconds <= 20){
            self.arrCleanPerson = []
            if self.dataMembers.count >= 4{
                for _ in 1...4{
                    soundRandom.play()
                    self.random(arrMem: self.dataMembers)
                }
                self.setImgInit(arrRandom: self.arrCleanPerson, arrMem: self.dataMembers)
            }
            
        }else{
            self.soundRandom.pause()
            self.seconds = 0
            self.timerCleanTime.invalidate()
        }
    }
    func random(arrMem: NSArray){
        let randomNum:UInt32 = arc4random_uniform(UInt32(arrMem.count))
        let _:TimeInterval = TimeInterval(randomNum)
        let someInt:Int = Int(randomNum)
        var isExist = false
        for i in self.arrCleanPerson{
            if i == someInt{
                isExist = true
                break
            }
        }
        if isExist {
            self.random(arrMem: arrMem)
        }else{
            self.arrCleanPerson.append(someInt)
        }
    }
    func setImgInit(arrRandom: [Int], arrMem: NSArray) {
        
        for i in 1...4{
            let person = arrMem[arrRandom[i - 1]]
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
                            switch i{
                            case 1:
                                self.imgViewClean1.image = image
                                break
                            case 2:
                                self.imgViewClean2.image = image
                                break
                            case 3:
                                self.imgViewClean3.image = image
                                break
                            case 4:
                                self.imgViewClean4.image = image
                                break
                            default:
                                break
                            }
                        })
                        
                    } else {
                        print("Image file is currupted")
                    }
                }
                }.resume()
        }
        
    }
    
}
