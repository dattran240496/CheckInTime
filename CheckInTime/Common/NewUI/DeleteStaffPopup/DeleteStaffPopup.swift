//
//  DeleteStaffPopup.swift
//  CheckInTime
//
//  Created by Dat Tran on 1/18/18.
//  Copyright © 2018 Dat Tran. All rights reserved.
//

import UIKit

class DeleteStaffPopup: UIViewController, ApiService {
    
    @IBOutlet weak var btnCancel:       UIButton!
    @IBOutlet weak var btnDelete:       UIButton!
    @IBOutlet weak var lblTitle:        UILabel!
    var staffId                         = String()
    let api                             = callApi()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCancel.layer.cornerRadius        = 5
        btnDelete.layer.cornerRadius        = 5
        btnCancel.titleLabel?.font          = UIFont(name: (btnCancel.titleLabel?.font.fontName)!, size: btnDelete.frame.size.height / 2)
        btnDelete.titleLabel?.font          = UIFont(name: (btnCancel.titleLabel?.font.fontName)!, size: btnDelete.frame.size.height / 2)
        api.deletgate                       = self
        lblTitle.font = UIFont(name: (lblTitle.font.fontName), size: self.view.frame.size.height / 15)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    @IBAction func onCancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDeleteAction(_ sender: Any) {
        api.deleteStaff(staffId: staffId)
    }
    
    func callBackAfterDelete(message: String) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDataInStaffScene"), object: nil)
    }
    
    func setData(data: Data) {}
    func setChartData(data: Data) {}

}
