//
//  StationNamesEnum.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 8.11.22.
//

import Foundation

enum StationNamesEnum: String {
    case kovalskaya = "Ковальская слобода"
    case vokzalnaya = "Вокзальная"
    case bogushevicha = "Пл.Франтишка Богушевича"
    case ubileynaya = "Юбилейная площадь"
}

enum directionsEnum: String {
    case toKovalskaya = "На Ковальскую"
    case toUbileynaya = "На Юбилейную"
}

enum StationNamesNumEnum: Int {
    case kovalskaya = 0
    case vokzalnaya
    case bogushevicha
    case ubileynaya
}

