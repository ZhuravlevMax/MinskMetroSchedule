//
//  FirebaseEnums.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 8.11.22.
//

import Foundation

enum FireBaseCollectionsEnum {
    case friday
    case weekday
    case weekend
}

enum FireBaseFieldsEnum: String {
    case stationName
    case toKovalskayaTimeSheet = "На Ковальскую"
    case toUbileynayaTimeSheet = "На Юбилейную"
    case toMalinovkaTimeSheet = "На Малиновку"
    case toUrucheTimeSheet = "На Уручье"
    case toMogilevskyaTimeSheet = "На Могилевскую"
    case toKamenkaTimeSheet = "На Каменную Горку"
    case navColor
    case textColor
    case transferName
    case transferColor
    case firstLine
    case secondLine
    case thirdLine
    
    
    
}

enum DirectionEnum: String {
    
case toKovalskayaTimeSheet
case toUbileynayaTimeSheet
case toMalinovkaTimeSheet
case toUrucheTimeSheet
case toMogilevskyaTimeSheet
case toKamenkaTimeSheet
    
    var direction: String {
        switch self {
        case .toUrucheTimeSheet:
            return "На Уручье"
        case .toKamenkaTimeSheet:
            return "На Каменную Горку"
        case .toUbileynayaTimeSheet:
            return "На Юбилейную"
        case .toKovalskayaTimeSheet:
            return "На Ковальскую"
        case .toMalinovkaTimeSheet:
            return "На Малиновку"
        case .toMogilevskyaTimeSheet:
            return "На Могилевскую"
        }
    }

}





