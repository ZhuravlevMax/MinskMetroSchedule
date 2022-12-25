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
    var line: String? {get set}
    var numberOfRow: Int {get set}
    
    func setNav(appearance: UINavigationBarAppearance, navTintColor: UIColor)
    func setItems(fromStationName: String,
                  toStationName: String,
                  buttonColor: UIColor,
                  textColor: UIColor)
    func setNextTimeLabel(nextTime: String)
    func setDayOfWeek(dayOfWeekValue: String)
    
}

class TimeViewController: UIViewController, TimeViewControllerProtocol {
    
    var numberOfRow: Int = 0 {
        didSet {
            timeSheetTableView.reloadData()
        }
    }
    var presenter: TimeViewPresenter?
    var line: String?
    
    
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
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        button.layer.cornerRadius = 2
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonTitleTextColor)"), for: .normal)
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonColor)"), for: .highlighted)
        button.dropShadow()
        button.addTarget(self,
                         action: #selector(self.showWeekdaysButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var showFridayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonColor)")
        button.setTitle("Пятница", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        button.layer.cornerRadius = 2
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonTitleTextColor)"), for: .normal)
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonColor)"), for: .highlighted)
        button.dropShadow()
        button.addTarget(self,
                         action: #selector(self.showFridayButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var showWeekendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonColor)")
        button.setTitle("Выходные дни", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        button.layer.cornerRadius = 2
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonTitleTextColor)"), for: .normal)
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonColor)"), for: .highlighted)
        button.dropShadow()
        button.addTarget(self,
                         action: #selector(self.showWeekendButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        view.addSubview(showFridayButton)
        
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        
        guard let toStationLabelText = toStationLabel.text,
              let stationNameText = fromStationLabel.text,
              let stationName = StationNamesEnum(rawValue: stationNameText),
              let lineValue = line else {return}
        
        presenter?.setNumberOfRow(stationName: "\(stationName)", toStation: toStationLabelText, line: lineValue)
        presenter?.setNextTime(toStationName: toStationLabelText, stationName: "\(stationName)", line: lineValue)
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
            $0.width.equalTo(view.frame.width * 0.26)
            $0.height.equalTo(50)
        }
        
        showFridayButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(fullScheduleLabel.snp.bottom).offset(20)
            $0.width.equalTo(view.frame.width * 0.26)
            $0.height.equalTo(50)
        }
        
        showWeekendButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.top.equalTo(fullScheduleLabel.snp.bottom).offset(20)
            $0.width.equalTo(view.frame.width * 0.26)
            $0.height.equalTo(50)
        }
        
        super.updateViewConstraints()
    }
    
    func setNav(appearance: UINavigationBarAppearance, navTintColor: UIColor) {
        //MARK: - Внешний вид navigationController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        
    }
    
    func setItems(fromStationName: String,
                  toStationName: String,
                  buttonColor: UIColor,
                  textColor: UIColor) {
        fromStationLabel.text = fromStationName
        fromStationLabel.textColor = textColor
        toStationLabel.text = toStationName
        toStationLabel.textColor = textColor
        nextTimeLabel.textColor = textColor
        fullScheduleLabel.textColor = textColor
        nextTimeValueLabel.textColor = textColor
        showWeekendButton.backgroundColor = buttonColor
        showWeekdaysButton.backgroundColor = buttonColor
        showWeekendButton.setTitleColor(textColor, for: .normal)
        showWeekdaysButton.setTitleColor(textColor, for: .normal)
        showFridayButton.backgroundColor = buttonColor
        showFridayButton.setTitleColor(textColor, for: .normal)
        
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
        
        guard let toStationName = toStationLabel.text,
                let stationName = fromStationLabel.text,
        let lineValue = line else {return UITableViewCell()}
        
        if let cell = timeSheetTableView.dequeueReusableCell(withIdentifier: TimeSheetTableViewCell.key, for: indexPath) as? TimeSheetTableViewCell {
            presenter?.configureTimeSheetTableViewCell(indexPath: indexPath, cell: cell, stationName: stationName , toStation: toStationName, line: lineValue)
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
        
        label.textColor = UIColor(named: "\(NameColorForThemesEnum.defaultColor)")
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK: - Action for showWeekdaysButton
    @objc private func showWeekdaysButtonPressed() {
        
        guard  let fromStationName = fromStationLabel.text,
               let toStationName = toStationLabel.text
        else {return}
        let dayOfWeek = DayTypeEnum.weekday.rawValue
        let dayType = "\(FireBaseCollectionsEnum.weekday)"
        
        presenter?.openWeekdayVC(fromStationName: fromStationName, toStationName: toStationName, dayOfWeek: dayOfWeek, dayType: dayType)
        
        print("На Ковальскую")
    }
    
    //MARK: - Action for showFridayButton
    @objc private func showFridayButtonPressed() {
        
        guard  let fromStationName = fromStationLabel.text,
               let toStationName = toStationLabel.text else {return}
        let dayOfWeek = DayTypeEnum.weekend.rawValue
        let dayType = "\(FireBaseCollectionsEnum.weekend)"
        
        presenter?.openWeekdayVC(fromStationName: fromStationName, toStationName: toStationName, dayOfWeek: dayOfWeek, dayType: dayType)
        
        print("На Ковальскую")
    }
    
    //MARK: - Action for showWeekdaysButton
    @objc private func showWeekendButtonPressed() {
        
        guard  let fromStationName = fromStationLabel.text,
               let toStationName = toStationLabel.text else {return}
        let dayOfWeek = DayTypeEnum.weekend.rawValue
        let dayType = "\(FireBaseCollectionsEnum.weekend)"
        
        presenter?.openWeekdayVC(fromStationName: fromStationName, toStationName: toStationName, dayOfWeek: dayOfWeek, dayType: dayType)
        
        print("На Ковальскую")
    }
    
}
