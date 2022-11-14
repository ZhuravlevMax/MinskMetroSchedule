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
    func downloadAllData()
    
}

class TabBarControllerRouter: ViewsRouterProtocol {
    
    var tabBarController: UITabBarController?
    var builder: BuilderProtocol?
    
    init(tabBarController: UITabBarController, builder: BuilderProtocol) {
        self.tabBarController = tabBarController
        self.builder = builder
    }
    
    func downloadAllData() {
        FireBaseManager.shared.getTimeSheet(stationName: "\(StationNamesEnum.kovalskaya)", direction: "\(FireBaseFieldsEnum.toUbileynayaTimeSheet)") { timeSheetArray in
            UserDefaults.standard.set(timeSheetArray, forKey: "\(UserDefaultsKeysEnum.kovalskayatoUbileynayaTimeSheet)")
            print(UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.kovalskayatoUbileynayaTimeSheet)"))
        }
        
        FireBaseManager.shared.getTimeSheet(stationName: "\(StationNamesEnum.vokzalnaya)", direction: "\(FireBaseFieldsEnum.toKovalskayaTimeSheet)") { timeSheetArray in
            UserDefaults.standard.set(timeSheetArray, forKey: "\(UserDefaultsKeysEnum.vokzalnayatoKovalskayaTimeSheet)")
        }
        
        FireBaseManager.shared.getTimeSheet(stationName: "\(StationNamesEnum.vokzalnaya)", direction: "\(FireBaseFieldsEnum.toUbileynayaTimeSheet)") { timeSheetArray in
            UserDefaults.standard.set(timeSheetArray, forKey: "\(UserDefaultsKeysEnum.vokzalnayatoUbileynayaTimeSheet)")
        }
        
        FireBaseManager.shared.getTimeSheet(stationName: "\(StationNamesEnum.bogushevicha)", direction: "\(FireBaseFieldsEnum.toKovalskayaTimeSheet)") { timeSheetArray in
            UserDefaults.standard.set(timeSheetArray, forKey: "\(UserDefaultsKeysEnum.bogushevichatoKovalskayaTimeSheet)")
        }
        
        FireBaseManager.shared.getTimeSheet(stationName: "\(StationNamesEnum.bogushevicha)", direction: "\(FireBaseFieldsEnum.toUbileynayaTimeSheet)") { timeSheetArray in
            UserDefaults.standard.set(timeSheetArray, forKey: "\(UserDefaultsKeysEnum.bogushevichatoUbileynayaTimeSheet)")
        }
        
        FireBaseManager.shared.getTimeSheet(stationName: "\(StationNamesEnum.ubileynaya)", direction: "\(FireBaseFieldsEnum.toKovalskayaTimeSheet)") { timeSheetArray in
            UserDefaults.standard.set(timeSheetArray, forKey: "\(UserDefaultsKeysEnum.ubileynayatoKovalskayaTimeSheet)")
            print(UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.ubileynayatoKovalskayaTimeSheet)"))
        }
        
    }
    
    func initViewControllers() {
        guard let builder = builder, let tabBarController = tabBarController else {return}
        let thirdLineViewController = UINavigationController(rootViewController: builder.createThirdLineModule(title: "3 Линия", image: UIImage(systemName: "m.circle")))
        
        tabBarController.viewControllers = [thirdLineViewController]
    }
    
    
}
