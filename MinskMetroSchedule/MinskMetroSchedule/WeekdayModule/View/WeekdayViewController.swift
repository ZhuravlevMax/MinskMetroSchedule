//
//  WeekdayViewController.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 6.12.22.
//

import UIKit
import SnapKit

protocol WeekdayViewControllerProtocol: AnyObject {
    //ViewController methods here
    var presenter: WeekdayPresenter? {get}
    
    func setItems(fromStationName: String,
                  toStationName: String,
                  dayTypeValue: DayTypeEnum)
    
}

class WeekdayViewController: UIViewController, WeekdayViewControllerProtocol {
    
    var presenter: WeekdayPresenter?
    private var fromStation: String?
    private var toStation: String?
    private var dayType: String?
    
    private lazy var dayTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Будние дни"
        label.font = UIFont.systemFont(ofSize: 20,
                                       weight: .bold)
        return label
    }()
    
    private lazy var stationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "stationName"
        label.font = UIFont.systemFont(ofSize: 20,
                                       weight: .bold)
        return label
    }()
    
    private lazy var toStationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hour"
        label.font = UIFont.systemFont(ofSize: 20,
                                       weight: .bold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        view.addSubview(dayTypeLabel)
        view.addSubview(stationNameLabel)
        view.addSubview(toStationNameLabel)
        
        print(fromStation)
        print(toStation)
        print(dayType)
    }
    func setItems(fromStationName: String,
                  toStationName: String,
                  dayTypeValue: DayTypeEnum) {
        stationNameLabel.text = fromStationName
        toStationNameLabel.text = toStationName
        dayTypeLabel.text = dayTypeValue.rawValue
    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        dayTypeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
        }
        
        stationNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dayTypeLabel.snp.bottom).offset(10)
        }
        
        toStationNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stationNameLabel.snp.bottom).offset(10)
        }
        
        super.updateViewConstraints()
    }
}
