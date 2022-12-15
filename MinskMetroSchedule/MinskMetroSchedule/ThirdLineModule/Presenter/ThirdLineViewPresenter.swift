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
       
            
            self.router.openTimeVC(fromStationName: fromStationName,
                                   toStationName: toStationName)
        
    }
    
    func downloadAllData(view: UIViewController) {
        FireBaseManager.shared.getTimeSheet(stationName: "\(StationNamesEnum.kovalskaya)", direction: "\(FireBaseFieldsEnum.toUbileynayaTimeSheet)") { result in
            
            switch result {
            case .success(let timeSheetArray):
                if UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.kovalskayatoUbileynayaTimeSheet)") == nil {
                    self.showSuccessAlert(view: view)
                }
                
                UserDefaults.standard.set(timeSheetArray, forKey: "\(UserDefaultsKeysEnum.kovalskayatoUbileynayaTimeSheet)")
                //print(UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.kovalskayatoUbileynayaTimeSheet)"))
                
            case .failure(_):
                self.showErrorAlert(view: view)
            }
            
        }
        
        FireBaseManager.shared.getTimeSheet(stationName: "\(StationNamesEnum.vokzalnaya)", direction: "\(FireBaseFieldsEnum.toKovalskayaTimeSheet)") { result in
            
            switch result {
            case .success(let timeSheetArray):
                UserDefaults.standard.set(timeSheetArray, forKey: "\(UserDefaultsKeysEnum.vokzalnayatoKovalskayaTimeSheet)")
            case .failure(_):
                return
            }
            
        }
        
        FireBaseManager.shared.getTimeSheet(stationName: "\(StationNamesEnum.vokzalnaya)", direction: "\(FireBaseFieldsEnum.toUbileynayaTimeSheet)") { result in
            
            switch result {
            case .success(let timeSheetArray):
                UserDefaults.standard.set(timeSheetArray, forKey: "\(UserDefaultsKeysEnum.vokzalnayatoUbileynayaTimeSheet)")
            case .failure(_):
                return
            }
            
        }
        
        FireBaseManager.shared.getTimeSheet(stationName: "\(StationNamesEnum.bogushevicha)", direction: "\(FireBaseFieldsEnum.toKovalskayaTimeSheet)") { result in
            
            switch result {
            case .success(let timeSheetArray):
                UserDefaults.standard.set(timeSheetArray, forKey: "\(UserDefaultsKeysEnum.bogushevichatoKovalskayaTimeSheet)")
            case .failure(_):
                return
            }
            
        }
        
        FireBaseManager.shared.getTimeSheet(stationName: "\(StationNamesEnum.bogushevicha)", direction: "\(FireBaseFieldsEnum.toUbileynayaTimeSheet)") { result in
            
            switch result {
            case .success(let timeSheetArray):
                UserDefaults.standard.set(timeSheetArray, forKey: "\(UserDefaultsKeysEnum.bogushevichatoUbileynayaTimeSheet)")
            case .failure(_):
                return
            }
            
        }
        
        FireBaseManager.shared.getTimeSheet(stationName: "\(StationNamesEnum.ubileynaya)", direction: "\(FireBaseFieldsEnum.toKovalskayaTimeSheet)") { result in
            
            switch result {
            case .success(let timeSheetArray):
                UserDefaults.standard.set(timeSheetArray, forKey: "\(UserDefaultsKeysEnum.ubileynayatoKovalskayaTimeSheet)")
            case .failure(_):
                return
            }
            
        }
        
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
        let errorAlertController = UIAlertController(title: "Успех!", message: "Актуальное расписание загружено", preferredStyle: .alert)
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
        if UserDefaults.standard.integer(forKey: "\(UserDefaultsKeysEnum.childCount)") == 0 {
            FireBaseManager.shared.getChildCount { result in
                switch result {
                case .success(let childCount):
                    self.view?.numberOfRow = childCount
                    UserDefaults.standard.set(childCount, forKey: "\(UserDefaultsKeysEnum.childCount)")
                case .failure(_):
                    return
                }
            }
        }
    }
}
