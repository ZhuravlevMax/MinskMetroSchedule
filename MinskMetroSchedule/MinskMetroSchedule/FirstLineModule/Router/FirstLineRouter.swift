//
//  FirstLineRouter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 23.12.22.
//

import Foundation
import UIKit

protocol FirstLineRouterProtocol: BaseModulRouterProtocol {
    func openTimeVC(fromStationName: String,
                    toStationName: String,
                    navColor: UIColor,
                    navTextColor: UIColor)
}

class FirstLineRouter: FirstLineRouterProtocol {
    
    var builder: ModuleBuilder?
    var viewController: UIViewController?
    
    init(builder: ModuleBuilder, viewController: UIViewController) {
        self.builder =  builder
        self.viewController = viewController
    }
    
    func openTimeVC(fromStationName: String,
                    toStationName: String,
                    navColor: UIColor,
                    navTextColor: UIColor) {
        
        guard let timeModule = builder?.createTimeModule(fromStationName: fromStationName,
                                                         toStationName: toStationName,
                                                         navColor: navColor,
                                                         navTextColor: navTextColor),
              let timeVC = viewController?.navigationController else {return}
        
        timeVC.pushViewController(timeModule, animated: true)
    }
}
