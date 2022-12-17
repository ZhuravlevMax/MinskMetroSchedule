//
//  TimeViewController.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import UIKit
import SnapKit

protocol TimeViewControllerProtocol: AnyObject {
    //ViewController methods here
    var presenter: TimeViewPresenter? {get}
    var numberOfRow: Int {get set}
    func setItems(fromStationName: String,
                  toStationName: String)
    func setNextTimeLabel(nextTime: String)
    func setDayOfWeek(dayOfWeekValue: String)
    
}

class TimeViewController: UIViewController, TimeViewControllerProtocol {
    
    var numberOfRow: Int = 0
    var presenter: TimeViewPresenter?
    
    
    //MARK: - Create items
    private lazy var fromStationLabel: UILabel = {
        let label = UILabel()
        label.text = "from"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30,
                                       weight: .bold)
        label.textColor = UIColor(named: "\(NameColorForThemesEnum.thirdLineTextColor)")
        return label
    }()
    
    private lazy var toStationLabel: UILabel = {
        let label = UILabel()
        label.text = "to"
        return label
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(systemName: "arrow.right")
        return imageView
    }()
    
    private lazy var viewForNextTime: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var nextTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Следующий поезд в: "
        label.font = UIFont.systemFont(ofSize: 20,
                                       weight: .bold)
        return label
    }()
    
    private lazy var nextTimeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "--:--"
        label.font = UIFont.systemFont(ofSize: 40,
                                       weight: .bold)
        label.textColor = UIColor(named: "\(NameColorForThemesEnum.thirdLineTextColor)")
        return label
    }()
    
    private lazy var InTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Через: "
        return label
    }()
    
    private lazy var InTimeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        return label
    }()
    
    private lazy var dayOfWeekLabel: UILabel = {
        let label = UILabel()
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
        tableView.estimatedRowHeight = 68
        tableView.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        return tableView
    }()
    
    private lazy var fullScheduleLabel: UILabel = {
        let label = UILabel()
        label.text = "Полное расписание"
        label.font = UIFont.systemFont(ofSize: 16,
                                       weight: .bold)
        label.textColor = UIColor(named: "\(NameColorForThemesEnum.thirdLineTextColor)")
        return label
    }()
    
    private lazy var showWeekdaysButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonColor)")
        button.setTitle("Будние дни", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 2
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonTitleTextColor)"), for: .normal)
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonColor)"), for: .highlighted)
        button.dropShadow()
        button.addTarget(self,
                         action: #selector(self.showWeekdaysButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var showWeekendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonColor)")
        button.setTitle("Выходные дни", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 2
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonTitleTextColor)"), for: .normal)
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonColor)"), for: .highlighted)
        button.dropShadow()
        button.addTarget(self,
                         action: #selector(self.showWeekdaysButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Внешний вид navigationController
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.thirdLineNavBarColor)")
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "\(NameColorForThemesEnum.thirdLineTextColor)")]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = UIColor(named: "\(NameColorForThemesEnum.thirdLineTextColor)")
        
        
        //MARK: - Добавление элементов на экран
        view.addSubview(fromStationLabel)
        view.addSubview(viewForNextTime)
        viewForNextTime.addSubview(nextTimeLabel)
        viewForNextTime.addSubview(nextTimeValueLabel)
        view.addSubview(dayOfWeekLabel)
        view.addSubview(timeSheetTableView)
        view.addSubview(fullScheduleLabel)
        view.addSubview(showWeekdaysButton)
        view.addSubview(showWeekendButton)
        
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        
        guard let toStationLabelText = toStationLabel.text, let stationNameText = fromStationLabel.text, let stationName = StationNamesEnum(rawValue: stationNameText)  else {return}
        presenter?.setNextTime(toStationName: toStationLabelText, stationName: "\(stationName)")
        
        presenter?.setNumberOfRow(stationName: "\(stationName)", toStation: toStationLabelText, timeSheetTableViewValue: timeSheetTableView)
        
        presenter?.checkDayOfWeek()
        
    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        fromStationLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(view.frame.width * 0.9)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        viewForNextTime.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(fromStationLabel.snp.bottom).offset(10)
            $0.height.equalTo(60)
        }
        
        nextTimeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
        }
        
        nextTimeValueLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(nextTimeLabel.snp.right).offset(10)
        }
        
        dayOfWeekLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(viewForNextTime.snp.bottom).offset(3)
        }
        
        timeSheetTableView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(dayOfWeekLabel.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
        
        fullScheduleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(timeSheetTableView.snp.bottom).offset(10)
        }
        
        showWeekdaysButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.top.equalTo(fullScheduleLabel.snp.bottom).offset(20)
            $0.width.equalTo(view.frame.width * 0.3)
            $0.height.equalTo(50)
        }
        
        showWeekendButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(fullScheduleLabel.snp.bottom).offset(20)
            $0.width.equalTo(view.frame.width * 0.3)
            $0.height.equalTo(50)
        }
        
        super.updateViewConstraints()
    }
    
    func setItems(fromStationName: String,
                  toStationName: String) {
        fromStationLabel.text = fromStationName
        toStationLabel.text = toStationName
        title = toStationName
    }
    
    func setNextTimeLabel(nextTime: String) {
        nextTimeValueLabel.text = nextTime
    }
    
    func setDayOfWeek(dayOfWeekValue: String) {
        dayOfWeekLabel.text = dayOfWeekValue
    }
    
}

extension TimeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let toStationName = toStationLabel.text, let stationName = fromStationLabel.text else {return UITableViewCell()}
        
        if let cell = timeSheetTableView.dequeueReusableCell(withIdentifier: TimeSheetTableViewCell.key, for: indexPath) as? TimeSheetTableViewCell {
            presenter?.configureTimeSheetTableViewCell(indexPath: indexPath, cell: cell, stationName: stationName , toStation: toStationName)
            cell.backgroundColor = .clear
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Cледующие поезда сегодня:"
        label.font = UIFont.systemFont(ofSize: 16,
                                       weight: .bold)
        
        label.textColor = UIColor(named: "\(NameColorForThemesEnum.thirdLineTextColor)")
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK: - Action for showWeekdaysButton
    @objc private func showWeekdaysButtonPressed() {
        
        guard  let fromStationName = fromStationLabel.text, let toStationName = toStationLabel.text else {return}
        
        presenter?.openWeekdayVC(fromStationName: fromStationName, toStationName: toStationName, dayTypeValue: DayTypeEnum.weekday)
        
        print("На Ковальскую")
    }
    
    
}
