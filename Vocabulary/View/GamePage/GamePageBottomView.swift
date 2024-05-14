//
//  GamePageBottomView.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/13/24.
//

import UIKit
import SnapKit

class GamePageBottomView: UIView {
    
    lazy var firstButton: UIButton = {
        let button = UIButton()
        button.setTitle("첫번째", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0.5
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let title = button.titleLabel?.text else { return }
           self?.checkAnswer(title: title)
        }), for: .touchUpInside)
        return button
    }()
    
    lazy var secondButton: UIButton = {
        let button = UIButton()
        button.setTitle("두번째", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0.5
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let title = button.titleLabel?.text else { return }
           self?.checkAnswer(title: title)
        }), for: .touchUpInside)
        return button
    }()
    
    lazy var thirdButton: UIButton = {
        let button = UIButton()
        button.setTitle("세번째", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0.5
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let title = button.titleLabel?.text else { return }
           self?.checkAnswer(title: title)
        }), for: .touchUpInside)
        return button
    }()
    
    lazy var forthButton: UIButton = {
        let button = UIButton()
        button.setTitle("네번째", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0.5
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let title = button.titleLabel?.text else { return }
           self?.checkAnswer(title: title)
        }), for: .touchUpInside)
        return button
    }()
    
    func checkAnswer(title: String) {
        guard let currentVC = currentViewController as? GamePageViewController else { return }
        let currentQuestion = currentVC.gamePageBodyView.gameTitle.text
        let gameArray = currentVC.quizData
        let answer = gameArray.filter{$0.question == currentQuestion}.map{ $0.answer }.joined()
        
        if title == answer {
            currentVC.currentNumber += 1
            currentVC.score += 1
            currentVC.gameStart()
        } else {
            currentVC.currentNumber += 1
            currentVC.gameStart()
        }
    }
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            firstButton,
            secondButton,
            thirdButton,
            forthButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout () {
        self.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview()
            
        }
        
        firstButton.snp.makeConstraints {
            $0.leading.equalTo(vStackView.snp.leading)
            $0.trailing.equalTo(vStackView.snp.trailing)
        }
        
        secondButton.snp.makeConstraints {
            $0.leading.equalTo(vStackView.snp.leading)
            $0.trailing.equalTo(vStackView.snp.trailing)
        }
        
        thirdButton.snp.makeConstraints {
            $0.leading.equalTo(vStackView.snp.leading)
            $0.trailing.equalTo(vStackView.snp.trailing)
        }
        
        forthButton.snp.makeConstraints {
            $0.leading.equalTo(vStackView.snp.leading)
            $0.trailing.equalTo(vStackView.snp.trailing)
        }
        
    }
    
}
