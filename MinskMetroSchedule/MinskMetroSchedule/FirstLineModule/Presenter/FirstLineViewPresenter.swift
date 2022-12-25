//
//  FirstLineViewPresenter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 23.12.22.
//

import Foundation
import UIKit
import Network

protocol FirstLineViewPresenterProtocol: AnyObject {
    
    //var thirdViewControllerBackgroundColor: UIColor {get}

    func openTimeVC(fromStationName: String,
                    toStationName: String,
                    stationName: String,
                    navColor: UIColor,
                    navTextColor: UIColor,
                    line: String)
    func configureFirstLineTableViewCell(indexPath: IndexPath,
                                         cell: FirstLineTableViewCellProtocol)
    func downloadAllData()
    func checkConnection()
    func setNumberOfRow()
    func setNavBar()
}

class FirstLineViewPresenter: FirstLineViewPresenterProtocol {
    

    
    weak var view: FirstLineViewProtocol?
    private(set) var router: FirstLineRouterProtocol
    
    required init(view: FirstLineViewProtocol,
                  router: FirstLineRouterProtocol) {
        self.view = view
        self.router = router
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
    
    func configureFirstLineTableViewCell(indexPath: IndexPath, cell: FirstLineTableViewCellProtocol) {
        
        guard let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allData)") as? [String:Any],
              let dayOfWeek = UserDefaults.standard.string(forKey: "\(UserDefaultsKeysEnum.dayOfWeek)"),
              let dayData = allData[dayOfWeek] as? [String:Any],
              let firstLineStations = dayData["\(FireBaseFieldsEnum.firstLine)"] as? [String:Any],
              let stationNameValue = firstStationIndexEnum(rawValue: indexPath.row),
              let station = firstLineStations["\(stationNameValue)"] as? [String:Any],
              let stationNameText = station["\(FireBaseFieldsEnum.stationName)"] as? String,
              let transferName = station["\(FireBaseFieldsEnum.transferName)"] as? String,
              let colorName = station["\(FireBaseFieldsEnum.transferColor)"] as? String,
              let transferColor = UIColor(named: colorName)
        else {return}
        
        let toMalinovkaDirectionExist: Bool = {
            if station["\(FireBaseFieldsEnum.toMalinovkaTimeSheet)"] != nil {
                return false }
            return true
        }()
        
        let toUrucheDirectionExist: Bool = {
            if station["\(FireBaseFieldsEnum.toUrucheTimeSheet)"] != nil {
                return false }
            return true
        }()
    
        let stationName = "\(stationNameValue)"
        
        cell.configureCell(stationNameText: stationNameText,
                           toMalinovkaStationButtonIsHidden: toMalinovkaDirectionExist,
                           toUrucheStationButtonIsHidden: toUrucheDirectionExist,
                           stationNameValue: stationName,
                           transferName: transferName,
                           transferColor: transferColor)
    
        guard let view else {return}
        cell.setFirstStationViewDelegate(view: view)
    }
    
    func setNavBar() {
        let titleValue = "Московская"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.firstLineNavBarColor)")
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "\(NameColorForThemesEnum.firstLineTextColor)") ?? .white]
        view?.setNav(appearance: appearance, titleValue: titleValue)
    
    }
    
    func downloadAllData() {
        
        let errorAlertController = UIAlertController(title: "Ошибка", message: "Не удалось загрузить расписание, проверьте интернет соединение.", preferredStyle: .alert)
        let okErrorAlertButtonAction = UIAlertAction(title: "Повторить", style: .default) { [self] _ in
            downloadAllData()
        }
        errorAlertController.addAction(okErrorAlertButtonAction)
        
        let successAlertController = UIAlertController(title: "Успешно!", message: "Актуальное расписание загружено. Расписание обновляется раз в день при наличии интернет соединения.", preferredStyle: .alert)
        let okSuccesButtonButtonAction = UIAlertAction(title: "Ok", style: .default) { [self] _ in
            setNumberOfRow()
        }
        successAlertController.addAction(okSuccesButtonButtonAction)
        
        
        FireBaseManager.shared.getAllData(completion: { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let allData):
                UserDefaults.standard.set(allData, forKey: "\(UserDefaultsKeysEnum.allData)")
                self.view?.showSuccessAlert(successAlertController: successAlertController)
                
            case .failure(_):
                self.view?.showErrorAlert(errorAlertController: errorAlertController)
                return
            }
        })
    }

    
    func checkConnection() {
        let monitor = NWPathMonitor()
        monitor.start(queue: DispatchQueue(label: "NetworkMonitor"))
        monitor.pathUpdateHandler = { (path) in
            if path.status == .satisfied {
               self.downloadAllData()
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
              let firstLineData = dayData["\(FireBaseFieldsEnum.firstLine)"] as? [String:Any]
        else {return}
  
        view?.numberOfRow = firstLineData.count
    }
    
}
