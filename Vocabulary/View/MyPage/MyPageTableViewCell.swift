//
//  MyPageTableViewCell.swift
//  Vocabulary
//
//  Created by 김시종 on 5/16/24.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {
    
    static let identifier = "MyPageTableViewCell"
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 48/255, green: 140/255, blue: 74/255, alpha: 1.0)
        return imageView
    }()
   
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.leading.equalTo(contentView).offset(10)
            $0.centerY.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(15)
            $0.trailing.equalTo(contentView).inset(10)
            $0.centerY.equalTo(contentView)
        }
    }
    
    func configure(with title: String, systemImageName: String) {
        titleLabel.text = title
        iconImageView.image = UIImage(systemName: systemImageName)
    }
    
}
