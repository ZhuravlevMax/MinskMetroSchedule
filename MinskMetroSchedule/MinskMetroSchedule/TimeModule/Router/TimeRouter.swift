//
//  TimeRouter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 6.12.22.
//

import Foundation
import UIKit

protocol TimeRouterProtocol: BaseModulRouterProtocol {
    
    func openWeekdayVC(fromStationName: String,
                       toStationName: String,
                       dayTypeValue: String)
    
}

class TimeRouter: TimeRouterProtocol {
    
    var builder: ModuleBuilder?
    var viewController: UIViewController?
    
    init(builder: ModuleBuilder, viewController: UIViewController) {
        self.builder =  builder
        self.viewController = viewController
    }
    
    func openWeekdayVC(fromStationName: String,
                       toStationName: String,
                       dayTypeValue: String) {
        guard let weekdayModule = builder?.createWeekdayModule(fromStationName: fromStationName,
                                                               toStationName: toStationName,
                                                               dayTypeValue: dayTypeValue) else {return}
        
        guard let weekdayVC = viewController else {return}
        
        weekdayVC.present(weekdayModule, animated: true)
        
//              let timeVC = viewController?.navigationController else {return}
//
//        timeVC.pushViewController(timeModule, animated: true)
    }
}
