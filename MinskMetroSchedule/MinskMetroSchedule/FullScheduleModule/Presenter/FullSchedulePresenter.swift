//
//  WeekdayPresenter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 6.12.22.
//

import Foundation
import UIKit

protocol FullSchedulePresenterProtocol: AnyObject {
    
    func setNumberOfRow(stationName: String,
                        toStation: String,
                        timeSheetTableViewValue: UITableView,
                        line: String)
    
    func configureTimeSheetTableViewCell(indexPath: IndexPath,
                                         cell: TimeSheetTableViewCellProtocol,
                                         stationName: String,
                                         toStation: String,
                                         dayOfWeek: String,
                                         line: String)
}

class FullSchedulePresenter: FullSchedulePresenterProtocol {
    
    weak var view: FullScheduleViewControllerProtocol?
    
    required init(view: FullScheduleViewControllerProtocol) {
        self.view = view
    }
    
    func setNumberOfRow(stationName: String,
                        toStation: String,
                        timeSheetTableViewValue: UITableView,
                        line: String) {
        
        let dayOfWeek = "\(FireBaseCollectionsEnum.weekday)"
        guard let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allData)") as? [String:Any],
              let dayData = allData[dayOfWeek] as? [String:Any],
              let thirdLineStations = dayData[line] as? [String:Any],
              let direction = FireBaseFieldsEnum(rawValue: toStation),
              let station = thirdLineStations[stationName] as? [String:Any],
              let timeSheet = station["\(direction)"] as? [Int]
        else {return}
        
        let hoursArray = timeSheet.map {$0 / 3600}
        let hours = Array(Set(hoursArray)).sorted { $0 < $1 }
        view?.setNumberOfRow(rowNumber: hours.count)
        timeSheetTableViewValue.reloadData()
    }
    
    func configureTimeSheetTableViewCell(indexPath: IndexPath,
                                         cell: TimeSheetTableViewCellProtocol,
                                         stationName: String,
                                         toStation: String,
                                         dayOfWeek: String,
                                         line: String) {
        
        guard let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allData)") as? [String:Any],
              let dayOfWeekValue = DayTypeEnum(rawValue: dayOfWeek),
              let dayData = allData["\(dayOfWeekValue)"] as? [String:Any],
              let thirdLineStations = dayData[line] as? [String:Any],
              let direction = FireBaseFieldsEnum(rawValue: toStation),
              let stationNameValue = StationNamesEnum(rawValue: stationName),
              let station = thirdLineStations["\(stationNameValue)"] as? [String:Any],
              let timeSheet = station["\(direction)"] as? [Int]
        else {return}
        
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
        //print(minutesArray)
        
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
