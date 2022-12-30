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
            return key.contains("\(FireBaseFieldsEnum.stationName)")
        }
        if let nameDictUnwrapped = nameDict, let name = nameDictUnwrapped.value as? String {
            return name
        }
        return ""
    }
    
    func getButtonColor(station: [String : Any]) -> String {
        let nameDict = station.first { key, value in
            return key.contains("\(FireBaseFieldsEnum.navColor)")
        }
        if let nameDictUnwrapped = nameDict, let name = nameDictUnwrapped.value as? String {
            return name
        }
        return ""
    }
    
    func getTextButtonColor(station: [String : Any]) -> String {
        let nameDict = station.first { key, value in
            return key.contains("\(FireBaseFieldsEnum.textColor)")
        }
        if let nameDictUnwrapped = nameDict, let name = nameDictUnwrapped.value as? String {
            return name
        }
        return ""
    }
    
    func getNameMainDirection(station: [String : Any]) -> String {
        let nameDict = station.first { key, value in

            switch key {
            case "\(FireBaseFieldsEnum.toUbileynayaTimeSheet)":
                return key.contains("\(FireBaseFieldsEnum.toUbileynayaTimeSheet)")
            case "\(FireBaseFieldsEnum.toKamenkaTimeSheet)":
                return key.contains("\(FireBaseFieldsEnum.toKamenkaTimeSheet)")
            case "\(FireBaseFieldsEnum.toUrucheTimeSheet)":
                return key.contains("\(FireBaseFieldsEnum.toUrucheTimeSheet)")
            default:
               return false
            }
        }
        
        if let nameDictUnwrapped = nameDict, let name = nameDictUnwrapped.key as? String {
            
            switch name {

            case "toUbileynayaTimeSheet":
                return "На Юбилейную"
            case "toUrucheTimeSheet":
                return "На Уручье"
            case "toKamenkaTimeSheet":
                return "На Каменную Горку"
            default:
               return ""
            }

            //return "\(FireBaseFieldsEnum(rawValue: name))"
            //return "\(FireBaseFie)"
        }
        return "Посадки нет"
    }
    
    func getNameReverseDirection(station: [String : Any]) -> String {
        let nameDict = station.first { key, value in

            switch key {
            case "\(FireBaseFieldsEnum.toKovalskayaTimeSheet)":
                return key.contains("\(FireBaseFieldsEnum.toKovalskayaTimeSheet)")
            case "\(FireBaseFieldsEnum.toMogilevskyaTimeSheet)":
                return key.contains("\(FireBaseFieldsEnum.toMogilevskyaTimeSheet)")
            case "\(FireBaseFieldsEnum.toMalinovkaTimeSheet)":
                return key.contains("\(FireBaseFieldsEnum.toMalinovkaTimeSheet)")
            default:
                return false
            }

        }
        
        if let nameDictUnwrapped = nameDict, let name = nameDictUnwrapped.key as? String {
            switch name {
            case "toKovalskayaTimeSheet":
                return "На Ковальскую"
            case "toMalinovkaTimeSheet":
                return "На Малиновку"
            case "toMogilevskyaTimeSheet":
                return "На Могилевскую"
            default:
                return ""
            }
        }
        return "Посадки нет"
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
        
        let valueArray = stations.values
        var array: [[String : Any]] = []
        for field in valueArray {
            guard let value = field as? [String : Any] else {return}
            array.append(value)
        }
        
        
        print(array)
        
        print(getStationName(station: array[indexPath.row]))
        
        print(getButtonColor(station: array[indexPath.row]))
        print(getTextButtonColor(station: array[indexPath.row]))
        print(getNameMainDirection(station: array[indexPath.row]))
        print(getNameReverseDirection(station: array[indexPath.row]))
        
        cell.setName(stationNameText: getStationName(station: array[indexPath.row]),
                     buttonColor: getButtonColor(station: array[indexPath.row]),
                     textButtonColor: getTextButtonColor(station: array[indexPath.row]),
                     mainDirection: getNameMainDirection(station: array[indexPath.row]),
                     reverseDirection: getNameReverseDirection(station: array[indexPath.row])
                     )
        
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
