//
//  ThirdLineRouter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import Foundation
import UIKit

protocol ThirdLineRouterProtocol: BaseModulRouterProtocol {
    func openTimeVC(fromStationName: String,
                    toStationName: String,
                    nextTimeValue: String)
}

class ThirdLineRouter: ThirdLineRouterProtocol {
    
    var builder: ModuleBuilder?
    var viewController: UIViewController?
    
    init(builder: ModuleBuilder, viewController: UIViewController) {
        self.builder =  builder
        self.viewController = viewController
    }
    
    func openTimeVC(fromStationName: String,
                    toStationName: String,
                    nextTimeValue: String) {
        guard let timeModule = builder?.createTimeModule(fromStationName: fromStationName,
                                                         toStationName: toStationName,
                                                         nextTimeValue: nextTimeValue),
              let timeVC = viewController?.navigationController else {return}
        
        timeVC.pushViewController(timeModule, animated: true)
    }
}
