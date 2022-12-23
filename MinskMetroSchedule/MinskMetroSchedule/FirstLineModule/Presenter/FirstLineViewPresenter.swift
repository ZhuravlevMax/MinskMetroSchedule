//
//  FirstLineViewPresenter.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 23.12.22.
//

import Foundation
import UIKit

protocol FirstLineViewPresenterProtocol: AnyObject {
    
    //var thirdViewControllerBackgroundColor: UIColor {get}
//    func openTimeVC(fromStationName: String,
//                    toStationName: String,
//                    stationName: String)
//    func configureThirdLineTableViewCell(indexPath: IndexPath,
//                                         cell: ThirdLineTableViewCellProtocol)
//    func downloadAllData(view: UIViewController)
//    func showErrorAlert(view: UIViewController)
//    func showSuccessAlert(view: UIViewController)
//    func checkConnection(view: UIViewController)
//    func setNumberOfRow()
}

class FirstLineViewPresenter: FirstLineViewPresenterProtocol {
    
    weak var view: FirstLineViewProtocol?
    private(set) var router: FirstLineRouterProtocol
    
    required init(view: FirstLineViewProtocol,
                  router: FirstLineRouterProtocol) {
        self.view = view
        self.router = router
    }
    
}
