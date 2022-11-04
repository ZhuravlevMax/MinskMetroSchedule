//
//  ViewController.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import UIKit

protocol ThirdLineViewProtocol: AnyObject {
    //ViewController methods here
}

class ThirdLineViewController: UIViewController, ThirdLineViewProtocol {
    
    var presenter: ThirdLineViewPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

