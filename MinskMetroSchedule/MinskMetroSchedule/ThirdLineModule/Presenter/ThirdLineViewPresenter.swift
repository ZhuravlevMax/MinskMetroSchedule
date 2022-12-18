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
    func showErrorAlert(dayOfWeek:String, view: UIViewController)
    func showSuccessAlert(view: UIViewController)
    func checkConnection(dayOfWeek: String, view: UIViewController)
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
            
        case 0://Ковальская
            cell.configureCell(stationNameText: stationNamesArray[indexPath.row],
                               toKovalskayaStationButtonIsHidden: true,
                               toUbileinayaStationButtonIsHidden: false,
                               stationNameValue: "\(stationName)",
                               transferName: "",
                               transferColor: .white)
        case 1://Вокзальная
            cell.configureCell(stationNameText: stationNamesArray[indexPath.row],
                               toKovalskayaStationButtonIsHidden: false,
                               toUbileinayaStationButtonIsHidden: false,
                               stationNameValue: "\(stationName)",
                               transferName: "Переход на Ленина",
                               transferColor: .blue)
            
        case 3://Юбилейная
            cell.configureCell(stationNameText: stationNamesArray[indexPath.row],
                               toKovalskayaStationButtonIsHidden: false,
                               toUbileinayaStationButtonIsHidden: true,
                               stationNameValue: "\(stationName)",
                               transferName: "Переход на Фрунзенскую",
                               transferColor: .red)
        default://Богущевича
            cell.configureCell(stationNameText: stationNamesArray[indexPath.row],
                               toKovalskayaStationButtonIsHidden: false,
                               toUbileinayaStationButtonIsHidden: false,
                               stationNameValue: "\(stationName)",
                               transferName: "",
                               transferColor: .white)
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
    
    func downloadAllData(dayOfWeek: String, view: UIViewController) {
        FireBaseManager.shared.getAllData(dayOfWeek: dayOfWeek, completion: { [weak self] result in
                guard let self else {return}
                switch result {
                case .success(let dailyData):
                    UserDefaults.standard.set(dailyData, forKey: "\(UserDefaultsKeysEnum.allDayData)")
                    print(UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allDayData)"))
                    self.showSuccessAlert(view: view)
                case .failure(_):
                    print("FAIL")
                    self.showErrorAlert(dayOfWeek: dayOfWeek, view: view)
                    return
                }
            })
        }
    
    
    func showErrorAlert(dayOfWeek: String, view: UIViewController) {
        let errorAlertController = UIAlertController(title: "Ошибка", message: "Не удалось загрузить расписание, проверьте интернет соединение", preferredStyle: .alert)
        let okButtonAction = UIAlertAction(title: "Повторить", style: .default) { [self] _ in
            downloadAllData(dayOfWeek:dayOfWeek, view: view)
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
    
    func checkConnection(dayOfWeek: String, view: UIViewController) {
        let monitor = NWPathMonitor()
        monitor.start(queue: DispatchQueue(label: "NetworkMonitor"))
        monitor.pathUpdateHandler = { (path) in
            if path.status == .satisfied {
                self.downloadAllData(dayOfWeek: dayOfWeek, view: view)
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
        
        guard let allTimesheet = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allDayData)") as? [String:Any] else {return}
        print(allTimesheet.count)
        view?.numberOfRow = allTimesheet.count
    }
    
    
    
}
