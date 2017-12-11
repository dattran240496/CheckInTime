//
//  ViewController.swift
//  CheckInTime
//
//  Created by Dat Tran on 12/8/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit

class Hompage: UIViewController {
    
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
        
        //imgViewAppIcon.layer.cornerRadius = imgViewAppIcon.frame.size.width / 2
        //imgViewAppIcon.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

