//
//  DetailChart.swift
//  CheckInTime
//
//  Created by Dat Tran on 1/11/18.
//  Copyright © 2018 Dat Tran. All rights reserved.
//

import Foundation
import UIKit
import SwiftChart

class DetailChartController: UIViewController, ApiService{

    @IBOutlet weak var txtInputDateStart:       UITextField!
    @IBOutlet weak var txtInputDateEnd:         UITextField!
    @IBOutlet weak var btnDateStartCalendar:    UIButton!
    @IBOutlet weak var lblMotivation:           UILabel!
    @IBOutlet weak var btnDateEndCalendar:      UIButton!
    @IBOutlet weak var btnSearchDate:           UIButton!
    @IBOutlet weak var viewChart:               UIView!
    @IBOutlet weak var lblCheckOutAverage:      UILabel!
    @IBOutlet weak var lblCheckInAverage:       UILabel!
    
    var api                 = callApi()
    let datePickerStart     = UIDatePicker() // DatePicker for Start Date
    let datePickerEnd       = UIDatePicker() // DatePicker for Start Date
    
    var staff:      AnyObject! // staff for search chart
    var dateIn:     String! // Start Date for search
    var dateOut:    String! // End Date for search
    var staffId:    String! // staff id for search chart
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtInputDateStart.text      = dateIn
        self.txtInputDateEnd.text        = dateOut
        self.staffId                     = staff["_id"] as? String
        self.title                       = staff["name"] as? String
        self.initdatePicker()
        self.getStaffChart()
        self.lblMotivation.transform     = CGAffineTransform(rotationAngle: -.pi/2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // init DatePicker
    func initdatePicker() {
        datePickerStart.datePickerMode          = .date
        datePickerStart.backgroundColor         = UIColor.white
        datePickerStart.addTarget(self, action: #selector(datePickerStartOnChangeValue(_:)), for: UIControlEvents.valueChanged)
        txtInputDateStart.inputView = datePickerStart
        
        datePickerEnd.datePickerMode            = .date
        datePickerEnd.backgroundColor           = UIColor.white
        txtInputDateEnd.inputView               = datePickerEnd
        datePickerEnd.addTarget(self, action: #selector(datePickerEndOnChangeValue(_:)), for: UIControlEvents.valueChanged)
        // Adding Button ToolBar
        let toolbar                             = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolbar.barStyle                        = .default
        toolbar.tintColor                       = UIColor.blue
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneButton(_:)))
        toolbar.setItems([doneBtn], animated: true)
        txtInputDateStart.inputAccessoryView    = toolbar
        txtInputDateEnd.inputAccessoryView      = toolbar
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
    // "Done" button on DatePicket
    @objc func handleDoneButton(_ sender: UIButton) {
        txtInputDateStart.resignFirstResponder()
        txtInputDateEnd.resignFirstResponder()
    }
    
    @objc func datePickerStartOnChangeValue(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle     = .short
        dateFormatter.timeStyle     = .none
        dateFormatter.dateFormat    = "yyyy-MM-dd"
        txtInputDateStart.text      = dateFormatter.string(from: sender.date)
    }
    
    @objc func datePickerEndOnChangeValue(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle     = .short
        dateFormatter.timeStyle     = .none
        dateFormatter.dateFormat    = "yyyy-MM-dd"
        txtInputDateEnd.text        = dateFormatter.string(from: sender.date)
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
    // get staff chart with staff id
    func getStaffChart() {
        let urlMotivationWithStaff = URL(string: apiURL + "api/time-tracking?limit=all&dateStart=\(dateIn!)&dateEnd=\(dateOut!)&type=checkIn&staffId=\(staffId!)")
        guard let _ = urlMotivationWithStaff else {
            print("error")
            return
        }
        api.deletgate = self
        api.callApiChartStaff(url: urlMotivationWithStaff!)
    }
    // draw chart
    func setChartData(data: Data) {
        do {
            let json                    = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            let arrData                 = json!["data"]! as! NSArray
            var arrMotivationCheckIn    = [Double]()
            var arrMotivationCheckOut   = [Double]()
            var labels                  = [Double]()
            var labelsAsString          = [String]()
            if arrData.count != 0{
                for i in 0...arrData.count - 1{
                    let data                = arrData[i] as AnyObject
                    let motivationCheckIn   = data["motivationCheckIn"] as? Double
                    let motivationCheckOut  = data["motivationCheckOut"] as? Double
                    let motivationDateIn    = data["dateIn"] as? String
                    
                    arrMotivationCheckIn.append(motivationCheckIn!)
                    arrMotivationCheckOut.append(motivationCheckOut!)
                    let formater            = DateFormatter()
                    formater.dateFormat     = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
                    let dateIn              = formater.date(from: motivationDateIn!)
                    formater.dateFormat     = "yyyy-MM-dd"
                    labels.append(Double(i))
                    labelsAsString.append(formater.string(from: dateIn!))
                }
                DispatchQueue.main.async(execute: {
                    let minMotivationCheckIn    = self.findMin(arr: arrMotivationCheckIn)
                    let maxMotivationCheckIn    = self.findMax(arr: arrMotivationCheckIn)
                    let minMotivationCheckOut   = self.findMin(arr: arrMotivationCheckOut)
                    let maxMotivationCheckOut   = self.findMax(arr: arrMotivationCheckOut)
                    
                    if arrMotivationCheckIn.count != 0{
                        if minMotivationCheckIn == maxMotivationCheckIn {
                            let nameMotivation              = arrMotivation[Int(arrMotivationCheckIn[minMotivationCheckIn] - 1)]
                            let percentMotivation           = String(format: "%.2f", arguments: [arrMotivationCheckIn[minMotivationCheckIn] * 100 / 5])
                            self.lblCheckInAverage.text     = "\(nameMotivation) = \(percentMotivation)%"
                        }else{
                            var sumMotiCheckIn: Double  = 0
                            var countMinCheckIn         = 0
                            var countMaxCheckIn         = 0
                            for moti in arrMotivationCheckIn{
                                sumMotiCheckIn += moti
                                if moti == arrMotivationCheckIn[minMotivationCheckIn]{
                                    countMinCheckIn += 1
                                }
                                if moti == arrMotivationCheckIn[maxMotivationCheckIn]{
                                    countMaxCheckIn += 1
                                }
                            }
                            let nameMinMotivation           = arrMotivation[Int(arrMotivationCheckIn[minMotivationCheckIn] - 1)]
                            let percentMotivation           = String(format: "%.2f", arguments: [(sumMotiCheckIn) * 100 / (5 * Double(arrMotivationCheckIn.count))])
                            let nameMaxMotivation           = arrMotivation[Int(arrMotivationCheckIn[maxMotivationCheckIn] - 1)]
                            self.lblCheckInAverage.text     = "\(nameMinMotivation) < \(percentMotivation)% < \(nameMaxMotivation)"
                        }
                    }
                    
                    if arrMotivationCheckOut.count != 0{
                        if minMotivationCheckOut == maxMotivationCheckOut {
                            let nameMotivation:String
                            if arrMotivationCheckOut[minMotivationCheckOut] - 1 < 0{
                                nameMotivation              = "none"
                            }else{
                                nameMotivation              = arrMotivation[Int(arrMotivationCheckOut[minMotivationCheckOut] - 1)]
                            }
                            let percentMotivation           = String(format: "%.2f", arguments: [arrMotivationCheckOut[minMotivationCheckOut] * 100 / 5])
                            self.lblCheckOutAverage.text    = "\(nameMotivation) = \(percentMotivation)%"
                        }else{
                            var sumMotiCheckOut: Double = 0
                            for moti in arrMotivationCheckOut{
                                sumMotiCheckOut += moti
                            }
                            let nameMinMotivation           = arrMotivation[Int(arrMotivationCheckOut[minMotivationCheckOut] - 1)]
                            let percentMotivation           = String(format: "%.2f", arguments: [Double(sumMotiCheckOut) * 100 / (5 * Double(arrMotivationCheckOut.count))])
                            let nameMaxMotivation           = arrMotivation[Int(arrMotivationCheckOut[maxMotivationCheckOut] - 1)]
                            self.lblCheckOutAverage.text    = "\(nameMinMotivation) < \(percentMotivation)% < \(nameMaxMotivation)"
                        }
                    }
                    // set chart with data
                    let chart                   = Chart(frame: CGRect(x: 0, y: 0, width: self.viewChart.frame.size.width, height: self.viewChart.frame.size.height))
                    chart.maxY                  = 5
                    chart.maxX                  = Double(labelsAsString.count)
                    chart.minX                  = -0.1
                    chart.minY                  = 0
                    let checkIn                 = ChartSeries(arrMotivationCheckIn)
                    checkIn.color               = ChartColors.greenColor()
                    checkIn.area                = false
                    let checkOut                = ChartSeries(arrMotivationCheckOut)
                    checkOut.color              = ChartColors.cyanColor()
                    checkOut.area               = false
                    
                    chart.xLabelsFormatter      = { (labelIndex: Int, labelValue: Double) -> String in
                        return labelsAsString[labelIndex]
                    }
                    chart.xLabels               = labels
                    chart.xLabelsOrientation    = .vertical
                    chart.yLabels               = [1, 2, 3, 4, 5]
                    chart.add([checkIn, checkOut])
                    self.viewChart.addSubview(chart)
                    
                })
            }} catch {
                print(error)
        }
    }
    func setData(data: Data) {
    }
    func callBackAfterDelete(message: String) {}
    // find min data in array
    func findMin(arr: [Double]) -> Int {
        var min = arr[0]
        var indexMin = 0
        for i in 0...arr.count - 1{
            if min > arr[i] && arr[i] != 0 || min == 0{
                min = arr[i]
                indexMin = i
            }
        }
        return indexMin
    }
    // find max data in array
    func findMax(arr: [Double]) -> Int {
        var max = arr[0]
        var indexMax = 0
        for i in 0...arr.count - 1{
            if max < arr[i]{
                max = arr[i]
                indexMax = i
            }
        }
        return indexMax
    }
}
