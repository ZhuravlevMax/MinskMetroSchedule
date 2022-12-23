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
    
    //MARK: - Создание переменных
    var presenter: FirstLineViewPresenter?
    var numberOfRow: Int = 0 {
        didSet {
            //thirdLineTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
