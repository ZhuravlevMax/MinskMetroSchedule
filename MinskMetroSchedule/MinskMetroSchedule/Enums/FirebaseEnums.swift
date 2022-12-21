//
//  FirebaseEnums.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 8.11.22.
//

import Foundation

enum FireBaseCollectionsEnum {
    case stations
    case timeSheetWeekday
    case friday
    case weekday
    case weekend
}

enum FireBaseFieldsEnum: String {
    case stationName
    case toKovalskayaTimeSheet = "На Ковальскую"
    case toUbileynayaTimeSheet = "На Юбилейную"
    case transferName
    case transferColor
    case firstLine
    case secondLine
    case thirdLine

}




