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
    func configureTimeSheetTableViewCell(indexPath: IndexPath, cell: TimeSheetTableViewCellProtocol)
    
}

class TimeViewPresenter: TimeViewPresenterProtocol {
    
    var timeViewControllerBackgroundColor: UIColor = .white
    
    weak var view: TimeViewControllerProtocol?
    
    
    required init(view: TimeViewControllerProtocol) {
        self.view = view
    }
    
    func setNextTime(toStationName: String, stationName: String ) {
        
        guard let direction = FireBaseFieldsEnum(rawValue: toStationName),
              let timeSheet: [Int] = UserDefaults.standard.object(forKey: "\(stationName)\(direction)") as? [Int] else {return}
        
        var currentTimeFromStartDay = Int(Date().timeIntervalSince1970) - Int(Calendar.current.startOfDay(for: Date()).timeIntervalSince1970)

        // Здесь добавил условие, чтобы исправить баг со временем, когда пользователь смотрит расписание после 00:00
        if currentTimeFromStartDay < 1500 {
            currentTimeFromStartDay += 86400
        }

        let nextTime = timeSheet.first { $0 > currentTimeFromStartDay }
        
        guard var nextTime else {return}
        
        //Здесь условие, для того чтобы у пользователя отображалось время не 24:00, а 00:00
        if currentTimeFromStartDay > 86400 {
            nextTime -= 86400
        }
        
        let formattedString = nextTime.decoderDt(format: "HH:mm")
        self.view?.setNextTimeLabel(nextTime: formattedString)
        
    }
    
    func configureTimeSheetTableViewCell(indexPath: IndexPath, cell: TimeSheetTableViewCellProtocol) {
        
    }
    
}
