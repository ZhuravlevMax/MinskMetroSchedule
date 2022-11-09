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
    
    required init(view: ThirdLineViewProtocol, router: ThirdLineRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func configureThirdLineTableViewCell(indexPath: IndexPath, cell: ThirdLineTableViewCellProtocol) {
        
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
        
//        FireBaseManager.shared.getMultipleAll(collection: "\(FireBaseCollectionsEnum.stations)") { [weak self] models in
//            guard let self else {return}
//            let model = models.first { model in
//               let modelName = FireBaseManager.shared.getModelName(model: model)
//                return modelName == stationName
//            }
//
//            switch toStationName {
//            case directionsEnum.toKovalskaya.rawValue:
//                guard let model, let nextTime = FireBaseManager.shared.getScheduleToKovalskaya(model: model).first else {return}
//                let nextTimeValue = "\(nextTime)"
//                self.router.openTimeVC(fromStationName: fromStationName,
//                                  toStationName: toStationName, nextTimeValue: nextTimeValue )
//
//            case directionsEnum.toUbileynaya.rawValue:
//                guard let model, let nextTime = FireBaseManager.shared.getScheduleToUbileynya(model: model).first else {return}
//                let nextTimeValue = "\(nextTime)"
//                self.router.openTimeVC(fromStationName: fromStationName,
//                                  toStationName: toStationName, nextTimeValue: nextTimeValue )
//            default:
//                return
//            }
//
//
//        }
        
        FireBaseManager.shared.getTimeSheet(stationName: stationName) { timeSheet in
            guard let timeSheetFirst = timeSheet.first else {return}
            self.router.openTimeVC(fromStationName: fromStationName, toStationName: toStationName, nextTimeValue: "\(timeSheetFirst)" )
        }
        
        
    }
    
}
