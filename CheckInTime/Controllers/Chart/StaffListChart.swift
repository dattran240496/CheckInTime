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
    @IBOutlet weak var collectionViewStaff: UICollectionView!
    
    let datePickerStart = UIDatePicker()
    let datePickerEnd = UIDatePicker()
    var dataMembers = NSArray()
    var dateIn = String()
    var dateOut = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initdatePicker()
        let classNib = UINib(nibName: "ChartCell", bundle: nil)
        self.collectionViewStaff?.register(classNib, forCellWithReuseIdentifier: "Cell")
        collectionViewStaff.dataSource = self
        collectionViewStaff.delegate = self
        txtInputDateStart.text = "2017-12-10"
        txtInputDateEnd.text = "2017-12-17"
        dateIn = txtInputDateStart.text ?? ""
        dateOut = txtInputDateEnd.text ?? ""
        self.getDataMembers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionViewStaff.reloadData()
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
    @IBAction func onDateStartArrowAction(_ sender: Any) {
        //datePicker.addTarget(self, action: #selector(datePickerOnChangeValue(_:)), for: UIControlEvents.valueChanged)
    }
    @IBAction func onDateEndCalendarAction(_ sender: Any) {
       self.txtInputDateEnd.becomeFirstResponder()
    }
    @IBAction func onDateEndArrowAction(_ sender: Any) {
        //datePicker.addTarget(self, action: #selector(datePickerOnChangeValue(_:)), for: UIControlEvents.valueChanged)
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
    
    @IBAction func onSearchChartAction(_ sender: Any) {
        self.dateIn = self.txtInputDateStart.text ?? ""
        self.dateOut = self.txtInputDateEnd.text ?? ""
        self.collectionViewStaff.reloadData()
        txtInputDateStart.resignFirstResponder()
        txtInputDateEnd.resignFirstResponder()
    }
    
    
    func getDataMembers() {
        guard let url = URL(string: apiURL + "api/staff")  else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Hello! I am mobile", forHTTPHeaderField: "x-access-token-mobile")
        
        let session = URLSession.shared
        session.dataTask(with: request){ (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    let data = json!["data"]! as! NSArray
                    self.dataMembers = data
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
}


extension StaffListChart: UICollectionViewDelegate{
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        self.view.layoutIfNeeded()
        self.view.setNeedsDisplay()
    }
}


extension StaffListChart : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 380)
    }
}


extension StaffListChart: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewStaff.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ChartCell
        cell.setValueForCell(member: dataMembers[indexPath.row] as AnyObject, dateIn: self.dateIn, dateOut: self.dateOut)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailChartController") as! DetailChartController
        vc.staff = dataMembers[indexPath.row] as AnyObject
        vc.dateIn = self.txtInputDateStart.text
        vc.dateOut = self.txtInputDateEnd.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
}
