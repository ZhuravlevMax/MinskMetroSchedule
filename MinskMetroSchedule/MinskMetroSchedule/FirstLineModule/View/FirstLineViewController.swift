//
//  FirstLineViewController.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 23.12.22.
//

import UIKit
import SnapKit

protocol FirstLineViewProtocol: AnyObject {
    //ViewController methods here
    var presenter: FirstLineViewPresenter? {get}
    var numberOfRow: Int {get set}

}

class FirstLineViewController: UIViewController, FirstLineViewProtocol {
    
    //MARK: - Cоздание элементов UI

    private lazy var firstLineTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        tableView.register(FirstLineTableViewCell.self, forCellReuseIdentifier: FirstLineTableViewCell.key)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 68
        return tableView
    }()
    
    //MARK: - Создание переменных
    var presenter: FirstLineViewPresenter?
    var numberOfRow: Int = 0 {
        didSet {
            firstLineTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let presenter else {return}
        
        view.addSubview(firstLineTableView)
        
        //MARK: - Внешний вид navigationController
        title = "Московская"
        navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.thirdLineNavBarColor)")
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "\(NameColorForThemesEnum.thirdLineTextColor)")]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance

        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        
        if UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.allData)") == nil {
            
        }
        presenter.downloadAllData(view: self)
        if Int(Date().timeIntervalSince1970).decoderDt(format: "EEEE") != UserDefaults.standard.string(forKey: "\(UserDefaultsKeysEnum.currentDay)") {
            presenter.checkConnection(view: self)
        }
        
        presenter.setNumberOfRow()
    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        firstLineTableView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }

}

extension FirstLineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //4
        numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = firstLineTableView.dequeueReusableCell(withIdentifier: FirstLineTableViewCell.key, for: indexPath) as? FirstLineTableViewCell {
            cell.selectionStyle = .none
            presenter?.configureFirstLineTableViewCell(indexPath: indexPath, cell: cell)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
