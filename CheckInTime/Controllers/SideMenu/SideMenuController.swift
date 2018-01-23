//
//  SideMenuController.swift
//  CheckInTime
//
//  Created by Dat Tran on 1/23/18.
//  Copyright © 2018 Dat Tran. All rights reserved.
//

import Foundation
import UIKit
class SideMenuController: UIViewController {
    @IBOutlet weak var collectionViewSideMenu: UICollectionView!
    let arrayOptionName = [
        "Check In Time",
        "Clean Time",
        "Staff"
    ]
    let arrayOptionImage = [
        "checkInTime.png",
        "cleaning.jpg",
        "staff-icon.png"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let classNib    = UINib(nibName: "SideMenuCell", bundle: nil)
        self.collectionViewSideMenu?.register(classNib, forCellWithReuseIdentifier: "Cell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

// MARK: - Implement UICollectionViewDelegate
extension SideMenuController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 80)
    }
}
extension SideMenuController: UICollectionViewDelegate{
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        self.view.layoutIfNeeded()
        self.view.setNeedsDisplay()
    }
}
extension SideMenuController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayOptionName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SideMenuCell
        cell.setSideMenuCell(imgName: arrayOptionImage[indexPath.row], lblOption: arrayOptionName[indexPath.row])
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 20, y: cell.frame.size.height - 2,width: cell.frame.width - 40,height: 2)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        cell.layer.addSublayer(bottomLine)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckInTimeController") as! CheckInTimeController
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CleanTimeController") as! CleanTimeController
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemberController") as! MemberController
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
