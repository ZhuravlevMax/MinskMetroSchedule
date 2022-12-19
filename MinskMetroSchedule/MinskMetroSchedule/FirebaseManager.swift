//
//  FirebaseManager.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 7.11.22.
//

import Foundation
import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase
import FirebaseFirestore

protocol FirebaseManagerProtocol {
    func getTimeSheet(dayofWeek:String, stationName: String, direction: String, completion: @escaping (Result<[Int], Error>) -> Void)
}

class FireBaseManager: FirebaseManagerProtocol {
    
    //MARK: - Объявление переменных
    static let shared = FireBaseManager(settings: FirestoreSettings())
    let ref = Database.database().reference()

    init (settings: FirestoreSettings) {
 
    }
    
    func getTimeSheet(dayofWeek:String, stationName: String, direction: String, completion: @escaping (Result<[Int], Error>) -> Void) {
        ref.child(dayofWeek).child("\(stationName)").getData { [weak self] error, snapshot in
 
            if error != nil {
//                print("ERROR")
//                print("\(error!._code)")
                guard let error else {return}
                completion(.failure(error))
            } else {
                guard let dict = snapshot?.value as? [String:Any],
                      let timeSheet = dict["\(direction)"] as? [Int]
                else {return}
//                UserDefaults.standard.set(dict, forKey: "\(UserDefaultsKeysEnum.allDayData)")
//                let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allDayData)")
                //allData?.value
                //print(timeSheet)
                
                completion(.success(timeSheet))
            }
        }
    }
    
    func getChildCount(completion: @escaping (Result<Int, Error>) -> Void) {
        ref.child("stations").getData { error, snapshot in
            if error != nil {
               // print("ERROR")
               // print("\(error!._code)")
                guard let error else {return}
                completion(.failure(error))
            } else {
                guard let childCount = snapshot?.childrenCount
                //let dict = snapshot?.value as? [String:Any]
                else {return}
                
//                UserDefaults.standard.set(dict, forKey: "\(UserDefaultsKeysEnum.allDayData)")
//                let allData = UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allDayData)") as! [String:Any]
//                let station = allData["vokzalnaya"] as! [String:Any]
//                let stationName = station["stationName"] as? String
                //print(childCount)
                completion(.success(Int(childCount)))
                
            }
        }
    }
    
    func getAllData(completion: @escaping (Result<[String:Any], Error>) -> Void) {
        ref.getData { error, snapshot in
            if error != nil {
                //print("ERROR")
                //print("\(error!._code)")
                guard let error else {return}
                completion(.failure(error))
            } else {
                guard let dailyData = snapshot?.value as? [String:Any] else {return}
                //print(dailyData)
                completion(.success(dailyData))
                
            }
        }
    }
    
}

