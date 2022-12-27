//
//  SearchTableViewCell.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 27.12.22.
//

import UIKit

protocol SearchTableViewCellProtocol {
//    func configureCell(stationNameText: String,
//                       toMalinovkaStationButtonIsHidden: Bool,
//                       toUrucheStationButtonIsHidden: Bool,
//                       stationNameValue: String,
//                       transferName: String,
//                       transferColor: UIColor)
    var searchViewControllerDelegate: SearchViewProtocol? {get set}

  //  func setFirstStationViewDelegate(view: FirstLineViewProtocol)
}

class SearchTableViewCell: UITableViewCell, SearchTableViewCellProtocol {

    static let key = "SearchTableViewCell"
    var searchViewControllerDelegate: SearchViewProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        updateConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
        
        

}
