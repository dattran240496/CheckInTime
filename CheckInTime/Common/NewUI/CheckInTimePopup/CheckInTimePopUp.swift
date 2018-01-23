//
//  CheckInTimePopUp.swift
//  CheckInTime
//
//  Created by Dat Tran on 12/15/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit

class CheckInTimePopUp: UIView {
    
    @IBOutlet var optionCheckView:      UIView!
    @IBOutlet weak var emojiView:       UIView!
    @IBOutlet weak var viewContainer:   UIView!
    @IBOutlet var tapGuestView:         UITapGestureRecognizer!
    var staffId:                        String!
    var staff:                          AnyObject!
    var motivation:                     Int!
    var methodCheckTime:                String!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }
    
    private func initCommon(){
        Bundle.main.loadNibNamed("CheckInTimePopUp", owner: self, options: nil)
        self.viewContainer.frame = self.bounds
        self.viewContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.viewContainer)
        self.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
        })
    }
    
    @IBAction func onPressBackDropAction(_ sender: Any) {
        dismissEmojiView()
    }
  
    func dismissOptionCheck(){
        UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.optionCheckView.alpha = 0
        }, completion: { finished in
            self.optionCheckView.removeFromSuperview()
        })
    }
    
    func dismissEmojiView(){
        UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.emojiView.alpha = 0
            self.optionCheckView.alpha = 0
            self.alpha = 0
        }, completion: { finished in
            self.emojiView.removeFromSuperview()
            self.optionCheckView.removeFromSuperview()
            self.removeFromSuperview()
        })
    }

    @IBAction func onCheckInAction(_ sender: Any) {
        if staff["state"] as? Int == 1{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "alertCheckIn"), object: nil)
        }else{
            self.methodCheckTime = "POST"
            dismissOptionCheck()
            initEmojiView()
        }
        
    }
    
    @IBAction func onCheckOutAction(_ sender: Any) {
        if staff["state"] as? Int == 2{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "alertCheckOut"), object: nil)
        }else{
            self.methodCheckTime = "PUT"
            dismissOptionCheck()
            initEmojiView()
        }
        
    }
    func initEmojiView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.emojiView.alpha = 1
        })
    }
    @objc func dismissPopup(notification: NSNotification){
        UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.alpha = 0
        }, completion: { finished in
            //self.removeFromSuperview()
        })
    }
    
    @IBAction func onVeryUpsetAction(_ sender: Any) {
        self.staffCheckTime(method: methodCheckTime, motivation: 1)
    }
    
    @IBAction func onUpsetAction(_ sender: Any) {
        self.staffCheckTime(method: methodCheckTime, motivation: 2)
    }

    @IBAction func onNormalAction(_ sender: Any) {
        self.staffCheckTime(method: methodCheckTime, motivation: 3)
    }
    
    @IBAction func onHappyAction(_ sender: Any) {
        self.staffCheckTime(method: methodCheckTime, motivation: 4)
    }
    
    @IBAction func onVeryHappyAction(_ sender: Any) {
        self.staffCheckTime(method: methodCheckTime, motivation: 5)
    }
    
    func staffCheckTime(method: String, motivation: Int){
        guard let url = URL(string: apiURL + "api/time-tracking") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("Hello! I am mobile", forHTTPHeaderField: "x-access-token-mobile")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let staffId = staff["_id"] as? String
        let param :[String: Any] = [
            "staffId": staffId ?? "",
            "motivation": motivation
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: param, options: [])
        }catch{
            print("error")
        }
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            guard error == nil else { return }
            if let response = response {
                print(response)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
        }
        task.resume()
        self.dismissEmojiView()
    }
}
extension CheckInTimePopUp: UIAlertViewDelegate{
    func showAlert(){
        
    }
}
