//
//  SecondLineTableViewCell.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 4.11.22.
//

import UIKit

protocol SecondLineTableViewCellProtocol {
    func configureCell(stationNameText: String,
                       toMogilevskyaStationButtonIsHidden: Bool,
                       toKamenkaStationButtonIsHidden: Bool,
                       stationNameValue: String,
                       transferName: String,
                       transferColor: UIColor)
    var secondLineTableViewControllerDelegate: SecondLineViewProtocol? {get set}
    
    func setSecondStationViewDelegate(view: SecondLineViewProtocol)
}

class SecondLineTableViewCell: UITableViewCell, SecondLineTableViewCellProtocol {
    
    static let key = "SecondLineTableViewCell"
    var secondLineTableViewControllerDelegate: SecondLineViewProtocol?
    var stationName: String?
    
    //MARK: - Create items
    private lazy var stationNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 20,
                                       weight: .bold)
        label.textColor = UIColor(named: "\(NameColorForThemesEnum.secondLineTextColor)")
        return label
    }()
    
    private lazy var transferLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13,
                                       weight: .bold)
        label.textColor = UIColor(named: "\(NameColorForThemesEnum.secondLineTextColor)")
        return label
    }()
    
    private lazy var toMogilevskyaStationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.secondLineButtonColor)")
        button.setTitle("\(FireBaseFieldsEnum.toMogilevskyaTimeSheet.rawValue)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 2
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.secondLineButtonTitleTextColor)"), for: .normal)
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.secondLineButtonColor)"), for: .highlighted)
        button.dropShadow()
        button.addTarget(self,
                         action: #selector(self.toMogilevskyaStationButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var toKamenkaStationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.secondLineButtonColor)")
        button.setTitle("\(FireBaseFieldsEnum.toKamenkaTimeSheet.rawValue)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 2
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.secondLineButtonTitleTextColor)"), for: .normal)
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.secondLineButtonColor)"), for: .highlighted)
        button.dropShadow()
        button.addTarget(self,
                         action: #selector(self.toKamenkaStationButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var showFullScheduleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.secondLineButtonColor)")
        button.setTitle("Полное расписание", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 2
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.secondLineButtonColor)"), for: .highlighted)
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
        contentView.addSubview(toMogilevskyaStationButton)
        contentView.addSubview(toKamenkaStationButton)
        //contentView.addSubview(showFullScheduleButton)
        contentView.addSubview(transferLabel)
        contentView.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        
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
                       toMogilevskyaStationButtonIsHidden: Bool,
                       toKamenkaStationButtonIsHidden: Bool,
                       stationNameValue: String,
                       transferName: String,
                       transferColor: UIColor) {
        stationNameLabel.text = stationNameText
        toMogilevskyaStationButton.isHidden = toMogilevskyaStationButtonIsHidden
        toKamenkaStationButton.isHidden = toKamenkaStationButtonIsHidden
        stationName = stationNameValue
        transferLabel.text = transferName
        transferLabel.textColor = transferColor
        
    }
    
    func setSecondStationViewDelegate(view: SecondLineViewProtocol) {
        secondLineTableViewControllerDelegate = view
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
        
        toMogilevskyaStationButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.equalTo(transferLabel.snp.bottom).offset(20)
            $0.width.equalTo(contentView.frame.width * 0.5)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        toKamenkaStationButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.top.equalTo(transferLabel.snp.bottom).offset(20)
            $0.width.equalTo(contentView.frame.width * 0.5)
            $0.height.equalTo(50)
        }
        
        super.updateConstraints()
    }
    
    //MARK: - Action for toKovalskayaStationButton
    @objc private func toMogilevskyaStationButtonPressed() {
        guard let fromStationName = stationNameLabel.text, let toStationName = toMogilevskyaStationButton.titleLabel?.text, let stationNameUnwrapped = stationName else {return}
        
        //вибрация по нажатию
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        secondLineTableViewControllerDelegate?.presenter?.openTimeVC(fromStationName: fromStationName, toStationName: toStationName, stationName: stationNameUnwrapped, navColor: UIColor(named: "\(NameColorForThemesEnum.secondLineNavBarColor)") ?? .green, navTextColor: UIColor(named: "\(NameColorForThemesEnum.secondLineTextColor)") ?? .systemGreen, line: "\(FireBaseFieldsEnum.secondLine)")
        
        
        print("На Ковальскую")
    }
    
    //MARK: - Action for toUbileinayaStationButton
    @objc private func toKamenkaStationButtonPressed() {
        guard let fromStationName = stationNameLabel.text, let toStationName = toKamenkaStationButton.titleLabel?.text, let stationNameUnwrapped = stationName else {return}
        
        //вибрация по нажатию
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        secondLineTableViewControllerDelegate?.presenter?.openTimeVC(fromStationName: fromStationName, toStationName: toStationName, stationName: stationNameUnwrapped, navColor: UIColor(named: "\(NameColorForThemesEnum.secondLineNavBarColor)") ?? .green, navTextColor: UIColor(named: "\(NameColorForThemesEnum.secondLineTextColor)") ?? .systemGreen, line: "\(FireBaseFieldsEnum.secondLine)")
        print("На Юбилейную")
    }
    
    //MARK: - Action for showFullScheduleButton
    @objc private func showFullScheduleButtonPressed() {
        //FireBaseManager.shared.getStationName()
        print("Полное расписание")
    }
}
