//
//  DetailChart.swift
//  CheckInTime
//
//  Created by Dat Tran on 1/11/18.
//  Copyright © 2018 Dat Tran. All rights reserved.
//

import Foundation
import UIKit

class DetailChartController: UIViewController, ApiService{

    @IBOutlet weak var txtInputDateStart: UITextField!
    @IBOutlet weak var txtInputDateEnd: UITextField!
    @IBOutlet weak var btnDateStartCalendar: UIButton!
    
    var api = callApi()
    let datePickerStart = UIDatePicker()
    let datePickerEnd = UIDatePicker()
    
    var staff: AnyObject!
    var dateIn: String!
    var dateOut: String!
    var staffId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.staffId = staff["_id"] as? String
        self.title = staff["name"] as? String
        self.initdatePicker()
        self.getStaffChart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initdatePicker() {
        datePickerStart.datePickerMode = .date
        datePickerStart.backgroundColor = UIColor.white
        datePickerStart.addTarget(self, action: #selector(datePickerStartOnChangeValue(_:)), for: UIControlEvents.valueChanged)
        txtInputDateStart.inputView = datePickerStart
        
        datePickerEnd.datePickerMode = .date
        datePickerEnd.backgroundColor = UIColor.white
        datePickerEnd.addTarget(self, action: #selector(datePickerEndOnChangeValue(_:)), for: UIControlEvents.valueChanged)
        txtInputDateEnd.inputView = datePickerEnd
        
        // Adding Button ToolBar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolbar.barStyle = .default
        toolbar.tintColor = UIColor.blue
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneButton(_:)))
        toolbar.setItems([doneBtn], animated: true)
        txtInputDateStart.inputAccessoryView = toolbar
        txtInputDateEnd.inputAccessoryView = toolbar
    }
    
    @IBAction func onDateStartCalendarAction(_ sender: Any) {
        //datePicker.addTarget(self, action: #selector(datePickerOnChangeValue(_:)), for: UIControlEvents.valueChanged)
        self.txtInputDateStart.becomeFirstResponder()
    }

    @IBAction func onDateEndCalendarAction(_ sender: Any) {
        self.txtInputDateEnd.becomeFirstResponder()
    }
    
    @IBAction func onSearchChartAction(_ sender: Any) {
    }
    
    @objc func handleDoneButton(_ sender: UIButton) {
        txtInputDateStart.resignFirstResponder()
        txtInputDateEnd.resignFirstResponder()
    }
    
    @objc func datePickerStartOnChangeValue(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
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
    
    @IBAction func dateTextInputPressed(_ sender: UITextField) {
        let doneButton = UIButton(frame: CGRect(x: self.view.frame.size.width - 100, y: -50, width: 100, height: 50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(UIColor.blue, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.blue, for: UIControlState.highlighted)
        doneButton.addTarget(self, action: #selector(handleDoneButton(_:)), for: UIControlEvents.touchDragInside)
        datePickerStart.addSubview(doneButton)
    }
    
    func getStaffChart() {
        print(dateIn)
        print(dateOut)
        print(staffId)
        let urlMotivationWithStaff = URL(string: apiURL + "api/time-tracking?limit=all&dateStart=\(dateIn!)&dateEnd=\(dateOut!)&type=checkIn&staffId=\(staffId!)")
        guard let _ = urlMotivationWithStaff else {
            print("error")
            return
        }
        api.deletgate = self
        api.callApiChartStaff(url: urlMotivationWithStaff!)
    }
     func setChartData(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            let arrData = json!["data"]! as! NSArray
            var arrMotivationCheckIn = [Int]()
            var arrMotivationCheckOut = [Int]()
            var numberMotivationCheckIn = 0
            var numberMotivationCheckOut = 0
            print(arrData)
//            if arrData.count != 0{
//                for i in 0...arrData.count - 1{
//                    let data = arrData[i] as AnyObject
//                    let motivationCheckInt = data["motivationCheckIn"] as? Int
//                    let motivationCheckOut = data["motivationCheckOut"] as? Int
//                    arrMotivationCheckIn.append(motivationCheckInt!)
//                    arrMotivationCheckOut.append(motivationCheckOut!)
//                    numberMotivationCheckIn += motivationCheckInt!
//                    numberMotivationCheckOut += motivationCheckOut!
//                }
//                DispatchQueue.main.async(execute: {
//                    self.lblPercentCheckIn.text = String(numberMotivationCheckIn * 100 / (arrMotivationCheckIn.count * 5)) + "%"
//                    self.lblPercentCheckOut.text = String(numberMotivationCheckOut * 100 / (arrMotivationCheckOut.count * 5)) + "%"
//                })
//            }else{
//                DispatchQueue.main.async(execute: {
//                    self.lblPercentCheckIn.text = String(0)
//                    self.lblPercentCheckOut.text = String(0)
//                })
//            }
            
        } catch {
            print(error)
        }
    }
    func setData(data: Data, member: AnyObject) {
    }
}
