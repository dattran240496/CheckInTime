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
        dismiss()
        print("check in")
    }
    
    @IBAction func onCheckOutAction(_ sender: Any) {
        print("check out")
        dismiss()
    }
}
