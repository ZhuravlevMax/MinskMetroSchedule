//
//  WeekdayViewController.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 6.12.22.
//

import UIKit
import SnapKit

protocol FullScheduleViewControllerProtocol: AnyObject {
    //ViewController methods here
    var presenter: FullSchedulePresenter? {get}
    
    func setItems(fromStationName: String,
                  toStationName: String,
                  dayTypeValue: String)
    
    func setNumberOfRow(rowNumber: Int)
    
}

class FullScheduleViewController: UIViewController, FullScheduleViewControllerProtocol {
    
    var presenter: FullSchedulePresenter?
    private var fromStation: String?
    private var toStation: String?
    private var dayType: String?
    private var numberOfRow: Int = 0
    
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
    
    private lazy var timeSheetTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimeSheetTableViewCell.self, forCellReuseIdentifier: TimeSheetTableViewCell.key)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 10
        //tableView.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        view.addSubview(dayTypeLabel)
        view.addSubview(stationNameLabel)
        view.addSubview(toStationNameLabel)
        view.addSubview(timeSheetTableView)
        
//        print(fromStation)
//        print(toStation)
//        print(dayType)
        
        //view.addGradientBackground(firstColor: .green, secondColor: .white)
        
        
        guard let toStationLabelText = toStationNameLabel.text, let stationNameText = stationNameLabel.text, let stationName = StationNamesEnum(rawValue: stationNameText)  else {return}
        presenter?.setNumberOfRow(stationName: "\(stationName)", toStation: toStationLabelText, timeSheetTableViewValue: timeSheetTableView)
    }
    
    func setItems(fromStationName: String,
                  toStationName: String,
                  dayTypeValue: String) {
        stationNameLabel.text = fromStationName
        toStationNameLabel.text = toStationName
        dayTypeLabel.text = "\(dayTypeValue)"
    }
    
    func setNumberOfRow(rowNumber: Int) {
        numberOfRow = rowNumber
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
        
        timeSheetTableView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(toStationNameLabel.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        
        super.updateViewConstraints()
    }
}

extension FullScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let toStationName = toStationNameLabel.text, let stationName = stationNameLabel.text else {return UITableViewCell()}
        
        if let cell = timeSheetTableView.dequeueReusableCell(withIdentifier: TimeSheetTableViewCell.key, for: indexPath) as? TimeSheetTableViewCell {
            presenter?.configureTimeSheetTableViewCell(indexPath: indexPath, cell: cell, stationName: stationName , toStation: toStationName)
            cell.backgroundColor = .clear
            return cell
        }
        return UITableViewCell()
    }
    
    
}
