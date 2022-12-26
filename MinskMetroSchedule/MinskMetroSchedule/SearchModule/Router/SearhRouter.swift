//
//  SearhRouter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 26.12.22.
//

import Foundation
import UIKit

protocol SearchRouterProtocol: BaseModulRouterProtocol {

}

class SearchRouter: SearchRouterProtocol {
    
    var builder: ModuleBuilder?
    var viewController: UIViewController?
    
    init(builder: ModuleBuilder, viewController: UIViewController) {
        self.builder = builder
        self.viewController = viewController
    }
}
