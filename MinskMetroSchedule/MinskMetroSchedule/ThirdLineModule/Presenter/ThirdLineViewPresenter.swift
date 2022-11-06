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
                    toStationName: String)
    
}

class ThirdLineViewPresenter: ThirdLineViewPresenterProtocol {
    
    var stationNamesArray = ["Ковальская слобода", "Вокзальная", "Пл.Франтишка Богушевича", "Юбилейная площадь"]
    var thirdViewControllerBackgroundColor: UIColor = .white
    
    weak var view: ThirdLineViewProtocol?
    private(set) var router: ThirdLineRouterProtocol
    
    required init(view: ThirdLineViewProtocol, router: ThirdLineRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func configureThirdLineTableViewCell(indexPath: IndexPath, cell: ThirdLineTableViewCellProtocol) {
        
        switch indexPath.row {
        case 0:
            cell.configureCell(stationNameText: stationNamesArray[indexPath.row],
                               toKovalskayaStationButtonIsHidden: true,
                               toUbileinayaStationButtonIsHidden: false)
        case 3:
            cell.configureCell(stationNameText: stationNamesArray[indexPath.row],
                               toKovalskayaStationButtonIsHidden: false,
                               toUbileinayaStationButtonIsHidden: true)
        default:
            cell.configureCell(stationNameText: stationNamesArray[indexPath.row],
                               toKovalskayaStationButtonIsHidden: false,
                               toUbileinayaStationButtonIsHidden: false)
        }
        
        guard let view else {return}
        cell.setThirdStationViewDelegate(view: view)
        
    }
    
    func openTimeVC(fromStationName: String,
                    toStationName: String) {
        router.openTimeVC(fromStationName: fromStationName,
                          toStationName: toStationName )
    }
    
}
