//
//  ViewController.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import UIKit
import SnapKit
import Network

protocol SecondLineViewProtocol: AnyObject {
    //ViewController methods here
    var presenter: SecondLineViewPresenter? {get}
    var numberOfRow: Int {get set}

    func setNav(appearance: UINavigationBarAppearance, titleValue: String)
}

class SecondLineViewController: UIViewController, SecondLineViewProtocol {
    
    //MARK: - Cоздание элементов UI

    private lazy var secondLineTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        tableView.register(SecondLineTableViewCell.self, forCellReuseIdentifier: SecondLineTableViewCell.key)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 68
        return tableView
    }()
    
    //MARK: - Создание переменных
    var presenter: SecondLineViewPresenter?
    var numberOfRow: Int = 0 {
        didSet {
            secondLineTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //MARK: - Добавление элементов на экран
        view.addSubview(secondLineTableView)
    
        guard let presenter else {return}
        
        presenter.setNavBar()
        
        view.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        
        updateViewConstraints()
        
        presenter.setNumberOfRow()
        presenter.setNavBar()
    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        secondLineTableView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }
    
    func setNav(appearance: UINavigationBarAppearance, titleValue: String) {
        //MARK: - Внешний вид navigationController
        title = titleValue
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }

}

extension SecondLineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = secondLineTableView.dequeueReusableCell(withIdentifier: SecondLineTableViewCell.key, for: indexPath) as? SecondLineTableViewCell {
            cell.selectionStyle = .none
            presenter?.configureSecondLineTableViewCell(indexPath: indexPath, cell: cell)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


