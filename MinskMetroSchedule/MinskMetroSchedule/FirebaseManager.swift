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
    func getMultipleAll(collection: String, completion: @escaping ([QueryDocumentSnapshot]) -> Void)
    func getScheduleToKovalskaya(model: QueryDocumentSnapshot) -> [Int]
    func getScheduleToUbileynya(model: QueryDocumentSnapshot) -> [Int]
    func getModelName(model: QueryDocumentSnapshot) -> String
}

class FireBaseManager: FirebaseManagerProtocol {
    
    //MARK: - Объявление переменных
    static let shared = FireBaseManager(settings: FirestoreSettings())
    var db = Firestore.firestore()
    let settings: FirestoreSettings
    let ref = Database.database().reference()
    var userFavorites: [String]?
    
    
    init (settings: FirestoreSettings) {
        self.settings = settings
        Firestore.firestore().settings = settings
    }
    
    //MARK: - метод для получения всей коллекции
    func getMultipleAll(collection: String, completion: @escaping ([QueryDocumentSnapshot]) -> Void) {

        db.collection(collection).getDocuments() { (querySnapshot, err) in
            guard let querySnapshot = querySnapshot else {return}
            let modelsArray = querySnapshot.documents
            completion(modelsArray)
        }
    }
    
    //MARK: - метод для получения массива ссылок объекта
    func getScheduleToUbileynya(model: QueryDocumentSnapshot) -> [Int] {
        let modelData = model.data()
        
        let imagesDict = modelData.first { key, value in
            return key.contains("\(FireBaseFieldsEnum.toUbileynaya)")
        }
        
        if let imagesDictUnwrapped = imagesDict, let imageUrls = imagesDictUnwrapped.value as? [Int] {
            return imageUrls
        }
        return [0]
    }
    
    //MARK: - метод для получения массива ссылок объекта
    func getScheduleToKovalskaya(model: QueryDocumentSnapshot) -> [Int] {
        let modelData = model.data()
        
        let imagesDict = modelData.first { key, value in
            return key.contains("\(FireBaseFieldsEnum.toKovalskaya)")
        }
        
        if let imagesDictUnwrapped = imagesDict, let imageUrls = imagesDictUnwrapped.value as? [Int] {
            return imageUrls
        }
        return [0]
    }
    
    //MARK: - метод для получения названия станции
    func getModelName(model: QueryDocumentSnapshot) -> String {
        let modelData = model.data()
        let nameDict = modelData.first { key, value in
            return key.contains("\(FireBaseFieldsEnum.stationName)")
        }
        if let nameDictUnwrapped = nameDict, let name = nameDictUnwrapped.value as? String {
            return name
        }
        return ""
    }
}

