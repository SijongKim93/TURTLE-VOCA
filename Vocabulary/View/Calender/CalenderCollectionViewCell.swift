//
//  CalenderCollectionViewCell.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit

class CalenderCollectionViewCell: UICollectionViewCell {
    static let identifier = "CalenderCollectionViewCell"
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "단어장 종류"
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .gray
        return label
    }()
    
    let englishLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    let meaningLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    let speakerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        button.tintColor = UIColor(red: 48/255, green: 140/255, blue: 74/255, alpha: 1.0)
        return button
    }()
    
    let learnedButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        button.tintColor = UIColor(red: 48/255, green: 140/255, blue: 74/255, alpha: 1.0)
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [speakerButton, learnedButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = #colorLiteral(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401, alpha: 1)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 48/255, green: 140/255, blue: 74/255, alpha: 1.0).cgColor
        contentView.layer.cornerRadius = 16
        
        contentView.addSubview(typeLabel)
        contentView.addSubview(englishLabel)
        contentView.addSubview(meaningLabel)
        contentView.addSubview(buttonStackView)
        
        typeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
        }
        
        englishLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalToSuperview().inset(10)
        }
        
        meaningLabel.snp.makeConstraints {
            $0.trailing.equalTo(buttonStackView.snp.leading).offset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with word: WordEntity) {
        englishLabel.text = word.word
        meaningLabel.text = word.definition
        learnedButton.isSelected = word.memory
    }
}
