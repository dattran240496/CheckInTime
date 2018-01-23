//
//  UIViewController.swift
//  CheckInTime
//
//  Created by Dat Tran on 1/23/18.
//  Copyright © 2018 Dat Tran. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
extension UIViewController{
    func setupSideMenu(storyBoardName: String, navigationControllerIndetifier: String, transition : SideMenuManager.MenuPresentMode) {
        SideMenuManager.default.menuLeftNavigationController = self.storyboard?.instantiateViewController(withIdentifier: navigationControllerIndetifier) as? UISideMenuNavigationController
        SideMenuManager.default.menuRightNavigationController = nil
        SideMenuManager.default.menuPresentMode = transition
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.white
        SideMenuManager.default.menuWidth = self.view.frame.size.width / 3
    }
}
