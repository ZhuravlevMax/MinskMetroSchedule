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
    case transferName
    case transferColor
    case firstLine
    case secondLine
    case thirdLine

}




