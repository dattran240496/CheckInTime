//
//  EmojiPopup.swift
//  CheckInTime
//
//  Created by Dat Tran on 12/25/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit

class EmojiPopup: UIViewController {

    @IBOutlet var tapView: UITapGestureRecognizer!
    var staff: AnyObject!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        tapView.view?.isUserInteractionEnabled = true
        tapView.isEnabled = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPressBackDropAction(_ sender: Any) {
        print("press")
        dismiss()
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissPopup"), object: nil)
    }
    
    
    
    func dismiss(){
        UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.view.alpha = 0
        }, completion: { finished in
            self.view.removeFromSuperview()
            
        })
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
