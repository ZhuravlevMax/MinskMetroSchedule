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
        let firstLineViewController = UINavigationController(rootViewController: builder.createFirstLineModule(title: "Московская", image: UIImage(named: "1tint")))
        let secondLineViewController = UINavigationController(rootViewController: builder.createSecondLineModule(title: "Автозаводская", image: UIImage(named: "2tint")))
        let thirdLineViewController = UINavigationController(rootViewController: builder.createThirdLineModule(title: "Зеленолужская", image: UIImage(named: "3tint")))
        
        
    
        let currentDay = Int(Date().timeIntervalSince1970).decoderDt(format: "EEEE")
        UserDefaults.standard.set(currentDay, forKey: "\(UserDefaultsKeysEnum.currentDay)")
        switch currentDay {
        case "Saturday", "Sunday":
            UserDefaults.standard.set("weekend", forKey: "\(UserDefaultsKeysEnum.dayOfWeek)")
        case "Friday":
            UserDefaults.standard.set("friday", forKey: "\(UserDefaultsKeysEnum.dayOfWeek)")
        default:
            UserDefaults.standard.set("weekday", forKey: "\(UserDefaultsKeysEnum.dayOfWeek)")
        }
        
 
        tabBarController.viewControllers = [firstLineViewController, secondLineViewController, thirdLineViewController]
    }
    
    
}
