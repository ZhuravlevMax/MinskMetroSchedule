//
//  FirstLineTableViewCell.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 23.12.22.
//

import UIKit

protocol FirstLineTableViewCellProtocol {
    func configureCell(stationNameText: String,
                       toMalinovkaStationButtonIsHidden: Bool,
                       toUrucheStationButtonIsHidden: Bool,
                       stationNameValue: String,
                       transferName: String,
                       transferColor: UIColor)
    var firstLineTableViewControllerDelegate: FirstLineViewProtocol? {get set}

    func setFirstStationViewDelegate(view: FirstLineViewProtocol)
}

class FirstLineTableViewCell: UITableViewCell, FirstLineTableViewCellProtocol {
    
    static let key = "FirstLineTableViewCell"
    var firstLineTableViewControllerDelegate: FirstLineViewProtocol?
    var stationName: String?
    
    //MARK: - Create items
    private lazy var stationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 20,
                                       weight: .bold)
        label.textColor = UIColor(named: "\(NameColorForThemesEnum.firstLineTextColor)")
        return label
    }()
    
    private lazy var transferLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13,
                                       weight: .bold)
        label.textColor = UIColor(named: "\(NameColorForThemesEnum.firstLineTextColor)")
        return label
    }()
    
    private lazy var toMalinovkaStationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.firstLineButtonColor)")
        button.setTitle("\(FireBaseFieldsEnum.toMalinovkaTimeSheet.rawValue)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 2
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.firstLineButtonColor)"), for: .highlighted)
        button.dropShadow()
        button.addTarget(self,
                         action: #selector(self.toMalinovkaStationButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var toUrucheStationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.firstLineButtonColor)")
        button.setTitle("\(FireBaseFieldsEnum.toUrucheTimeSheet.rawValue)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 2
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.firstLineButtonColor)"), for: .highlighted)
        button.dropShadow()
        button.addTarget(self,
                         action: #selector(self.toUrucheStationButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
//    private lazy var showFullScheduleButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonColor)")
//        button.setTitle("Полное расписание", for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
//        button.layer.cornerRadius = 2
//        button.setTitleColor(.white, for: .normal)
//        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.thirdLineButtonColor)"), for: .highlighted)
//        button.dropShadow()
//        button.addTarget(self,
//                         action: #selector(self.showFullScheduleButtonPressed),
//                         for: .touchUpInside)
//        return button
//    }()

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
        
        //MARK: - Add items to contentsView
        contentView.addSubview(stationNameLabel)
        contentView.addSubview(toMalinovkaStationButton)
        contentView.addSubview(toUrucheStationButton)
        //contentView.addSubview(showFullScheduleButton)
        contentView.addSubview(transferLabel)
        contentView.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        
        updateConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(stationNameText: String,
                       toMalinovkaStationButtonIsHidden: Bool,
                       toUrucheStationButtonIsHidden: Bool,
                       stationNameValue: String,
                       transferName: String,
                       transferColor: UIColor) {
        
        stationNameLabel.text = stationNameText
        toMalinovkaStationButton.isHidden = toMalinovkaStationButtonIsHidden
        toUrucheStationButton.isHidden = toUrucheStationButtonIsHidden
        stationName = stationNameValue
        transferLabel.text = transferName
        transferLabel.textColor = transferColor
        
    }
    
    func setFirstStationViewDelegate(view: FirstLineViewProtocol) {
        firstLineTableViewControllerDelegate = view
    }
    
    //MARK: - Set constraints for items
    override func updateConstraints() {
        
        stationNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
        }
        
        transferLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(stationNameLabel.snp.bottom).offset(5)
        }
        
        toMalinovkaStationButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.equalTo(transferLabel.snp.bottom).offset(20)
            $0.width.equalTo(contentView.frame.width * 0.5)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        toUrucheStationButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.top.equalTo(transferLabel.snp.bottom).offset(20)
            $0.width.equalTo(contentView.frame.width * 0.5)
            $0.height.equalTo(50)
        }
        
        super.updateConstraints()
    }
    
    //MARK: - Action for toMalinovkaStationButton
    @objc private func toMalinovkaStationButtonPressed() {
        guard let fromStationName = stationNameLabel.text, let toStationName = toMalinovkaStationButton.titleLabel?.text, let stationNameUnwrapped = stationName else {return}
        
        firstLineTableViewControllerDelegate?.presenter?.openTimeVC(fromStationName: fromStationName, toStationName: toStationName, stationName: stationNameUnwrapped)
        
        
        print("На Малиновку")
    }
    
    //MARK: - Action for toUrucheStationButton
    @objc private func toUrucheStationButtonPressed() {
        guard let fromStationName = stationNameLabel.text, let toStationName = toUrucheStationButton.titleLabel?.text, let stationNameUnwrapped = stationName else {return}

        firstLineTableViewControllerDelegate?.presenter?.openTimeVC(fromStationName: fromStationName, toStationName: toStationName, stationName: stationNameUnwrapped)
        print("На Уручье")
    }

}
