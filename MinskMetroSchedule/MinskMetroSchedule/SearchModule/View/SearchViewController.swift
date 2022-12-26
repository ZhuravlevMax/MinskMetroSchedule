//
//  SearchViewController.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 26.12.22.
//

import UIKit
import SnapKit

protocol SearchViewProtocol: AnyObject {
    //ViewController methods here
    var presenter: SearchViewPresenter? {get}
    
}

class SearchViewController: UIViewController, SearchViewProtocol {
   
    var presenter: SearchViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

    }


}
