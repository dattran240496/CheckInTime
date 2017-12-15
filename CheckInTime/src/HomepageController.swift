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
    
    
}

