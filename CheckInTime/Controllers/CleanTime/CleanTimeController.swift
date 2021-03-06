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
class CleanTimeController: UIViewController, ApiService{
    
    @IBOutlet weak var btnSetting:      UIButton!
    @IBOutlet weak var imgLever:        UIImageView!
    @IBOutlet weak var imgViewClean1:   UIImageView!
    @IBOutlet weak var imgViewClean2:   UIImageView!
    @IBOutlet weak var imgViewClean3:   UIImageView!
    @IBOutlet weak var imgViewClean4:   UIImageView!
    @IBOutlet weak var lblName1:        UILabel!
    @IBOutlet weak var lblName2:        UILabel!
    @IBOutlet weak var lblName3:        UILabel!
    @IBOutlet weak var lblName4:        UILabel!
    
    var seconds             = 0 // time when random staff
    //var allStaff            = [AnyObject]() // all staff
    var arrCleanPerson      = [Int]() // index 4 staff in staff array
    var timerCleanTime      = Timer()
    var soundLever          = AVAudioPlayer()
    var soundRandom         = AVAudioPlayer()
    let api                 = callApi()
    var staffForClean       = [AnyObject]() // staff checked in
    var isRandom            = false
    var isDoneRandone       = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadViewIfNeeded()
        api.deletgate                       = self
        imgLever.isUserInteractionEnabled   = true
        self.imgLever.contentMode           = .scaleAspectFit
        self.getDataMembers()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.imgLever.layoutIfNeeded()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.imgLever.layer.removeAllAnimations()
    }
    @IBAction func onLeverDownAction(_ sender: UISwipeGestureRecognizer) {
        if isDoneRandone{
            self.isRandom       = false
            self.isDoneRandone  = false
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
    }
    // lever animation when go down
    func leverAnimateDown(index: Int){
        self.soundLever.play()
        UIImageView.transition(with: self.imgLever, duration: 0.04, options: .transitionCrossDissolve, animations: {
            self.imgLever.image = UIImage(named: "leverR0\(index).jpg")
        }, completion: { _ in
            if index <= 7 {
                self.leverAnimateDown(index: index + 1)
            }else{
                self.leverAnimateUp(index: index)
            }
        })
    }
    
    // lever animation when go up
    func leverAnimateUp(index: Int){
        UIImageView.transition(with: self.imgLever, duration: 0.04, options: .transitionCrossDissolve, animations: {
            self.imgLever.image = UIImage(named: "leverR0\(index).jpg")
        }, completion: { _ in
            if index >= 2 {
                self.leverAnimateUp(index: index - 1)
            }else{
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
    
    // get all staff
    func getDataMembers() {
        guard let url = URL(string: apiURL + "users?status=checked_in")  else { return }
        api.callApiGetStaff(url: url)
    }
    // random 4 numbers, for 0 to staff lenght
    @objc func startRandom(_ sender: Timer){
        var numberRandom = 0
        self.seconds += 1
        if self.staffForClean.count < 4 {
            seconds = timeClean
            self.soundRandom.stop()
        }
        if (seconds < timeClean){
            self.arrCleanPerson = []
            if self.staffForClean.count >= 4{
                numberRandom = 4
            }else{
                //self.setImgCleanStaff(arrRandom: self.arrCleanPerson, arrMem: self.staffForClean)
                numberRandom = self.staffForClean.count
            }
            for _ in 1...numberRandom{
                soundRandom.play()
                self.random(arrMem: self.staffForClean)
            }
            self.setImgCleanStaff(arrRandom: self.arrCleanPerson, arrMem: self.staffForClean)
        }else{
            for i in 0...self.staffForClean.count - 1{
                self.arrCleanPerson.append(i)
            }
            self.isDoneRandone      = true
            self.seconds            = 0
            self.setImgCleanStaff(arrRandom: self.arrCleanPerson, arrMem: self.staffForClean)
            self.soundRandom.pause()
            self.timerCleanTime.invalidate()
            self.isRandom           = true
        }
    }
    // random
    func random(arrMem: [AnyObject]){
        let randomNum:UInt32    = arc4random_uniform(UInt32(arrMem.count))
        let _:TimeInterval      = TimeInterval(randomNum)
        let someInt:Int         = Int(randomNum)
        var isExist             = false
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
    
    // set 4 staff at initial screen
    func setImgCleanStaff(arrRandom: [Int], arrMem: [AnyObject]) {
        for i in 1...arrRandom.count{
            let person      = arrMem[arrRandom[i - 1]]
            let imgAvatar   = person["image"] as AnyObject
            let name        = person["name"] as? String!
            let url         = imgAvatar["url"] as? String ?? ""
            let imgURL      = URL(string: apiURL + url)
            let session     = URLSession.shared
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
                                self.imgViewClean1.image = image ?? UIImage(named: "imgAvatar-temp.png")
                                self.lblName1.text = name
                                break
                            case 2:
                                self.imgViewClean2.image = image ?? UIImage(named: "imgAvatar-temp.png")
                                self.lblName2.text = name
                                break
                            case 3:
                                self.imgViewClean3.image = image ?? UIImage(named: "imgAvatar-temp.png")
                                self.lblName3.text = name
                                break
                            case 4:
                                self.imgViewClean4.image = image ?? UIImage(named: "imgAvatar-temp.png")
                                self.lblName4.text = name
                                break
                            default:
                                break
                            }
                        })
                        if self.isRandom == true || self.staffForClean.count < 4{
                            DispatchQueue.main.async(execute:{
                                let winner1             = Candicate(name: self.lblName1.text!, avatar: self.imgViewClean1.image ?? UIImage(named: "imgAvatar-temp.png")!)
                                let winner2             = Candicate(name: self.lblName2.text!, avatar: self.imgViewClean2.image ?? UIImage(named: "imgAvatar-temp.png")!)
                                let winner3             = Candicate(name: self.lblName3.text!, avatar: self.imgViewClean3.image ?? UIImage(named: "imgAvatar-temp.png")!)
                                let winner4             = Candicate(name: self.lblName4.text!, avatar: self.imgViewClean4.image ?? UIImage(named: "imgAvatar-temp.png")!)
                                DispatchQueue.main.async(execute: {
                                    let cleanWinner         = WinnerViewController(nibName: "WinnerViewController", bundle: nil)
                                    cleanWinner.winner1     = winner1
                                    cleanWinner.winner2     = winner2
                                    cleanWinner.winner3     = winner3
                                    cleanWinner.winner4     = winner4
                                    //cleanWinner.setWinners(winner1: winner1, winner2: winner2, winner3: winner3, winner4: winner4)
                                    self.present(cleanWinner, animated: true, completion: nil)
                                    })
                            })
                        }
                    } else {
                        print("Image file is currupted")
                    }
                }
                }.resume()
        }
        
    }
    
    func setData(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSArray
            let staffs = json!
            for staff in staffs{
                self.staffForClean.append(staff as AnyObject)
            }
            var numberRandom = 0
            if self.staffForClean.count >= 4{
                numberRandom = 4
            }else{
                //self.arrCleanPerson = self.staffForClean
                numberRandom = self.staffForClean.count
            }
            for _ in 1...numberRandom{
                self.random(arrMem: self.staffForClean)
            }
            self.setImgCleanStaff(arrRandom: self.arrCleanPerson, arrMem: self.staffForClean)
        } catch {
            print(error)
        }
        
    }
    
    func setChartData(data: Data) {
        
    }
    func callBackAfterDelete(message: String) {}
}
