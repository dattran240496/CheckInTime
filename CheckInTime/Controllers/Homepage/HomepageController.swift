//
//  ViewController.swift
//  CheckInTime
//
//  Created by Dat Tran on 12/8/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit

class HomepageController: UIViewController {
    
    @IBOutlet weak var btnCheckInTime: UIButton!
    @IBOutlet weak var btnCleanTime: UIButton!
    @IBOutlet weak var btnMembers: UIButton!
    @IBOutlet weak var btnGroup: UIButton!
    @IBOutlet weak var imgViewAppIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnCheckInTime.layer.cornerRadius = 15
        btnCheckInTime.layer.borderColor = UIColor.gray.cgColor
        btnCheckInTime.layer.borderWidth = 2
        
        btnCleanTime.layer.cornerRadius = 15
        btnCleanTime.layer.borderColor = UIColor.gray.cgColor
        btnCleanTime.layer.borderWidth = 2
        
        btnMembers.layer.cornerRadius = 15
        btnMembers.layer.borderColor = UIColor.gray.cgColor
        btnMembers.layer.borderWidth = 2
        
        btnGroup.layer.cornerRadius = 15
        btnGroup.layer.borderColor = UIColor.gray.cgColor
        btnGroup.layer.borderWidth = 2
        
        let imgAvatar = UIImageView(image: UIImage(named: "imgAvatar-temp.png"))
        let data = UIImagePNGRepresentation(imgAvatar.image!)
        guard let base64String = UIImagePNGRepresentation((imgAvatar.image?.resized(toWidth: 300)!)!)?.base64EncodedString() else{
            return
        }
  
        //print("data:image/png;base64," + base64String)
        guard let url = URL(string: apiURL + "uploads")  else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("Hello! I am mobile", forHTTPHeaderField: "x-access-token-mobile")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let param :[String: Any] = [
            "filename": base64String
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: param, options: [])
        }catch{print("error")}
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            guard let _ = data, error == nil else{
                return
            }
            if let response = response {
                print("Response: \n \(response)")
            }
            let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(strData ?? "")
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    @IBAction func onMemberAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemberController") as! MemberController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCheckInTimeAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckInTimeController") as! CheckInTimeController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onCleanTimeAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CleanTimeController") as! CleanTimeController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

