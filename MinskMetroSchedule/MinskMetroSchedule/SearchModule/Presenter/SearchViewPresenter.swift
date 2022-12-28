//
//  SearchViewPresenter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 26.12.22.
//

import Foundation
import UIKit

protocol SearchViewPresenterProtocol: AnyObject {
    func getStations()
    func getStationName(station: [String : Any]) -> String
    func filterModelsForSearch(stations: [String : Any], searchText: String)
    func configureSearchTableViewCell(indexPath: IndexPath, cell: SearchTableViewCellProtocol, stations: [String : Any])
}

class SearchViewPresenter: SearchViewPresenterProtocol {
    
    weak var view: SearchViewProtocol?
    private(set) var router: SearchRouterProtocol
    
    required init(view: SearchViewProtocol,
                  router: SearchRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func getStations() {
        var allStations: [String:Any] = [:]
        guard let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allData)") as? [String:Any],
              let dayOfWeek = UserDefaults.standard.string(forKey: "\(UserDefaultsKeysEnum.dayOfWeek)"),
              let dayData = allData[dayOfWeek] as? [String:Any],
              let firstLineStations = dayData["\(FireBaseFieldsEnum.firstLine)"] as? [String:Any],
              let secondLineStations = dayData["\(FireBaseFieldsEnum.secondLine)"] as? [String:Any],
              let thirdLineStations = dayData["\(FireBaseFieldsEnum.thirdLine)"] as? [String:Any]
                
        else {return}
//
//        firstLineStations.forEach { station in
//            allStations.append(station)
//        }
        allStations = firstLineStations.merging(secondLineStations, uniquingKeysWith: { key1, key2 in
            
        })
        allStations = allStations.merging(thirdLineStations, uniquingKeysWith: { key1, key2 in
            
        })

        view?.stations = allStations
    }
    
    func getStationName(station: [String : Any]) -> String {
        let nameDict = station.first { key, value in
            return key.contains("stationName")
        }
        if let nameDictUnwrapped = nameDict, let name = nameDictUnwrapped.value as? String {
            return name
        }
        return ""
    }
    
    //MARK: - Метод для сравения введенного текста с массивом объектов по именам
    func filterModelsForSearch(stations: [String : Any], searchText: String) {
        
       let filteredStations = stations.filter({ station in
            guard let stationValue = station.value as? [String:Any] else {return false}
           return getStationName(station: stationValue).lowercased().contains(searchText.lowercased())
        })
        
       // print(filteredStations)
        view?.filteredStations = filteredStations
    }
    
    func configureSearchTableViewCell(indexPath: IndexPath, cell: SearchTableViewCellProtocol, stations: [String : Any] ) {
        
        var valueArray = stations.values
        valueArray.count
        var array: [[String : Any]] = []
        for i in valueArray{
            guard let value = i as? [String : Any] else {return}
            array.append(value)
        }
        
        print(array)
        
        print(getStationName(station: array[indexPath.row]))

//        guard let stationNameText = getStationName(station: array[indexPath.row])
//        else {return}
        cell.setName(stationNameText: getStationName(station: array[indexPath.row]))
        
//        let toMalinovkaDirectionExist: Bool = {
//            if station["\(FireBaseFieldsEnum.toMalinovkaTimeSheet)"] != nil {
//                return false }
//            return true
//        }()
//
//        let toUrucheDirectionExist: Bool = {
//            if station["\(FireBaseFieldsEnum.toUrucheTimeSheet)"] != nil {
//                return false }
//            return true
//        }()
//
//        let stationName = "\(stationNameValue)"
//
//        cell.configureCell(stationNameText: stationNameText,
//                           toMalinovkaStationButtonIsHidden: toMalinovkaDirectionExist,
//                           toUrucheStationButtonIsHidden: toUrucheDirectionExist,
//                           stationNameValue: stationName,
//                           transferName: transferName,
//                           transferColor: transferColor)
//
//        guard let view else {return}
        //cell.setFirstStationViewDelegate(view: view)
    }
}
