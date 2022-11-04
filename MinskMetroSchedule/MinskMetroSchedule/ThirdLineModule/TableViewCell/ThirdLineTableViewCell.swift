//
//  ThirdLineTableViewCell.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import UIKit

protocol ThirdLineTableViewCellProtocol {
    func configureCell()
}

class ThirdLineTableViewCell: UITableViewCell, ThirdLineTableViewCellProtocol {
    
    static let key = "ThirdLineTableViewCell"
    
    private lazy var stationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()
    
    private lazy var toKovalskayaStationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle("На Ковальскую Слободу", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 2
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.green, for: .highlighted)
        button.dropShadow()
        button.addTarget(self,
                         action: #selector(self.toKovalskayaStationButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var toUbileinayaStationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle("На Ковальскую Слободу", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 2
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.green, for: .highlighted)
        button.dropShadow()
        button.addTarget(self,
                         action: #selector(self.toUbileinayaStationButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var showFullScheduleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle("На Ковальскую Слободу", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 2
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.green, for: .highlighted)
        button.dropShadow()
        button.addTarget(self,
                         action: #selector(self.showFullScheduleButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell() {
        
    }
    
    //MARK: - Действие кнопки toKovalskayaStationButton
    @objc private func toKovalskayaStationButtonPressed() {
        
    }
    
    //MARK: - Действие кнопки toUbileinayaStationButton
    @objc private func toUbileinayaStationButtonPressed() {
        
    }
    
    //MARK: - Действие кнопки showFullScheduleButton
    @objc private func showFullScheduleButtonPressed() {
        
    }
}
