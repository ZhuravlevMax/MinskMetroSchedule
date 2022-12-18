//
//  TabBarViewControllerRouter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import Foundation
import UIKit

protocol BaseTabBarContollerRouter {
    
    var tabBarController: UITabBarController? {get set}
    var builder: BuilderProtocol? {get set}
    
}

protocol ViewsRouterProtocol: BaseTabBarContollerRouter {
    
    func initViewControllers()
    //func downloadAllData()
    
}

class TabBarControllerRouter: ViewsRouterProtocol {
    
    var tabBarController: UITabBarController?
    var builder: BuilderProtocol?
    
    init(tabBarController: UITabBarController, builder: BuilderProtocol) {
        self.tabBarController = tabBarController
        self.builder = builder
    }
    
    func initViewControllers() {
        guard let builder = builder, let tabBarController = tabBarController else {return}
        let thirdLineViewController = UINavigationController(rootViewController: builder.createThirdLineModule(title: "3 Линия", image: UIImage(systemName: "m.circle")))
    
        switch Int(Date().timeIntervalSince1970).decoderDt(format: "EEEE") {
        case "Saturday", "Sunday":
            UserDefaults.standard.set("timeSheetWeekday", forKey: "\(UserDefaultsKeysEnum.dayOfWeek)")
        default:
            UserDefaults.standard.set("stations", forKey: "\(UserDefaultsKeysEnum.dayOfWeek)")
        }

        tabBarController.viewControllers = [thirdLineViewController]
    }
    
    
}
