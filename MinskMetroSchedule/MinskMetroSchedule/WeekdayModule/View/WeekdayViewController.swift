//
//  WeekdayViewController.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 6.12.22.
//

import UIKit

protocol WeekdayViewControllerProtocol: AnyObject {
    //ViewController methods here
    var presenter: WeekdayPresenter? {get}
    func setItems(fromStationName: String,
                  toStationName: String)
    
}

class WeekdayViewController: UIViewController, WeekdayViewControllerProtocol {
    
    var presenter: WeekdayPresenter?
    private var fromStation: String?
    private var toStation: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        print(fromStation)
        print(toStation)
    }
    func setItems(fromStationName: String,
                  toStationName: String) {
        fromStation = fromStationName
        toStation = toStationName
    }
    
}
