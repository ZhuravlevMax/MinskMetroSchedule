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
    var stations: [[String : Any]]? {get set}
    
}

class SearchViewController: UIViewController, SearchViewProtocol, UISearchResultsUpdating {
    
    //MARK: - Создание переменных
    private var filteredStations: [[String : Any]] = [] {
        didSet {
//            if filteredModels.count == 0 {
//                UIView.animate(withDuration: 0.7) { [weak self] in
//                    guard let self = self else {return}
//                    self.searchInfoView.alpha = 1
//                }
//            } else {
//                searchInfoView.alpha = 0
//            }
            
        }
    }
    
    var stations: [[String : Any]]?
    var presenter: SearchViewPresenter?
    
    //MARK: - Cоздание элементов UI
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.searchBarStyle = .default
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
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
        
        view.backgroundColor = .white
        //MARK: - Работа с searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false

        //MARK: - Работа с navigationController
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else {return}
//        filterModelsForSearch(searchText: text)
    }
    
    //MARK: - Метод для сравения введенного текста с массивом объектов по именам
    func filterModelsForSearch(searchText: String) {

    }
    
    //MARK: - Работа с констрейнтами
    override func updateViewConstraints() {
        
        searchTableView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
