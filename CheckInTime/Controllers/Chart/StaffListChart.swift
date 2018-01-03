//
//  StaffListChart.swift
//  CheckInTime
//
//  Created by Dat Tran on 1/3/18.
//  Copyright © 2018 Dat Tran. All rights reserved.
//

import Foundation
import UIKit
class StaffListChart: UIViewController{
    
    @IBOutlet weak var txtInputDateStart: UITextField!
    @IBOutlet weak var txtInputDateEnd: UITextField!
    @IBOutlet weak var btnDateStartCalendar: UIButton!
    
    let datePickerStart = UIDatePicker()
    let datePickerEnd = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initdatePicker()
    }
    
    func initdatePicker() {
        datePickerStart.datePickerMode = .date
        datePickerStart.backgroundColor = UIColor.white
        datePickerStart.addTarget(self, action: #selector(datePickerStartOnChangeValue(_:)), for: UIControlEvents.valueChanged)
        txtInputDateStart.inputView = datePickerStart
        
        let doneButton = UIButton(frame: CGRect(x: self.view.frame.size.width - 100, y: -50, width: 100, height: 50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.tintColor = UIColor.red
        doneButton.setTitleColor(UIColor.blue, for: .normal)
        datePickerStart.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(handleDoneButton(_:)), for: UIControlEvents.touchUpOutside)
//
//        datePickerEnd.datePickerMode = .date
//        datePickerEnd.backgroundColor = UIColor.white
//        datePickerEnd.addTarget(self, action: #selector(datePickerEndOnChangeValue(_:)), for: UIControlEvents.valueChanged)
//        txtInputDateEnd.inputView = datePickerEnd
        
    }
    
    @IBAction func onDateStartCalendarAction(_ sender: Any) {
        //datePicker.addTarget(self, action: #selector(datePickerOnChangeValue(_:)), for: UIControlEvents.valueChanged)
    }
    @IBAction func onDateStartArrowAction(_ sender: Any) {
        //datePicker.addTarget(self, action: #selector(datePickerOnChangeValue(_:)), for: UIControlEvents.valueChanged)
    }
    @IBAction func onDateEndCalendarAction(_ sender: Any) {
        //datePicker.addTarget(self, action: #selector(datePickerOnChangeValue(_:)), for: UIControlEvents.valueChanged)
    }
    @IBAction func onDateEndArrowAction(_ sender: Any) {
        //datePicker.addTarget(self, action: #selector(datePickerOnChangeValue(_:)), for: UIControlEvents.valueChanged)
    }
    @objc func handleDoneButton(_ sender: UIButton) {
        print("press")
        txtInputDateStart.resignFirstResponder()
        txtInputDateEnd.resignFirstResponder()
    }
    @objc func datePickerStartOnChangeValue(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print(dateFormatter.string(from: sender.date))
        txtInputDateStart.text = dateFormatter.string(from: sender.date)
    }
    @objc func datePickerEndOnChangeValue(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print(dateFormatter.string(from: sender.date))
        txtInputDateEnd.text = dateFormatter.string(from: sender.date)
    }
    
}
