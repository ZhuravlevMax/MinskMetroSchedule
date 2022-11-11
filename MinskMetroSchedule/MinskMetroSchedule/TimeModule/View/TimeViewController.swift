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
    
    private lazy var nextTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Следующий поезд в: "
        return label
    }()
    
    private lazy var nextTimeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "--:--"
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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        view.addSubview(toStationLabel)
        view.addSubview(arrowImageView)
        view.addSubview(nextTimeLabel)
        view.addSubview(nextTimeValueLabel)
        view.addSubview(InTimeLabel)
        view.addSubview(InTimeValueLabel)
        
        view.backgroundColor = .white
        
        guard let toStationLabelText = toStationLabel.text, let stationNameText = fromStationLabel.text, let stationName = StationNamesEnum(rawValue: stationNameText)  else {return}
        presenter?.setNextTime(toStationName: toStationLabelText, stationName: "\(stationName)")

    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        fromStationLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.width.equalTo(view.frame.width * 0.4)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        toStationLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.width.equalTo(view.frame.width * 0.4)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        nextTimeLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.equalTo(fromStationLabel.snp.bottom).offset(10)
        }
        
        nextTimeValueLabel.snp.makeConstraints {
            $0.left.equalTo(nextTimeLabel.snp.right).offset(10)
            $0.top.equalTo(fromStationLabel.snp.bottom).offset(10)
        }
        
        InTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
            $0.top.equalTo(nextTimeLabel.snp.bottom).offset(10)
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
