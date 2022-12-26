//
//  SecondLineViewPresenter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import Foundation
import UIKit
import Network

protocol SecondLineViewPresenterProtocol: AnyObject {

    func openTimeVC(fromStationName: String,
                    toStationName: String,
                    stationName: String,
                    navColor: UIColor,
                    navTextColor: UIColor,
                    line: String)
    func configureSecondLineTableViewCell(indexPath: IndexPath,
                                         cell: SecondLineTableViewCellProtocol)
    func setNumberOfRow()
    func setNavBar()
}

class SecondLineViewPresenter: SecondLineViewPresenterProtocol {
    
    weak var view: SecondLineViewProtocol?
    private(set) var router: SecondLineRouterProtocol
    
    required init(view: SecondLineViewProtocol,
                  router: SecondLineRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func configureSecondLineTableViewCell(indexPath: IndexPath,
                                         cell: SecondLineTableViewCellProtocol) {
        
        guard let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allData)") as? [String:Any],
              let dayOfWeek = UserDefaults.standard.string(forKey: "\(UserDefaultsKeysEnum.dayOfWeek)"),
              let dayData = allData[dayOfWeek] as? [String:Any],
              let secondLineStations = dayData["\(FireBaseFieldsEnum.secondLine)"] as? [String:Any],
              let stationNameValue = secondStationIndexEnum(rawValue: indexPath.row),
              let station = secondLineStations["\(stationNameValue)"] as? [String:Any],
              let stationNameText = station["\(FireBaseFieldsEnum.stationName)"] as? String,
              let transferName = station["\(FireBaseFieldsEnum.transferName)"] as? String,
              let colorName = station["\(FireBaseFieldsEnum.transferColor)"] as? String,
              let transferColor = UIColor(named: colorName)
        else {return}
        
        let toMogilevskayaDirectionExist: Bool = {
            if station["\(FireBaseFieldsEnum.toMogilevskyaTimeSheet)"] != nil {
                return false }
            return true
        }()
        let toKamenkaDirectionExist: Bool = {
            if station["\(FireBaseFieldsEnum.toKamenkaTimeSheet)"] != nil {
                return false }
            return true
        }()
    
        let stationName = "\(stationNameValue)"
        
        cell.configureCell(stationNameText: stationNameText,
                           toMogilevskyaStationButtonIsHidden: toMogilevskayaDirectionExist,
                           toKamenkaStationButtonIsHidden: toKamenkaDirectionExist,
                           stationNameValue: stationName,
                           transferName: transferName,
                           transferColor: transferColor)
    
        guard let view else {return}
        cell.setSecondStationViewDelegate(view: view)
        
    }
    
    func openTimeVC(fromStationName: String,
                    toStationName: String,
                    stationName: String,
                    navColor: UIColor,
                    navTextColor: UIColor,
                    line: String) {
        
        self.router.openTimeVC(fromStationName: fromStationName,
                               toStationName: toStationName,
                               navColor: navColor,
                               navTextColor: navTextColor,
                               line: line)
        
    }
    
    func setNumberOfRow() {

        guard let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allData)") as? [String:Any],
              let dayOfWeek = UserDefaults.standard.string(forKey: "\(UserDefaultsKeysEnum.dayOfWeek)"),
              let dayData = allData[dayOfWeek] as? [String:Any],
              let secondLineData = dayData["\(FireBaseFieldsEnum.secondLine)"] as? [String:Any]
        else {return}
  
        view?.numberOfRow = secondLineData.count
    }
    
    func setNavBar() {
        let titleValue = "Автозаводская"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.secondLineNavBarColor)")
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "\(NameColorForThemesEnum.secondLineTextColor)") ?? .white]
        view?.setNav(appearance: appearance, titleValue: titleValue)
    
    }
    
    
    
}
