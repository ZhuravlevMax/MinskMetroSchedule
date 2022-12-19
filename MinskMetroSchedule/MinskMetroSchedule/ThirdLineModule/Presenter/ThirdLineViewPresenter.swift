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
    func openTimeVC(fromStationName: String,
                    toStationName: String,
                    stationName: String)
    func configureThirdLineTableViewCell(indexPath: IndexPath,
                                         cell: ThirdLineTableViewCellProtocol)
    func showErrorAlert(view: UIViewController)
    func showSuccessAlert(view: UIViewController)
    func checkConnection(view: UIViewController)
}

class ThirdLineViewPresenter: ThirdLineViewPresenterProtocol {
    
    var stationNamesArray = [StationNamesEnum.kovalskaya.rawValue,
                             StationNamesEnum.vokzalnaya.rawValue,
                             StationNamesEnum.bogushevicha.rawValue,
                             StationNamesEnum.ubileynaya.rawValue]
    //var thirdViewControllerBackgroundColor: UIColor = .white
    
    weak var view: ThirdLineViewProtocol?
    private(set) var router: ThirdLineRouterProtocol
    
    required init(view: ThirdLineViewProtocol,
                  router: ThirdLineRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func configureThirdLineTableViewCell(indexPath: IndexPath,
                                         cell: ThirdLineTableViewCellProtocol) {
        
        guard let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allData)") as? [String:Any],
              let stations = allData["\(FireBaseCollectionsEnum.stations)"] as? [String:Any],
              let stationNameValue = StationNamesNumEnum(rawValue: indexPath.row),
              let station = stations["\(stationNameValue)"] as? [String:Any],
              let stationNameText = station["\(FireBaseFieldsEnum.stationName)"] as? String,
              let transferName = station["\(FireBaseFieldsEnum.transferName)"] as? String,
              let colorName = station["\(FireBaseFieldsEnum.transferColor)"] as? String,
              let transferColor = UIColor(named: colorName)
        else {return}
        
        var toKovalskayaDirectionExist: Bool = {
            if station["\(FireBaseFieldsEnum.toKovalskayaTimeSheet)"] != nil {
                return false }
            return true
        }()
        var toUbileinayaDirectionExist: Bool = {
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
    
    func downloadAllData(view: UIViewController) {
        FireBaseManager.shared.getAllData(completion: { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let allData):
                UserDefaults.standard.set(allData, forKey: "\(UserDefaultsKeysEnum.allData)")
                //print(UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allDayData)"))
                self.showSuccessAlert(view: view)
            case .failure(_):
                //print("FAIL")
                self.showErrorAlert(view: view)
                return
            }
        })
    }
    
    
    func showErrorAlert(view: UIViewController) {
        let errorAlertController = UIAlertController(title: "Ошибка", message: "Не удалось загрузить расписание, проверьте интернет соединение", preferredStyle: .alert)
        let okButtonAction = UIAlertAction(title: "Повторить", style: .default) { [self] _ in
            downloadAllData(view: view)
        }
        errorAlertController.addAction(okButtonAction)
        view.present(errorAlertController, animated: true)
    }
    
    func showSuccessAlert(view: UIViewController) {
        let errorAlertController = UIAlertController(title: "Успешно!", message: "Актуальное расписание загружено", preferredStyle: .alert)
        let okButtonAction = UIAlertAction(title: "Ok", style: .default) { [self] _ in
            setNumberOfRow()
        }
        errorAlertController.addAction(okButtonAction)
        view.present(errorAlertController, animated: true)
    }
    
    func checkConnection(view: UIViewController) {
        let monitor = NWPathMonitor()
        monitor.start(queue: DispatchQueue(label: "NetworkMonitor"))
        monitor.pathUpdateHandler = { (path) in
            if path.status == .satisfied {
                self.downloadAllData(view: view)
                print("Connected")
            } else {
                print("Not Connected")
            }
        }
    }
    
    func setNumberOfRow() {
        
        //        FireBaseManager.shared.getChildCount { result in
        //            switch result {
        //            case .success(let childCount):
        //                self.view?.numberOfRow = childCount
        //            case .failure(_):
        //                return
        //            }
        //        }
        //                UserDefaults.standard.set(dict, forKey: "\(UserDefaultsKeysEnum.allDayData)")
        //                let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allDayData)") as! [String:Any]
        //                let station = allData["vokzalnaya"] as! [String:Any]
        //                let stationName = station["stationName"] as? String
        
        guard let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allData)") as? [String:Any],
              let allTimesheet = allData["\(FireBaseCollectionsEnum.timeSheetWeekday)"] as? [String:Any] else {return}
        print(allTimesheet.count)
        view?.numberOfRow = allTimesheet.count
    }
    
    
    
}
