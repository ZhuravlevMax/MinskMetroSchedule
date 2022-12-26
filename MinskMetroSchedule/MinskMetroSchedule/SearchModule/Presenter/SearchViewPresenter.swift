//
//  SearchViewPresenter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 26.12.22.
//

import Foundation
import UIKit

protocol SearchViewPresenterProtocol: AnyObject {
    
}

class SearchViewPresenter: SearchViewPresenterProtocol {
    
    weak var view: SearchViewProtocol?
    private(set) var router: SearchRouterProtocol
    
    required init(view: SearchViewProtocol,
                  router: SearchRouterProtocol) {
        self.view = view
        self.router = router
    }
}
