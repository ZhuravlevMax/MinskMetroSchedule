//
//  WeekdayPresenter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 6.12.22.
//

import Foundation
import UIKit

protocol WeekdayPresenterProtocol: AnyObject {
    
    func setNumberOfRow(stationName: String,
                        toStation: String,
                        timeSheetTableViewValue: UITableView)
    
    func configureTimeSheetTableViewCell(indexPath: IndexPath,
                                         cell: TimeSheetTableViewCellProtocol,
                                         stationName: String,
                                         toStation: String)
    
}

class WeekdayPresenter: WeekdayPresenterProtocol {
    
    weak var view: WeekdayViewControllerProtocol?
    
    required init(view: WeekdayViewControllerProtocol) {
        self.view = view
    }
    
    func setNumberOfRow(stationName: String,
                        toStation: String,
                        timeSheetTableViewValue: UITableView) {
        guard let direction = FireBaseFieldsEnum(rawValue: toStation),
              let timeSheet: [Int] = UserDefaults.standard.object(forKey: "\(stationName)\(direction)") as? [Int] else {return}
        
        //var currentTimeFromStartDay = Int(Date().timeIntervalSince1970) - Int(Calendar.current.startOfDay(for: Date()).timeIntervalSince1970)
        
        //let hoursArrayNext = timeSheet.filter {$0 > currentTimeFromStartDay}
        
        let hoursArray = timeSheet.map {$0 / 3600}
        var hours = Array(Set(hoursArray)).sorted { $0 < $1 }
        view?.setNumberOfRow(rowNumber: hours.count)
        timeSheetTableViewValue.reloadData()
    }
    
    func configureTimeSheetTableViewCell(indexPath: IndexPath,
                                         cell: TimeSheetTableViewCellProtocol,
                                         stationName: String,
                                         toStation: String) {
        guard let direction = FireBaseFieldsEnum(rawValue: toStation),
              let stationNameValue = StationNamesEnum(rawValue: stationName),
              let timeSheet: [Int] = UserDefaults.standard.object(forKey: "\(stationNameValue)\(direction)") as? [Int] else {return}
        
        //var currentTimeFromStartDay = Int(Date().timeIntervalSince1970) - Int(Calendar.current.startOfDay(for: Date()).timeIntervalSince1970)
        
        //let hoursArrayNext = timeSheet.filter {$0 > currentTimeFromStartDay}
        let hoursArray = timeSheet.map {$0 / 3600}
        let hours = Array(Set(hoursArray)).sorted { $0 < $1 }
        var hourModify: [Int] = []
        
        for hour in hours {
            
            if hour > 23 {
                let newHour = hour - 24
                hourModify.append(newHour)
            } else {
                hourModify.append(hour)
            }
        }
        
        //let hourModifyString = hourModify.map { String($0) }
        let minutesArray = timeSheet.map {($0 % 3600) / 60}
        print(minutesArray)
        
        var minutesAll: [[Int]] = []
        
        for _ in hoursArray {
            var minutes = timeSheet.filter { return $0 / 3600 == hours[indexPath.row]}
            minutes = minutes.map {($0 % 3600) / 60}
            
            minutesAll.append(minutes)
        }
        
        let minutesAllString = minutesAll[indexPath.row].map { (String(format: "%02d", arguments: [$0]))}
        let minutesString = minutesAllString.joined(separator:" ")
        
        cell.configureCell(hourValue: "\(String(format: "%02d", arguments: [hourModify[indexPath.row]])):",
                           minutesValue: minutesString)
        
    }
}
