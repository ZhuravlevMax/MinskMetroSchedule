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
    func downloadAllData(view: UIViewController)
    func showErrorAlert(view: UIViewController)
    func showSuccessAlert(view: UIViewController)
    func checkConnection(view: UIViewController)
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
        let errorAlertController = UIAlertController(title: "Ошибка", message: "Не удалось загрузить расписание, проверьте интернет соединение.", preferredStyle: .alert)
        let okButtonAction = UIAlertAction(title: "Повторить", style: .default) { [self] _ in
            downloadAllData(view: view)
        }
        errorAlertController.addAction(okButtonAction)
        view.present(errorAlertController, animated: true)
    }
    
    func showSuccessAlert(view: UIViewController) {
        let errorAlertController = UIAlertController(title: "Успешно!", message: "Актуальное расписание загружено. Расписание обновляется раз в день при наличии интернет соединения.", preferredStyle: .alert)
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

        guard let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allData)") as? [String:Any],
              let dayOfWeek = UserDefaults.standard.string(forKey: "\(UserDefaultsKeysEnum.dayOfWeek)"),
              let dayData = allData[dayOfWeek] as? [String:Any],
              let thirdLineData = dayData["\(FireBaseFieldsEnum.thirdLine)"] as? [String:Any]
        else {return}
  
        view?.numberOfRow = thirdLineData.count
    }
    
    
    
}
