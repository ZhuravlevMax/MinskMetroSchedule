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
                                         toStation: String,
                                         line: String)
    
    func setNavBar(navColor: UIColor,
                   navTextColor: UIColor)
    
    func setNumberOfRow(stationName: String,
                        toStation: String,
                        line: String)
    
    func setNextTime(toStationName: String,
                     stationName: String,
                     line: String)
    
    func openWeekdayVC(fromStationName: String,
                       toStationName: String,
                       dayOfWeek: String,
                       dayType: String,
                       line: String)
    
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
                        line: String) {
        
        guard let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allData)") as? [String:Any],
              let dayOfWeek = UserDefaults.standard.string(forKey: "\(UserDefaultsKeysEnum.dayOfWeek)"),
              let dayData = allData[dayOfWeek] as? [String:Any],
              let thirdLineStations = dayData["\(line)"] as? [String:Any],
              let direction = FireBaseFieldsEnum(rawValue: toStation),
              let station = thirdLineStations[stationName] as? [String:Any],
              let timeSheet = station["\(direction)"] as? [Int]
        else {return}
        
        let currentTimeFromStartDay = Int(Date().timeIntervalSince1970) - Int(Calendar.current.startOfDay(for: Date()).timeIntervalSince1970)
        
        let hoursArrayNext = timeSheet.filter {$0 > currentTimeFromStartDay}
        
        let hoursArray = hoursArrayNext.map {$0 / 3600}
        let hours = Array(Set(hoursArray)).sorted { $0 < $1 }
        view?.numberOfRow = hours.count
        
    }
    
    func setNextTime(toStationName: String, stationName: String, line: String) {
        
        guard let direction = FireBaseFieldsEnum(rawValue: toStationName),
              let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allData)") as? [String:Any],
                    let dayOfWeek = UserDefaults.standard.string(forKey: "\(UserDefaultsKeysEnum.dayOfWeek)"),
                    let dayData = allData[dayOfWeek] as? [String:Any],
                    let thirdLineStations = dayData["\(line)"] as? [String:Any],
              let station = thirdLineStations[stationName] as? [String:Any],
              let timeSheet = station["\(direction)"] as? [Int] else {return}
        
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
                                         toStation: String,
                                         line: String) {
        guard let direction = FireBaseFieldsEnum(rawValue: toStation),
              let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allData)") as? [String:Any],
              let dayOfWeek = UserDefaults.standard.string(forKey: "\(UserDefaultsKeysEnum.dayOfWeek)"),
              let dayData = allData[dayOfWeek] as? [String:Any],
              let thirdLineStations = dayData[line] as? [String:Any],
              let stationNameValue = StationNamesEnum(rawValue: stationName),
              let station = thirdLineStations["\(stationNameValue)"] as? [String:Any],
              let timeSheet = station["\(direction)"] as? [Int]
        else {return}
        
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

    }
    
    func openWeekdayVC(fromStationName: String,
                       toStationName: String,
                       dayOfWeek: String,
                       dayType: String,
                       line: String) {
 
        router.openWeekdayVC(fromStationName: fromStationName,
                             toStationName: toStationName,
                             dayTypeValue: dayType,
                             dayOfWeek: dayOfWeek,
        line: line)
    }
    
    func setNavBar(navColor: UIColor,
                   navTextColor: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = navColor
        appearance.largeTitleTextAttributes = [.foregroundColor: navTextColor]
    
        view?.setNav(appearance: appearance, navTintColor: navTextColor)
    
    }
    
    func checkDayOfWeek() {
        let currentDay = UserDefaults.standard.string(forKey: "\(UserDefaultsKeysEnum.currentDay)")
        
        var dayOfWeek = ""
        switch currentDay {
        case "Saturday", "Sunday":
            dayOfWeek = "Расписание выходного дня"
        case "Friday":
            dayOfWeek = "Расписание для пятницы"
        default:
            dayOfWeek = "Расписание буднего дня"
        }
        view?.setDayOfWeek(dayOfWeekValue: dayOfWeek)
    }
    
}
