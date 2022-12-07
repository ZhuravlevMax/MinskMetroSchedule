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
    func getTimeSheet(stationName: String, direction: String, completion: @escaping ([Int]) -> Void)
}

class FireBaseManager: FirebaseManagerProtocol {
    
    //MARK: - Объявление переменных
    static let shared = FireBaseManager(settings: FirestoreSettings())
    let ref = Database.database().reference()

    init (settings: FirestoreSettings) {
 
    }
    
    func getTimeSheet(stationName: String, direction: String, completion: @escaping ([Int]) -> Void) {
        ref.child("stations").child("\(stationName)").getData { [weak self] error, snapshot in
            
            if error != nil {
                print("ERROR")
                print("\(error!._code)")
            }
            
            guard let dict = snapshot?.value as? [String:Any],
                  let timeSheet = dict["\(direction)"] as? [Int]
            else {return}
            print(timeSheet)
            completion(timeSheet)
            
        }
    }
    
}

