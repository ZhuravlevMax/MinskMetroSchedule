//
//  SearchTableViewCell.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 27.12.22.
//

import UIKit

protocol SearchTableViewCellProtocol {
    func configureCell(stationNameText: String,
                       buttonColor: String,
                       textButtonColor: String,
                       mainDirection: String,
                       reverseDirection: String)
    var searchViewControllerDelegate: SearchViewProtocol? {get set}
    
    func setSearchViewDelegate(view: SearchViewProtocol)
}

class SearchTableViewCell: UITableViewCell, SearchTableViewCellProtocol {
    
    
    
    static let key = "SearchTableViewCell"
    var searchViewControllerDelegate: SearchViewProtocol?
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
    
    private lazy var mainDirectionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.firstLineButtonColor)")
        button.setTitle("Посадки нет", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 2
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.firstLineButtonColor)"), for: .highlighted)
        button.dropShadow()
        button.addTarget(self,
                         action: #selector(self.mainDirectionButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var reverseDirectionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.firstLineButtonColor)")
        button.setTitle("Посадки нет", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 2
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor(named: "\(NameColorForThemesEnum.firstLineButtonColor)"), for: .highlighted)
        button.dropShadow()
        button.addTarget(self,
                         action: #selector(self.reverseButtonPressed),
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //MARK: - Add items to contentsView
        contentView.addSubview(stationNameLabel)
        contentView.addSubview(mainDirectionButton)
        contentView.addSubview(reverseDirectionButton)
        contentView.addSubview(transferLabel)
        contentView.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
        
        updateConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureCell(stationNameText: String,
                       buttonColor: String,
                       textButtonColor: String,
                       mainDirection: String,
                       reverseDirection: String) {
        
        if mainDirection == "Посадки нет" {
            mainDirectionButton.isHidden = true
        } else {
            mainDirectionButton.isHidden = false
        }
        
        if reverseDirection == "Посадки нет" {
            reverseDirectionButton.isHidden = true
        } else {
            reverseDirectionButton.isHidden = false
        }
        
        stationNameLabel.text = stationNameText
        stationNameLabel.textColor = UIColor(named: "\(textButtonColor)")
        mainDirectionButton.backgroundColor = UIColor(named: "\(buttonColor)")
        mainDirectionButton.setTitleColor(UIColor(named: "\(textButtonColor)"), for: .normal)
        mainDirectionButton.setTitle("\(mainDirection)", for: .normal)
        reverseDirectionButton.backgroundColor = UIColor(named: "\(buttonColor)")
        reverseDirectionButton.setTitleColor(UIColor(named: "\(textButtonColor)"), for: .normal)
        reverseDirectionButton.setTitle("\(reverseDirection)", for: .normal)
        
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
        
        mainDirectionButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.top.equalTo(transferLabel.snp.bottom).offset(20)
            $0.width.equalTo(contentView.frame.width * 0.5)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        reverseDirectionButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.top.equalTo(transferLabel.snp.bottom).offset(20)
            $0.width.equalTo(contentView.frame.width * 0.5)
            $0.height.equalTo(50)
        }
        
        super.updateConstraints()
    }
    
    //MARK: - Action for toMalinovkaStationButton
    @objc private func mainDirectionButtonPressed() {
        guard let fromStationName = stationNameLabel.text,
              let toStationName = mainDirectionButton.titleLabel?.text,
              let buttonColor = mainDirectionButton.backgroundColor,
              let buttonTextColor = stationNameLabel.textColor
              
        else {return}
        
        
        let line: String = { [weak self] in
            guard let self, let color = mainDirectionButton.backgroundColor else {return ""}
            
            switch color {
            case UIColor(named: "\(NameColorForThemesEnum.firstLineNavBarColor)"):
                return "firstLine"
            case UIColor(named: "\(NameColorForThemesEnum.secondLineNavBarColor)"):
                return "secondLine"
            case UIColor(named: "\(NameColorForThemesEnum.thirdLineNavBarColor)"):
                return "thirdLine"

            default:
                return ""
            }
            
        }()
        //вибрация по нажатию
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        searchViewControllerDelegate?.presenter?.openTimeVC(fromStationName: fromStationName,
                                                            toStationName: toStationName,
                                                            stationName: fromStationName,
                                                            navColor: buttonColor,
                                                            navTextColor: buttonTextColor,
                                                            line: line)

    }
    
    //MARK: - Action for toUrucheStationButton
    @objc private func reverseButtonPressed() {
        guard let fromStationName = stationNameLabel.text,
              let toStationName = reverseDirectionButton.titleLabel?.text,
              let buttonColor = reverseDirectionButton.backgroundColor,
              let buttonTextColor = stationNameLabel.textColor
              
        else {return}
        
        let line: String = { [weak self] in
            guard let self, let color = reverseDirectionButton.backgroundColor else {return ""}
            
            switch color {
            case UIColor(named: "\(NameColorForThemesEnum.firstLineNavBarColor)"):
                return "firstLine"
            case UIColor(named: "\(NameColorForThemesEnum.secondLineNavBarColor)"):
                return "secondLine"
            case UIColor(named: "\(NameColorForThemesEnum.thirdLineNavBarColor)"):
                return "thirdLine"

            default:
                return ""
            }
            
        }()
        //вибрация по нажатию
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        searchViewControllerDelegate?.presenter?.openTimeVC(fromStationName: fromStationName,
                                                            toStationName: toStationName,
                                                            stationName: fromStationName,
                                                            navColor: buttonColor,
                                                            navTextColor: buttonTextColor,
                                                            line: line)

    }
    
    func setSearchViewDelegate(view: SearchViewProtocol) {
        searchViewControllerDelegate = view
    }
    
    
}
