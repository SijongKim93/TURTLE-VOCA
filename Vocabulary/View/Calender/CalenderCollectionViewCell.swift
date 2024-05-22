//
//  CalenderCollectionViewCell.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import AVFoundation

class CalenderCollectionViewCell: UICollectionViewCell {
    static let identifier = "CalenderCollectionViewCell"
    
    let synthesizer = AVSpeechSynthesizer()
    
    let typeLabel: UILabel = {
        let label = UILabel()
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
        button.tintColor = ThemeColor.mainColor
        return button
    }()
    
    let learnedButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        button.tintColor = ThemeColor.mainColor
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
        contentView.layer.borderColor = ThemeColor.mainColor.cgColor
        contentView.layer.cornerRadius = 16
        
        contentView.addSubview(typeLabel)
        contentView.addSubview(englishLabel)
        contentView.addSubview(meaningLabel)
        contentView.addSubview(buttonStackView)
        
        speakerButton.addTarget(self, action: #selector(speakEnglishLabel), for: .touchUpInside)
        
        typeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
        }
        
        englishLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
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
        typeLabel.text = word.bookCaseName
        englishLabel.text = word.word
        meaningLabel.text = word.definition
        learnedButton.isSelected = word.memory
    }
    
    @objc func speakEnglishLabel() {
        guard let text = englishLabel.text, !text.isEmpty else { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
}
