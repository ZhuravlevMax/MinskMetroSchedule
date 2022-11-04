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
    func setItem(nameLabel: String)

}

class TimeViewController: UIViewController, TimeViewControllerProtocol {
    
    var presenter: TimeViewPresenter?
    
    //MARK: - Create items
    private lazy var fromStation: UILabel = {
        let label = UILabel()
        label.text = "from"
        return label
    }()
    
    private lazy var toStation: UILabel = {
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
    
    private lazy var nextTime: UILabel = {
        let label = UILabel()
        label.text = "Следующий: "
        return label
    }()
    
    private lazy var nextTimeValue: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        return label
    }()
    
    private lazy var InTime: UILabel = {
        let label = UILabel()
        label.text = "Через"
        return label
    }()
    
    private lazy var InTimeValue: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        return label
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Добавление элементов на экран
        view.addSubview(fromStation)
        view.addSubview(toStation)
        view.addSubview(arrowImageView)
        view.addSubview(nextTime)
        view.addSubview(nextTimeValue)
        view.addSubview(InTime)
        view.addSubview(InTimeValue)
        
        view.backgroundColor = .white

    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        fromStation.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.width.equalTo(view.frame.width * 0.3)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
        
        toStation.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.width.equalTo(view.frame.width * 0.3)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
        super.updateViewConstraints()
    }
    
    func setItem(nameLabel: String) {
        fromStation.text = nameLabel
    }

}
