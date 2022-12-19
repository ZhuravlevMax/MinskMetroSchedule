//
//  TimeSheetTableViewCell.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 11.11.22.
//

import UIKit

protocol FullScheduleTableViewCellProtocol {
    func configureCell(hourValue: String,
                       minutesValue: String)
}

class FullScheduleTableViewCell: UITableViewCell, TimeSheetTableViewCellProtocol {
    
    static let key = "FullScheduleTableViewCell"
    
    //MARK: - Create items
    private lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 16,
                                       weight: .bold)
        return label
    }()
    
    private lazy var minutesLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 13,
                                       weight: .light)
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //MARK: - Add items to contentsView
        contentView.addSubview(hourLabel)
        contentView.addSubview(minutesLabel)
        contentView.backgroundColor = UIColor(named: "\(NameColorForThemesEnum.backgroundColor)")
       // contentView.backgroundColor = .clear
        updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(hourValue: String,
                       minutesValue: String) {
        
        hourLabel.text = hourValue
        minutesLabel.text = minutesValue
        
    }
    
    //MARK: - Set constraints for items
    override func updateConstraints() {
        
        hourLabel.snp.makeConstraints {
            $0.left.bottom.top.equalToSuperview().inset(10)
        }
        
        minutesLabel.snp.makeConstraints {
            $0.bottom.top.equalToSuperview().inset(10)
            $0.left.equalTo(hourLabel.snp.right).offset(10)
        }
        
        
        super.updateConstraints()
    }

}
