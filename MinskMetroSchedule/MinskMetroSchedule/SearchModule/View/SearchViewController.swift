//
//  SearchViewController.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 26.12.22.
//

import UIKit
import SnapKit
import Firebase

protocol SearchViewProtocol: AnyObject {
    //ViewController methods here
    var presenter: SearchViewPresenter? {get}
    var stations: [String : Any]? {get set}
    var filteredStations: [String : Any] {get set}
    
}

class SearchViewController: UIViewController, SearchViewProtocol {
    
    //MARK: - Создание переменных
    
    var stations: [String : Any]?
    var filteredStations: [String : Any] = [:] {
        didSet {
            searchTableView.reloadData()
            if filteredStations.count == 0 {
                
                guard var searchTextFieldIsEmpty = searchController.searchBar.searchTextField.text?.isEmpty
                else {return}
                
                switch searchTextFieldIsEmpty {
                case true:
                    searchInfoLabel.text = "Введите название станции"
                case false:
                    searchInfoLabel.text = "Проверьте название введенной станции"
                }
                
                UIView.animate(withDuration: 0.7) { [weak self] in
                    guard let self = self else {return}
                    self.searchInfoView.alpha = 1
                }
            } else {
                searchInfoView.alpha = 0
            }
            
        }
    }
    
    
    
    var presenter: SearchViewPresenter?
    
    //MARK: - Cоздание элементов UI
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.searchBarStyle = .default
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    private lazy var searchInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var searchInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите название станции"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        //imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "search100")
        return imageView
    }()
    
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchTableViewCell.self,
                           forCellReuseIdentifier: SearchTableViewCell.key)
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchTableView)
        view.addSubview(searchInfoView)
        searchInfoView.addSubview(searchInfoLabel)
        searchInfoView.addSubview(mainImageView)
        
        view.backgroundColor = .white
        //MARK: - Работа с searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false

        //MARK: - Работа с navigationController
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        presenter?.getStations()
        
        print(stations)
        
        print(filteredStations)
    }

    
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        searchTableView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        searchInfoView.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
            $0.height.width.equalTo(250)
        }
        
        mainImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(20)
        }
        
        searchInfoLabel.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(10)
        }
        
        super.updateViewConstraints()
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = searchTableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.key, for: indexPath) as? SearchTableViewCell {
            cell.selectionStyle = .none
            presenter?.configureSearchTableViewCell(indexPath: indexPath, cell: cell, stations: filteredStations)
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
       guard let text = searchController.searchBar.text, let stations else {return}
        presenter?.filterModelsForSearch(stations: stations, searchText: text)
    }
}
