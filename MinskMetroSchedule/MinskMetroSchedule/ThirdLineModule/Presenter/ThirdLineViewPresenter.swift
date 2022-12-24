//
//  ThirdLineViewPresenter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import Foundation
import UIKit
import Network

protocol ThirdLineViewPresenterProtocol: AnyObject {
    
    //var thirdViewControllerBackgroundColor: UIColor {get}
    func setNavBar(view: UIViewController)
    func openTimeVC(fromStationName: String,
                    toStationName: String,
                    stationName: String)
    func configureThirdLineTableViewCell(indexPath: IndexPath,
                                         cell: ThirdLineTableViewCellProtocol)
    func setNumberOfRow()
}

class ThirdLineViewPresenter: ThirdLineViewPresenterProtocol {
    
    weak var view: ThirdLineViewProtocol?
    private(set) var router: ThirdLineRouterProtocol
    
    required init(view: ThirdLineViewProtocol,
                  router: ThirdLineRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func setNavBar(view: UIViewController) {
        //MARK: - Внешний вид navigationController
        view.title = "Зеленолужская"
        view.navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.thirdLineNavBarColor)")
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "\(NameColorForThemesEnum.thirdLineTextColor)")]
        view.navigationItem.standardAppearance = appearance
        view.navigationItem.scrollEdgeAppearance = appearance
        view.navigationItem.compactAppearance = appearance
    }
    
    func configureThirdLineTableViewCell(indexPath: IndexPath,
                                         cell: ThirdLineTableViewCellProtocol) {
        
        guard let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allData)") as? [String:Any],
              let dayOfWeek = UserDefaults.standard.string(forKey: "\(UserDefaultsKeysEnum.dayOfWeek)"),
              let dayData = allData[dayOfWeek] as? [String:Any],
              let thirdLineStations = dayData["\(FireBaseFieldsEnum.thirdLine)"] as? [String:Any],
              let stationNameValue = thirdStationIndexEnum(rawValue: indexPath.row),
              let station = thirdLineStations["\(stationNameValue)"] as? [String:Any],
              let stationNameText = station["\(FireBaseFieldsEnum.stationName)"] as? String,
              let transferName = station["\(FireBaseFieldsEnum.transferName)"] as? String,
              let colorName = station["\(FireBaseFieldsEnum.transferColor)"] as? String,
              let transferColor = UIColor(named: colorName)
        else {return}
        
        let toKovalskayaDirectionExist: Bool = {
            if station["\(FireBaseFieldsEnum.toKovalskayaTimeSheet)"] != nil {
                return false }
            return true
        }()
        let toUbileinayaDirectionExist: Bool = {
            if station["\(FireBaseFieldsEnum.toUbileynayaTimeSheet)"] != nil {
                return false }
            return true
        }()
    
        let stationName = "\(stationNameValue)"
        
        cell.configureCell(stationNameText: stationNameText,
                           toKovalskayaStationButtonIsHidden: toKovalskayaDirectionExist,
                           toUbileinayaStationButtonIsHidden: toUbileinayaDirectionExist,
                           stationNameValue: stationName,
                           transferName: transferName,
                           transferColor: transferColor)
    
        guard let view else {return}
        cell.setThirdStationViewDelegate(view: view)
        
    }
    
    func openTimeVC(fromStationName: String,
                    toStationName: String,
                    stationName: String) {
        
        self.router.openTimeVC(fromStationName: fromStationName,
                               toStationName: toStationName)
        
    }
    
    func setNumberOfRow() {

        guard let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allData)") as? [String:Any],
              let dayOfWeek = UserDefaults.standard.string(forKey: "\(UserDefaultsKeysEnum.dayOfWeek)"),
              let dayData = allData[dayOfWeek] as? [String:Any],
              let thirdLineData = dayData["\(FireBaseFieldsEnum.thirdLine)"] as? [String:Any]
        else {return}
  
        view?.numberOfRow = thirdLineData.count
    }
    
    
    
}
