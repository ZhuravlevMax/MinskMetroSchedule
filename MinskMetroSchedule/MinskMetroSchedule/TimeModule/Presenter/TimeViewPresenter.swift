//
//  TimeViewPresenter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import Foundation
import UIKit

protocol TimeViewPresenterProtocol: AnyObject {
    
    var timeViewControllerBackgroundColor: UIColor {get}
    
}

class TimeViewPresenter: TimeViewPresenterProtocol {
    
    var timeViewControllerBackgroundColor: UIColor = .white
    
    weak var view: TimeViewControllerProtocol?
    
    required init(view: TimeViewControllerProtocol) {
        self.view = view
    }
    
    
}
