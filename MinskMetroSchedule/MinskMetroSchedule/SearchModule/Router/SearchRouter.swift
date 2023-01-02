//
//  SearhRouter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 26.12.22.
//

import Foundation
import UIKit

protocol SearchRouterProtocol: BaseModulRouterProtocol {

    func openTimeVC(fromStationName: String,
                    toStationName: String,
                    navColor: UIColor,
                    navTextColor: UIColor,
                    line: String)
}

class SearchRouter: SearchRouterProtocol {
    
    var builder: ModuleBuilder?
    var viewController: UIViewController?
    
    init(builder: ModuleBuilder, viewController: UIViewController) {
        self.builder = builder
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
                                                         line: line),
              let timeVC = viewController?.navigationController else {return}
        
        timeVC.pushViewController(timeModule, animated: true)
    }
}
