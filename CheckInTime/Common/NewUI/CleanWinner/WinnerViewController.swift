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
    
    var soundDoneRandomStaff      = AVAudioPlayer()
    var winner1         = Candicate()
    var winner2         = Candicate()
    var winner3         = Candicate()
    var winner4         = Candicate()
    let arrRandom       = [Int]() // staff index array to clean
    let arrStaff        = [AnyObject]() // staff array to clean
    var swipeGesture: UISwipeGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeGesture                            = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGesture.direction                  = .down
        imgBackground.addGestureRecognizer(swipeGesture)
        imgBackground.isUserInteractionEnabled  = true
        setWinners(winner1: winner1, winner2: winner2, winner3: winner3, winner4: winner4)
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
    func setWinners(winner1: Candicate, winner2: Candicate, winner3: Candicate, winner4: Candicate){
        imgWinner1.image            = winner1.avatar
        lblNameWinner1.text         = winner1.name
        imgWinner2.image            = winner2.avatar
        lblNameWinner2.text         = winner2.name
        imgWinner3.image            = winner3.avatar
        lblNameWinner3.text         = winner3.name
        imgWinner4.image            = winner4.avatar
        lblNameWinner4.text         = winner4.name
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func handleSwipe(){
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
