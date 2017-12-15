//
//  AddNewMemController.swift
//  CheckInTime
//
//  Created by Dat Tran on 12/11/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class AddNewMemController: UIViewController{
    
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var txtInputName: UITextField!
    @IBOutlet weak var txtInputEmail: UITextField!
    @IBOutlet weak var btnAddNow: UIButton!
    var memberName: String!
    var memberEmail: String!
    var memberAvatar: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAddNow.layer.borderWidth = 2
        btnAddNow.layer.borderColor = UIColor.white.cgColor
        btnAddNow.layer.cornerRadius = 30
    }
    override func viewDidAppear(_ animated: Bool) {
        btnCamera.layer.cornerRadius = btnCamera.frame.size.width / 2
        btnCamera.layer.masksToBounds = true
        btnCamera.layer.borderWidth = 1
        btnCamera.layer.borderColor = UIColor.orange.cgColor
        //btnCamera.imageView?.contentMode = .scaleToFill
        if (memberEmail != nil) && (memberName != nil) && (memberAvatar != nil) {
            txtInputName.text = memberName
            txtInputEmail.text = memberEmail
            btnAddNow.setTitle("edit member", for: .normal)
            let imgURL = URL(string: apiURL + memberAvatar!)
            let session = URLSession.shared
            session.dataTask(with: imgURL!) { (data, response, error) in
                //if there is any error
                if let e = error {
                    //displaying the message
                    print("Error Occurred: \(e)")
                } else {
                    //checking if the response contains an image
                    if let imageData = data {
                        //getting the image
                        let image = UIImage(data: imageData)
                        //displaying the image
                        DispatchQueue.main.async(execute: {
                            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.btnCamera.frame.size.width, height: self.btnCamera.frame.size.height))
                            imgView.image = image
                            self.btnCamera.addSubview(imgView)
                        })
                    } else {
                        print("Image file is currupted")
                    }
                }
                }.resume()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @IBAction func onAddNowAction(_ sender: Any) {
    }
    @IBAction func onTakePictureAction(_ sender: Any) {
        self.takePhoto()
    }
    
}

extension AddNewMemController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrlView.setContentOffset(CGPoint(x: 0, y: 300), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrlView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension AddNewMemController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = .camera
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickerImg = info[UIImagePickerControllerOriginalImage] as? UIImage{
            //btnCamera.imageView?.contentMode = .scaleAspectFit
            memberAvatar = nil
            btnCamera.setImage(pickerImg, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
