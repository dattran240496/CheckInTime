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
        let imgAvatar = UIImageView(image: UIImage(named: "imgAvatar-temp.png"))
        if self.txtInputName.text != "" && self.txtInputEmail.text != "" {
            //let imgData: Data = UIImagePNGRepresentation(imgAvatar.image!)!
            //let encodeAvatar = imgData.base64EncodedString(options: NSData.Base64EncodingOptions())
            //            let session = URLSession(configuration: URLSessionConfiguration.default)
            //            guard let urlAvatar = URL(string: apiURL + "photo") else { return }
            //            var requestAvatar = URLRequest(url: urlAvatar)
            //            requestAvatar.httpMethod = "POST"
            //            requestAvatar.addValue("Hello! I am mobile", forHTTPHeaderField: "x-access-token-mobile")
            //            requestAvatar.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //            requestAvatar.addValue("application/json", forHTTPHeaderField: "Accept")
            //            requestAvatar.httpBody = UIImagePNGRepresentation(imgAvatar.image!)
            //            let dataTask = session.dataTask(with: requestAvatar){ (data, response, error) in
            //                if let error = error {
            //                    print("Something went wrong: \(error)")
            //                }
            //                if let response = response {
            //                    print("Response: \n \(response)")
            //                }
            //            }
            //            dataTask.resume()
            
            guard let base64String = UIImagePNGRepresentation((imgAvatar.image?.resized(toWidth: 300)!)!)?.base64EncodedString() else{
                return
            }
            print(base64String)
            print("data:image/png;base64," + base64String)
            guard let url = URL(string: apiURL + "api/staff")  else { return }
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.addValue("Hello! I am mobile", forHTTPHeaderField: "x-access-token-mobile")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let param :[String: Any] = [
                    "name": self.txtInputName.text!,
                    "email": self.txtInputEmail.text!
            ]
            
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options: [])
            }catch{print("error")}
            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                guard let _ = data, error == nil else{
                    return
                }
                if let response = response {
                    print("Response: \n \(response)")
                }
                let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(strData ?? "")
                print("success")
            }
            task.resume()
        }
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
