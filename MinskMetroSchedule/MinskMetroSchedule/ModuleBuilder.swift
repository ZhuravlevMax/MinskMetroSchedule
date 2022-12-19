//
//  ModuleBuilder.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import Foundation
import UIKit

protocol BuilderProtocol {
//    func createFirstLineModule(title: String, image: UIImage?) -> UIViewController
//    func createSecondLineModule(title: String, image: UIImage?) -> UIViewController
    func createThirdLineModule(title: String, image: UIImage?) -> UIViewController
    func createTimeModule(fromStationName: String,
                          toStationName: String) -> UIViewController
    func createFullScheduleModule(fromStationName: String,
                             toStationName: String,
                             dayTypeValue: String) -> UIViewController
}

class ModuleBuilder: BuilderProtocol {
    
    
//    func createFirstLineModule(title: String, image: UIImage?) -> UIViewController {
//        <#code#>
//    }
//    
//    func createSecondLineModule(title: String, image: UIImage?) -> UIViewController {
//        <#code#>
//    }
    
    func createTimeModule(fromStationName: String,
                          toStationName: String) -> UIViewController {
        let view = TimeViewController()
        view.setItems(fromStationName: fromStationName,
                      toStationName: toStationName)
        
        let router = TimeRouter(builder: self, viewController: view)
        let presenter = TimeViewPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    func createThirdLineModule(title: String, image: UIImage?) -> UIViewController {
        let view = ThirdLineViewController()
        view.tabBarItem.title = title
        view.tabBarItem.image = image
        let router = ThirdLineRouter(builder: self, viewController: view)
        let presenter = ThirdLineViewPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    func createFullScheduleModule(fromStationName: String,
                             toStationName: String,
                             dayTypeValue: String) -> UIViewController {
        let view = FullScheduleViewController()
        view.setItems(fromStationName: fromStationName, toStationName: toStationName, dayTypeValue: dayTypeValue)
        let presenter = FullSchedulePresenter(view: view)
        view.presenter = presenter
        return view
    }
    
}
