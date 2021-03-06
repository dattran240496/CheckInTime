//
//  WinnerViewController.swift
//  CheckInTime
//
//  Created by Dat Tran on 1/16/18.
//  Copyright © 2018 Dat Tran. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class WinnerViewController: UIViewController {
    
    @IBOutlet weak var imgBackground:       UIImageView!
    @IBOutlet weak var imgWinner1:          UIImageView!
    @IBOutlet weak var imgWinner2:          UIImageView!
    @IBOutlet weak var imgWinner3:          UIImageView!
    @IBOutlet weak var imgWinner4:          UIImageView!
    @IBOutlet weak var lblNameWinner1:      UILabel!
    @IBOutlet weak var lblNameWinner2:      UILabel!
    @IBOutlet weak var lblNameWinner3:      UILabel!
    @IBOutlet weak var lblNameWinner4:      UILabel!
    
    var soundDoneRandomStaff        = AVAudioPlayer()
    var winner1                     = Candicate()
    var winner2                     = Candicate()
    var winner3                     = Candicate()
    var winner4                     = Candicate()
    let arrRandom                   = [Int]() // staff index array to clean
    let arrStaff                    = [AnyObject]() // staff array to clean
    var swipeGesture:               UISwipeGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeGesture                            = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGesture.direction                  = .down
        imgBackground.addGestureRecognizer(swipeGesture)
        imgBackground.isUserInteractionEnabled  = true
        DispatchQueue.main.async(execute: {
            self.setWinners()
        })
        let url                                 = Bundle.main.path(forResource: "bingo", ofType: "mp3")!
        do{
            self.soundDoneRandomStaff           = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
            self.soundDoneRandomStaff.prepareToPlay()
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch{
            print("error")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.soundDoneRandomStaff.play()
    }
    func setWinners(){
        if winner1.name != ""{
            self.imgWinner1.image            = winner1.avatar
            self.lblNameWinner1.text         = winner1.name
        }
        if winner2.name != ""{
            self.imgWinner2.image            = winner2.avatar
            self.lblNameWinner2.text         = winner2.name
        }
        if winner3.name != ""{
            self.imgWinner3.image            = winner3.avatar
            self.lblNameWinner3.text         = winner3.name
        }
        if winner4.name != ""{
            self.imgWinner4.image            = winner4.avatar
            self.lblNameWinner4.text         = winner4.name
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer){
        // remove data 
        winner1.avatar               = nil
        winner1.name                 = nil
        winner2.avatar               = nil
        winner2.name                 = nil
        winner3.avatar               = nil
        winner3.name                 = nil
        winner4.avatar               = nil
        winner4.name                 = nil
        self.imgWinner1.image        = nil
        self.lblNameWinner1.text     = ""
        self.imgWinner2.image        = nil
        self.lblNameWinner2.text     = ""
        self.imgWinner3.image        = nil
        self.lblNameWinner3.text     = ""
        self.imgWinner4.image        = nil
        self.lblNameWinner4.text     = ""
        self.dismiss(animated: true, completion: nil)
    }
}
