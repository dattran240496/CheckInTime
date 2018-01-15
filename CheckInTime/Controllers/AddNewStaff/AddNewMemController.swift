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
    var memberName: String! // staff name if edit staff
    var memberEmail: String! // staff email if edit staff
    var memberAvatar: String! // staff avatar if edit staff
    var memberImage: UIImage! // staff avatar if add new staff
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAddNow.layer.borderWidth         = 2
        btnAddNow.layer.borderColor         = UIColor.white.cgColor
        btnAddNow.layer.cornerRadius        = 30
    }
    override func viewDidAppear(_ animated: Bool) {
        btnCamera.layer.cornerRadius        = btnCamera.frame.size.width / 2
        btnCamera.layer.masksToBounds       = true
        btnCamera.layer.borderWidth         = 1
        btnCamera.layer.borderColor         = UIColor.orange.cgColor
        if (memberEmail != nil) && (memberName != nil) && (memberAvatar != nil) { // if staff name and staff email and staff avatar not equal nil => edit staff
            txtInputName.text       = memberName
            txtInputEmail.text      = memberEmail
            btnAddNow.setTitle("edit member", for: .normal) //
            let imgURL              = URL(string: apiURL + memberAvatar!)
            let session             = URLSession.shared
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
        if self.txtInputName.text != "" && self.txtInputEmail.text != "" && self.memberImage != nil {
//            let imgAvatar = UIImageView(image: UIImage(named: "imgAvatar-temp.png"))
//            guard let base64String = UIImagePNGRepresentation((memberImage?.resized(toWidth: 300)!)!)?.base64EncodedString() else{
//                return
//            }
//            let data                    = "data:image/png;base64," + base64String
            
            guard let url               = URL(string: apiURL + "api/staff")  else { return }
            var request                 = URLRequest(url: url)
            let boundary                = "Boundary-\(UUID().uuidString)"
            request.httpMethod          = "POST"
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.addValue("Hello! I am mobile", forHTTPHeaderField: "x-access-token-mobile")
            let param :[String: Any]    = [
                "name": self.txtInputName.text!,
                "email": self.txtInputEmail.text!,
                ]
            request.httpBody = createBody(parameters: param, boundary: boundary, data: UIImageJPEGRepresentation(memberImage!, 0.7)!, mimeType: "uploads/jpg", filename: "uploads/.jpg")
            let task = URLSession.shared.dataTask(with: request){ data, response, error in
                guard let _ = data, error == nil else{
                    return
                }
                if let response = response {
                    print("Response: \n \(response)")
                }
                let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(strData ?? "")
            }
            task.resume()
        }
    }
    
    @IBAction func onTakePictureAction(_ sender: Any) {
        self.takePhoto()
    }
    // create body for add new staff
    func createBody(parameters: [String: Any],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        return body as Data
    }

}


// MARK: - implement TextField
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

// MARK: - implement ImagePickerController
extension AddNewMemController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imgPicker           = UIImagePickerController()
            imgPicker.delegate      = self
            imgPicker.sourceType    = .camera
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickerImg = info[UIImagePickerControllerOriginalImage] as? UIImage{
            //btnCamera.imageView?.contentMode = .scaleAspectFit
            memberAvatar    = nil
            memberImage     = pickerImg
            btnCamera.setImage(pickerImg, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
