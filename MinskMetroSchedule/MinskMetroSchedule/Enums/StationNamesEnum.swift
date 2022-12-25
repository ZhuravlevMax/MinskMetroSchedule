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
    
    case malinovka = "Малиновка"
    case petrovschina = "Петровщина"
    case mihalovo = "Михалово"
    case grushevka = "Грушевка"
    case institut = "Институт культуры"
    case lenina = "Пл.Ленина"
    case oktyabrskaya = "Октябрьская"
    case pobeda = "Пл.Победы"
    case kolasa = "Пл.Якуба Коласа"
    case akademia = "Академия наук"
    case park = "Парк Челюскинцев"
    case moskovskaya = "Московская"
    case vostok = "Восток"
    case borisovskiy = "Борисовский тракт"
    case uruche = "Уручье"
    
    case mogilevskya = "Могилевская"
    case avtozavodskaya = "Автозаводская"
    case partizanskaya = "Партизанская"
    case traktorniy = "Тракторный завод"
    case proletarskaya = "Пролетарская"
    case pervomaiskaya = "Первомайская"
    case kupalovskaya = "Купаловская"
    case nemiga = "Немига"
    case frunzenskaya = "Фрунзенская"
    case molodezhnaya = "Молодежная"
    case pushkinskaya = "Пушкинская"
    case sportivnaya = "Спортивная"
    case kuncevshina = "Кунцевищна"
    case kamenka = "Каменная горка"
}

enum firstStationIndexEnum: Int {
    case malinovka = 0
    case petrovschina
    case mihalovo
    case grushevka
    case institut
    case lenina
    case oktyabrskaya
    case pobeda
    case kolasa
    case akademia
    case park
    case moskovskaya
    case vostok
    case borisovskiy
    case uruche
}

enum secondStationIndexEnum: Int {
    case mogilevskya = 0
    case avtozavodskaya
    case partizanskaya
    case traktorniy
    case proletarskaya
    case pervomaiskaya
    case kupalovskaya
    case nemiga
    case frunzenskaya
    case molodezhnaya
    case pushkinskaya
    case sportivnaya
    case kuncevshina
    case kamenka
}

enum thirdStationIndexEnum: Int {
    case kovalskaya = 0
    case vokzalnaya
    case bogushevicha
    case ubileynaya
}


