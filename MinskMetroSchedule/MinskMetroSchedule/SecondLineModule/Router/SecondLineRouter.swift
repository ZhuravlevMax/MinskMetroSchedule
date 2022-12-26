//
//  ThirdLineRouter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import Foundation
import UIKit

protocol SecondLineRouterProtocol: BaseModulRouterProtocol {
    func openTimeVC(fromStationName: String,
                    toStationName: String,
                    navColor: UIColor,
                    navTextColor: UIColor,
                    line: String)
}

class SecondLineRouter: SecondLineRouterProtocol {
    
    var builder: ModuleBuilder?
    var viewController: UIViewController?
    
    init(builder: ModuleBuilder, viewController: UIViewController) {
        self.builder =  builder
        self.viewController = viewController
    }
    
    func openTimeVC(fromStationName: String,
                    toStationName: String,
                    navColor: UIColor,
                    navTextColor: UIColor,
                    line: String) {
        guard let timeModule = builder?.createTimeModule(fromStationName: fromStationName,
                                                         toStationName: toStationName,
                                                         navColor: navColor,
                                                         navTextColor: navTextColor,
                                                         line: line ),
              let timeVC = viewController?.navigationController else {return}
        
        timeVC.pushViewController(timeModule, animated: true)
    }
}
