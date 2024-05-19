//
//  FilterTableViewCell.swift
//  Vocabulary
//
//  Created by 김시종 on 5/15/24.
//

import UIKit


class FilterTableViewCell: UITableViewCell {
    
    static let identifier = "FilterTableViewCell"
    
    var buttonAction: (() -> Void)?
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    let button: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "circle.circle"), for: .selected)
        button.tintColor = .black
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(label)
        contentView.addSubview(button)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
    }
    
    func toggleButtonSelection() {
        button.isSelected.toggle()
    }
    
    @objc func buttonTapped() {
        buttonAction?()
    }
}
