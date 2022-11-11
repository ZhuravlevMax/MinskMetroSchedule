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
    func setItems(fromStationName: String,
                  toStationName: String)
    func setNextTimeLabel(nextTime: String)
    
}

class TimeViewController: UIViewController, TimeViewControllerProtocol {
    
    var presenter: TimeViewPresenter?
    
    //MARK: - Create items
    private lazy var fromStationLabel: UILabel = {
        let label = UILabel()
        label.text = "from"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30,
                                       weight: .bold)
        label.textColor = UIColor(red: 19/255, green: 185/255, blue: 86/255, alpha: 1)
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
        label.textColor = UIColor(red: 19/255, green: 185/255, blue: 86/255, alpha: 1)
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
    
    private lazy var timeSheetTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimeSheetTableViewCell.self, forCellReuseIdentifier: TimeSheetTableViewCell.key)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 68
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Внешний вид navigationController
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 124/255, green: 252/255, blue: 0/255, alpha: 1)
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 19/255, green: 185/255, blue: 86/255, alpha: 1)]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = UIColor(red: 19/255, green: 185/255, blue: 86/255, alpha: 1)
        
        
        //MARK: - Добавление элементов на экран
        view.addSubview(fromStationLabel)
        //view.addSubview(toStationLabel)
        //view.addSubview(arrowImageView)
        view.addSubview(viewForNextTime)
        viewForNextTime.addSubview(nextTimeLabel)
        viewForNextTime.addSubview(nextTimeValueLabel)
        //        view.addSubview(InTimeLabel)
        //        view.addSubview(InTimeValueLabel)
        view.addSubview(timeSheetTableView)
        
        view.backgroundColor = .white
        
        guard let toStationLabelText = toStationLabel.text, let stationNameText = fromStationLabel.text, let stationName = StationNamesEnum(rawValue: stationNameText)  else {return}
        presenter?.setNextTime(toStationName: toStationLabelText, stationName: "\(stationName)")
        
    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        fromStationLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(view.frame.width * 0.9)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        //        toStationLabel.snp.makeConstraints {
        //            $0.right.equalToSuperview().inset(10)
        //            $0.width.equalTo(view.frame.width * 0.4)
        //            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        //        }
        
        //        arrowImageView.snp.makeConstraints {
        //            $0.centerX.equalToSuperview()
        //            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        //        }
        
        viewForNextTime.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalTo(fromStationLabel.snp.bottom).offset(10)
            $0.height.equalTo(60)
        }
        
        nextTimeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
            //$0.top.equalTo(fromStationLabel.snp.bottom).offset(10)
        }
        
        nextTimeValueLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(nextTimeLabel.snp.right).offset(10)
            // $0.top.equalTo(fromStationLabel.snp.bottom).offset(10)
        }
        
        //        InTimeLabel.snp.makeConstraints {
        //            $0.centerX.equalToSuperview()
        //            $0.left.equalToSuperview().inset(10)
        //            $0.top.equalTo(nextTimeLabel.snp.bottom).offset(10)
        //        }
        
        timeSheetTableView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(viewForNextTime.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
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
    
}

extension TimeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = timeSheetTableView.dequeueReusableCell(withIdentifier: TimeSheetTableViewCell.key, for: indexPath) as? TimeSheetTableViewCell {
            presenter?.configureTimeSheetTableViewCell(indexPath: indexPath, cell: cell)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Следующее время поездов:"
        label.font = UIFont.systemFont(ofSize: 16,
                                       weight: .bold)
        label.textColor = .black
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
}
