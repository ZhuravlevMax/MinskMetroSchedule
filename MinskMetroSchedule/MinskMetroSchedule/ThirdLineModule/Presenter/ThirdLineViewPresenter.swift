//
//  ThirdLineViewPresenter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import Foundation
import UIKit

protocol ThirdLineViewPresenterProtocol: AnyObject {
    
}

class ThirdLineViewPresenter: ThirdLineViewPresenterProtocol {
    
    weak var view: ThirdLineViewProtocol?
    private(set) var router: ThirdLineRouterProtocol
    
    required init(view: ThirdLineViewProtocol, router: ThirdLineRouterProtocol) {
        self.view = view
        self.router = router
    }
    
}
