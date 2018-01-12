//
//  API.swift
//  CheckInTime
//
//  Created by Dat Tran on 1/11/18.
//  Copyright © 2018 Dat Tran. All rights reserved.
//

import Foundation
import UIKit
class callApi{
    weak var deletgate: ApiService?
    func callApi(url: URL,member: AnyObject){
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
            } else {
                DispatchQueue.main.async(execute: {
                    if let  _ = data{
                        self.deletgate?.setData(data: data! , member: member )
                    }
                })
            }
            }.resume()
    }
    func callApiChartStaff(url: URL) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Hello! I am mobile", forHTTPHeaderField: "x-access-token-mobile")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
            } else {
                if let  _ = data{
                    self.deletgate?.setChartData(data: data!)
                }
            }
            }.resume()
    }
}
