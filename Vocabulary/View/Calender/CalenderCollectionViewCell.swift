//
//  CalenderCollectionViewCell.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit

class CalenderCollectionViewCell: UICollectionViewCell {
    static let identifier = "CalenderCollectionViewCell"
    
    let englishLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    let pronunciationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .gray
        return label
    }()
    
    let meaningLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textAlignment = .right
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
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.tintColor = UIColor(red: 48/255, green: 140/255, blue: 74/255, alpha: 1.0)
        return button
    }()
    
    lazy var wordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [englishLabel, pronunciationLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
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
        
        contentView.addSubview(wordStackView)
        contentView.addSubview(buttonStackView)
        contentView.addSubview(meaningLabel)
        
        wordStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalToSuperview().inset(10)
        }
        
        meaningLabel.snp.makeConstraints {
            $0.trailing.equalTo(buttonStackView.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with word: DummyEnglish.Word) {
        englishLabel.text = word.english
        pronunciationLabel.text = word.pronunciation
        meaningLabel.text = word.meaning
    }
}
