//
//  ThirdLineRouter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import Foundation
import UIKit

protocol ThirdLineRouterProtocol: BaseModulRouterProtocol {
    
}

class ThirdLineRouter: ThirdLineRouterProtocol {
    
    var builder: ModuleBuilder?
    var viewController: UIViewController?
    
    init(builder: ModuleBuilder, viewController: UIViewController) {
        self.builder =  builder
        self.viewController = viewController
    }
}
