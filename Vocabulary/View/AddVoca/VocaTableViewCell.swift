//
//  VocaTableViewCell.swift
//  Vocabulary
//
//  Created by t2023-m0049 on 5/18/24.
//

import Foundation
import UIKit


class VocaTableViewCell: UITableViewCell {
    
    static let identifier = "VocaTableViewCell"
    
    
    var wordLabel = UILabel()
    var pronunciationLabel = UILabel()
    var definitionLabel = UILabel()

    var checkToMemorizeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.addAction(UIAction(handler: { action in
            
            guard let button = action.sender as? UIButton else { return }
            button.tintColor = .red }), for: .touchUpInside)
        return button
    }()

    var buttonAction: (() -> Void)?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
 
     
        
        self.configureUI()
        self.makeConstraints()
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.addSubview(wordLabel)
        contentView.addSubview(pronunciationLabel)
        contentView.addSubview(definitionLabel)
        contentView.addSubview(checkToMemorizeButton)

    }
    
    func makeConstraints() {
        
        wordLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.leading.equalToSuperview().offset(10)
        }
        
        pronunciationLabel.snp.makeConstraints {
            $0.top.equalTo(wordLabel.snp.bottom).offset(10)
            $0.leading.equalTo(wordLabel.snp.leading)
        }
        
        definitionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-50)
        }
        
        checkToMemorizeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
    }
    
    func toggleButtonSelection() {
        checkToMemorizeButton.isSelected.toggle() //누르면 빨간색으로 변환되는 것으로 바꾸기(외움이 더 필요한 것 빨간색, 괜찮은 것 초록색)
    }
    
    @objc func buttonTapped() {
        if let tableView = self.superview as? UITableView, let indexPath = tableView.indexPath(for: self) {
            tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }
    
    
    
}
