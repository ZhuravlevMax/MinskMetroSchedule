//
//  ThirdLineTableViewCell.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import UIKit

protocol ThirdLineTableViewCellProtocol {
    func configureCell(stationNameText: String,
                       toKovalskayaStationButtonIsHidden: Bool,
                       toUbileinayaStationButtonIsHidden: Bool)
}

class ThirdLineTableViewCell: UITableViewCell, ThirdLineTableViewCellProtocol {
    
    static let key = "ThirdLineTableViewCell"
    
    //MARK: - Create items
    private lazy var stationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()
    
    private lazy var toKovalskayaStationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle("На Ковальскую", for: .normal)
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
        button.setTitle("На Юбилейную", for: .normal)
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
        button.setTitle("Полное расписание", for: .normal)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //MARK: - Add items to contentsView
        contentView.addSubview(stationNameLabel)
        contentView.addSubview(toKovalskayaStationButton)
        contentView.addSubview(toUbileinayaStationButton)
        contentView.addSubview(showFullScheduleButton)
        
        updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
    }
    
    func configureCell(stationNameText: String,
                       toKovalskayaStationButtonIsHidden: Bool,
                       toUbileinayaStationButtonIsHidden: Bool) {
        stationNameLabel.text = stationNameText
        toKovalskayaStationButton.isHidden = toKovalskayaStationButtonIsHidden
        toUbileinayaStationButton.isHidden = toUbileinayaStationButtonIsHidden
    }
    
    //MARK: - Set constraints for items
    override func updateConstraints() {
        
        stationNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
        }
        
        toKovalskayaStationButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.equalTo(stationNameLabel.snp.bottom).offset(10)
            $0.width.equalTo(contentView.frame.width * 0.5)
        }
        
        toUbileinayaStationButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.top.equalTo(stationNameLabel.snp.bottom).offset(10)
            $0.width.equalTo(contentView.frame.width * 0.5)
        }
        
        showFullScheduleButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(toKovalskayaStationButton.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(contentView.frame.width * 0.5)
        }
        
        super.updateConstraints()
    }
    
    //MARK: - Action for toKovalskayaStationButton
    @objc private func toKovalskayaStationButtonPressed() {
        print("На Ковальскую")
    }
    
    //MARK: - Action for toUbileinayaStationButton
    @objc private func toUbileinayaStationButtonPressed() {
        print("На Юбилейную")
    }
    
    //MARK: - Action for showFullScheduleButton
    @objc private func showFullScheduleButtonPressed() {
        print("Полное расписание")
    }
}
