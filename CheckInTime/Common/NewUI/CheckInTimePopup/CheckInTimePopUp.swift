//
//  CheckInTimePopUp.swift
//  CheckInTime
//
//  Created by Dat Tran on 12/15/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit
protocol Modal {
    func show(animated:Bool)
    func dismiss(animated:Bool)
    var backgroundView:UIView {get}
    var dialogView:UIView {get set}
}

class CheckInTimePopUp: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var view: UIView!
    var staffId: String!
    var staff: AnyObject!
    var motivation: Int!
    
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
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.contentView)
        self.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
        })
    }
    
    @IBAction func onPressBackDropAction(_ sender: Any) {
        dismiss()
    }
  
    func dismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.view.alpha = 0
            self.contentView.alpha = 0
        }, completion: { finished in
            self.removeFromSuperview()
        })
    }

    @IBAction func onCheckInAction(_ sender: Any) {
        self.staffCheckTime(method: "POST", motivation: 1)
        dismiss()
    }
    
    @IBAction func onCheckOutAction(_ sender: Any) {
        self.staffCheckTime(method: "PUT", motivation: 2)
        dismiss()
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
    }
}
