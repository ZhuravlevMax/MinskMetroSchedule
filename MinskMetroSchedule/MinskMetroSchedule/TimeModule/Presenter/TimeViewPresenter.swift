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
    func configureTimeSheetTableViewCell(indexPath: IndexPath,
                                         cell: TimeSheetTableViewCellProtocol,
                                         stationName: String,
                                         toStation: String)
    func setNumberOfRow(stationName: String,
                        toStation: String,
                        timeSheetTableViewValue: UITableView)
    
    func openWeekdayVC(fromStationName: String,
                       toStationName: String,
                       dayTypeValue: DayTypeEnum)
    func checkDayOfWeek()
}

class TimeViewPresenter: TimeViewPresenterProtocol {
    
    var timeViewControllerBackgroundColor: UIColor = .white
    
    weak var view: TimeViewControllerProtocol?
    private(set) var router: TimeRouterProtocol
    
    
    required init(view: TimeViewControllerProtocol,
                  router: TimeRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func setNumberOfRow(stationName: String,
                        toStation: String,
                        timeSheetTableViewValue: UITableView) {
        guard let direction = FireBaseFieldsEnum(rawValue: toStation),
              let timeSheet: [Int] = UserDefaults.standard.object(forKey: "\(stationName)\(direction)") as? [Int] else {return}
        
        var currentTimeFromStartDay = Int(Date().timeIntervalSince1970) - Int(Calendar.current.startOfDay(for: Date()).timeIntervalSince1970)
        
        let hoursArrayNext = timeSheet.filter {$0 > currentTimeFromStartDay}
        
        let hoursArray = hoursArrayNext.map {$0 / 3600}
        var hours = Array(Set(hoursArray)).sorted { $0 < $1 }
        view?.numberOfRow = hours.count
        timeSheetTableViewValue.reloadData()
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
    
    func configureTimeSheetTableViewCell(indexPath: IndexPath,
                                         cell: TimeSheetTableViewCellProtocol,
                                         stationName: String,
                                         toStation: String) {
        guard let direction = FireBaseFieldsEnum(rawValue: toStation),
              let stationNameValue = StationNamesEnum(rawValue: stationName),
              let timeSheet: [Int] = UserDefaults.standard.object(forKey: "\(stationNameValue)\(direction)") as? [Int],
              let dayOfWeek = UserDefaults.standard.string(forKey: "\(UserDefaultsKeysEnum.dayOfWeek)")
        else {return}
        
        
        
        FireBaseManager.shared.getTimeSheet(dayofWeek: dayOfWeek, stationName: "\(stationNameValue)", direction: "\(direction)") { result in
            print(result)
            switch result {
            case .success(let timeSheet):
                let currentTimeFromStartDay = Int(Date().timeIntervalSince1970) - Int(Calendar.current.startOfDay(for: Date()).timeIntervalSince1970)
                
                let hoursArrayNext = timeSheet.filter {$0 > currentTimeFromStartDay}
                let hoursArray = hoursArrayNext.map {$0 / 3600}
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
                    var minutes = hoursArrayNext.filter { return $0 / 3600 == hours[indexPath.row]}
                    minutes = minutes.map {($0 % 3600) / 60}
                    
                    minutesAll.append(minutes)
                }
                
                let minutesAllString = minutesAll[indexPath.row].map { (String(format: "%02d", arguments: [$0]))}
                let minutesString = minutesAllString.joined(separator:" ")
                
                cell.configureCell(hourValue: "\(String(format: "%02d", arguments: [hourModify[indexPath.row]])):",
                                   minutesValue: minutesString)
                
            case .failure(_):
                return
            }
        }
        
        
    }
    
    func openWeekdayVC(fromStationName: String,
                       toStationName: String,
                       dayTypeValue: DayTypeEnum) {
        
        router.openWeekdayVC(fromStationName: fromStationName,
                             toStationName: toStationName,
                             dayTypeValue: dayTypeValue)
    }
    
    func checkDayOfWeek() {
        let currentDay = Int(Date().timeIntervalSince1970).decoderDt(format: "EEEE")
        UserDefaults.standard.set(currentDay, forKey: "\(UserDefaultsKeysEnum.currentDay)")
        
        var dayOfWeek = ""
        switch currentDay {
        case "Saturday", "Sunday":
            dayOfWeek = "Расписание выходного дня"
        default:
            dayOfWeek = "Расписание буднего дня"
        }
        
        //UserDefaults.standard.set(dayOfWeek, forKey: "\(UserDefaultsKeysEnum.dayOfWeek)")
        view?.setDayOfWeek(dayOfWeekValue: dayOfWeek)
    }
    
}
