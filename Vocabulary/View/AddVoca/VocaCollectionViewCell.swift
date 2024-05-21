//
//  VocaCollectionViewCell.swift
//  Vocabulary
//
//  Created by 김시종 on 5/21/24.
//

import UIKit
import AVFoundation

class VocaCollectionViewCell: UICollectionViewCell {
    static let identifier = "VocaCollectionViewCell"
    
    let synthesizer = AVSpeechSynthesizer()
    
    var wordLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    var pronunciationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    var definitionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let deleteButton = UIButton()
    
    var deleteAction: (() -> Void)?
    
    var checkToMemorizeButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .large)
        let image = UIImage(systemName: "checkmark.circle", withConfiguration: config)
        let selectedImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
        
        button.setImage(image, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.tintColor = ThemeColor.mainColor
        button.addAction(UIAction(handler: { action in
            guard let button = action.sender as? UIButton else { return }
            button.isSelected.toggle()
        }), for: .touchUpInside)
        return button
    }()
    
    var speakButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .large)
        let image = UIImage(systemName: "speaker.wave.2.fill", withConfiguration: config)
        
        button.setImage(image, for: .normal)
        button.tintColor = ThemeColor.mainColor
        
        return button
    }()
    
    lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [wordLabel, pronunciationLabel, definitionLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [speakButton, checkToMemorizeButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    var buttonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.makeConstraints()
        self.addSwipeGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(textStackView)
        contentView.addSubview(buttonStackView)
        contentView.addSubview(deleteButton)
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.backgroundColor = .white
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.isHidden = true
        
        checkToMemorizeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        speakButton.addTarget(self, action: #selector(speakButtonTapped), for: .touchUpInside)
        
        contentView.layer.borderWidth = 2.0
        contentView.layer.borderColor = ThemeColor.mainColor.cgColor
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
    }
    
    private func makeConstraints() {
        textStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(buttonStackView.snp.leading).offset(-10)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        checkToMemorizeButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        speakButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(100)
            $0.trailing.equalToSuperview().offset(100)
        }
    }
    
    private func addSwipeGesture() {
        let leftswipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipeGesture(_:)))
        leftswipeGesture.direction = .left
        contentView.addGestureRecognizer(leftswipeGesture)
        
        let rightswipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipeGesture(_:)))
        rightswipeGesture.direction = .right
        contentView.addGestureRecognizer(rightswipeGesture)
    }
    
    @objc private func handleLeftSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if deleteButton.isHidden {
            showDeleteButton()
        }
    }
    
    @objc private func handleRightSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if !deleteButton.isHidden {
            hideDeleteButton()
        }
    }
            
    private func showDeleteButton() {
        deleteButton.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.contentView.frame.origin.x -= 100
            self.deleteButton.frame.origin.x -= 100
        }
    }
    
    private func hideDeleteButton() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.frame.origin.x += 100
            self.deleteButton.frame.origin.x += 100
        }) {_ in
            self.deleteButton.isHidden = true
            }
        }
    
    @objc private func deleteButtonTapped() {
        deleteAction?()
    }

    
    @objc func buttonTapped() {
        toggleButtonSelection()
    }
    
    @objc func speakButtonTapped() {
        guard let text = wordLabel.text, !text.isEmpty else { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
    
    func toggleButtonSelection() {
        checkToMemorizeButton.isSelected.toggle()
    }
}
