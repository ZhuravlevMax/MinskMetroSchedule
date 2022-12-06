//
//  WeekdayPresenter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 6.12.22.
//

import Foundation
import UIKit

protocol WeekdayPresenterProtocol: AnyObject {
    
}

class WeekdayPresenter: WeekdayPresenterProtocol {
    
    weak var view: WeekdayViewControllerProtocol?
    
    required init(view: WeekdayViewControllerProtocol) {
        self.view = view
    }
}
