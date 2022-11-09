//
//  ThirdLineViewPresenter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import Foundation
import UIKit

protocol ThirdLineViewPresenterProtocol: AnyObject {
    
    var thirdViewControllerBackgroundColor: UIColor {get}
    func openTimeVC(fromStationName: String,
                    toStationName: String,
                    stationName: String)
    
}

class ThirdLineViewPresenter: ThirdLineViewPresenterProtocol {
    
    var stationNamesArray = [StationNamesEnum.kovalskaya.rawValue,
                             StationNamesEnum.vokzalnaya.rawValue,
                             StationNamesEnum.bogushevicha.rawValue,
                             StationNamesEnum.ubileynaya.rawValue]
    var thirdViewControllerBackgroundColor: UIColor = .white
    
    weak var view: ThirdLineViewProtocol?
    private(set) var router: ThirdLineRouterProtocol
    
    required init(view: ThirdLineViewProtocol,
                  router: ThirdLineRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func configureThirdLineTableViewCell(indexPath: IndexPath,
                                         cell: ThirdLineTableViewCellProtocol) {
        
        guard let stationName = StationNamesNumEnum(rawValue: indexPath.row) else {return}
        
        switch indexPath.row {
            
        case 0:
            cell.configureCell(stationNameText: stationNamesArray[indexPath.row],
                               toKovalskayaStationButtonIsHidden: true,
                               toUbileinayaStationButtonIsHidden: false,
                               stationNameValue: "\(stationName)")
        case 3:
            cell.configureCell(stationNameText: stationNamesArray[indexPath.row],
                               toKovalskayaStationButtonIsHidden: false,
                               toUbileinayaStationButtonIsHidden: true,
                               stationNameValue: "\(stationName)")
        default:
            cell.configureCell(stationNameText: stationNamesArray[indexPath.row],
                               toKovalskayaStationButtonIsHidden: false,
                               toUbileinayaStationButtonIsHidden: false,
                               stationNameValue: "\(stationName)")
        }
        
        guard let view else {return}
        cell.setThirdStationViewDelegate(view: view)
        
    }
    
    func openTimeVC(fromStationName: String,
                    toStationName: String,
                    stationName: String) {
        guard let direction = FireBaseFieldsEnum(rawValue: toStationName) else {return}
        let directionString = "\(direction)"
        FireBaseManager.shared.getTimeSheet(stationName: stationName,
                                            direction: directionString) { timeSheet in

            let currentTimeFromStartDay = Int(Date().timeIntervalSince1970) - Int(Calendar.current.startOfDay(for: Date()).timeIntervalSince1970)
            
            var nextTime = timeSheet.first { $0 > currentTimeFromStartDay }
            
            guard var nextTime else {return}
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            
            let formattedString = formatter.string(from: TimeInterval(nextTime))
            guard let formattedString else {return}
            
            self.router.openTimeVC(fromStationName: fromStationName,
                                   toStationName: toStationName,
                                   nextTimeValue: formattedString )
        }
        
        
    }
    
}
