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
}

enum FireBaseFieldsEnum: String {
    case stationName
    case toKovalskayaTimeSheet = "На Ковальскую"
    case toUbileynayaTimeSheet = "На Юбилейную"
    case transferName
    case transferColor
}




