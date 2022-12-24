//
//  TabBarViewController.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //tabBar.tintColor = UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonColor)")
        tabBar.unselectedItemTintColor = .black
    }
}
