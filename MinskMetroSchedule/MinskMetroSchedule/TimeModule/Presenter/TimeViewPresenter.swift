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
    
    func setNextTime(toStationName: String, stationName: String ) {
        guard let direction = FireBaseFieldsEnum(rawValue: toStationName) else {return}
        let directionString = "\(direction)"

        FireBaseManager.shared.getTimeSheet(stationName: stationName,
                                            direction: directionString) { [weak self] timeSheet in

            guard let self else {return}
            let currentTimeFromStartDay = Int(Date().timeIntervalSince1970) - Int(Calendar.current.startOfDay(for: Date()).timeIntervalSince1970)
            
            var nextTime = timeSheet.first { $0 > currentTimeFromStartDay }
            
            guard var nextTime else {return}
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            
            let formattedString = formatter.string(from: TimeInterval(nextTime))
            guard let formattedString else {return}
    
            self.view?.setNextTimeLabel(nextTime: formattedString)
            
        }
        
    }
    
    
}
