//
//  ViewController.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import UIKit
import SnapKit
import Network

protocol ThirdLineViewProtocol: AnyObject {
    //ViewController methods here
    var presenter: ThirdLineViewPresenter? {get}

}

class ThirdLineViewController: UIViewController, ThirdLineViewProtocol {
    
    //MARK: - Cоздание элементов UI

    private lazy var thirdLineTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        tableView.register(ThirdLineTableViewCell.self, forCellReuseIdentifier: ThirdLineTableViewCell.key)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 68
        return tableView
    }()
    
    //MARK: - Создание переменных
    var presenter: ThirdLineViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //MARK: - Добавление элементов на экран
        view.addSubview(thirdLineTableView)
        
        guard let presenter else {return}
        
        //MARK: - Внешний вид navigationController
        title = "Зеленолужская"
        navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.thirdLineNavBarColor)")
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "\(NameColorForThemesEnum.thirdLineTextColor)")]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        
        updateViewConstraints()
        
        if UserDefaults.standard.object(forKey: "\(UserDefaultsKeysEnum.kovalskayatoUbileynayaTimeSheet)") == nil {
            presenter.downloadAllData(view:self)
        }
        presenter.checkConnection(view: self)
 
    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        thirdLineTableView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }

}

extension ThirdLineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = thirdLineTableView.dequeueReusableCell(withIdentifier: ThirdLineTableViewCell.key, for: indexPath) as? ThirdLineTableViewCell {
            cell.selectionStyle = .none
            presenter?.configureThirdLineTableViewCell(indexPath: indexPath, cell: cell)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


