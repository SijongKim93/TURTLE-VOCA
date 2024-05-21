//
//  GamePageBottomView.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/13/24.
//

import UIKit
import SnapKit

class QuizBottomView: UIView {
    
    lazy var firstButton = ButtonFactory().makeButton(title: "첫번째", size: 30, color: .white, backgroundColor: ThemeColor.mainColor, radius: 15, borderWidth: 0.5) { button in
        guard let title = button.titleLabel?.text else { return }
        if self.checkAnswer(title: title) == true {
            button.backgroundColor = .green
            Timer.scheduledTimer(timeInterval: 0.1,target: self, selector: #selector(self.updateBackground), userInfo: nil, repeats: false)
        } else {
            button.backgroundColor = .red
            Timer.scheduledTimer(timeInterval: 0.1,target: self, selector: #selector(self.updateBackground), userInfo: nil, repeats: false)
        }
    }
    
    lazy var secondButton = ButtonFactory().makeButton(title: "두번째", size: 30, color: .white, backgroundColor: ThemeColor.mainColor, radius: 15, borderWidth: 0.5) { button in
        guard let title = button.titleLabel?.text else { return }
        if self.checkAnswer(title: title) == true {
            button.backgroundColor = .green
            Timer.scheduledTimer(timeInterval: 0.1,target: self, selector: #selector(self.updateBackground), userInfo: nil, repeats: false)
        } else {
            button.backgroundColor = .red
            Timer.scheduledTimer(timeInterval: 0.1,target: self, selector: #selector(self.updateBackground), userInfo: nil, repeats: false)
        }
    }
    
    lazy var thirdButton = ButtonFactory().makeButton(title: "세번째", size: 30, color: .white, backgroundColor: ThemeColor.mainColor, radius: 15, borderWidth: 0.5) { button in
        guard let title = button.titleLabel?.text else { return }
        if self.checkAnswer(title: title) == true {
            button.backgroundColor = .green
            Timer.scheduledTimer(timeInterval: 0.1,target: self, selector: #selector(self.updateBackground), userInfo: nil, repeats: false)
        } else {
            button.backgroundColor = .red
            Timer.scheduledTimer(timeInterval: 0.1,target: self, selector: #selector(self.updateBackground), userInfo: nil, repeats: false)
        }
    }
    
    lazy var forthButton = ButtonFactory().makeButton(title: "네번째", size: 30, color: .white, backgroundColor: ThemeColor.mainColor, radius: 15, borderWidth: 0.5) { button in
        guard let title = button.titleLabel?.text else { return }
        if self.checkAnswer(title: title) == true {
            button.backgroundColor = .green
            Timer.scheduledTimer(timeInterval: 0.1,target: self, selector: #selector(self.updateBackground), userInfo: nil, repeats: false)
        } else {
            button.backgroundColor = .red
            Timer.scheduledTimer(timeInterval: 0.1,target: self, selector: #selector(self.updateBackground), userInfo: nil, repeats: false)
        }
    }
    
    @objc func updateBackground () {
        [firstButton, secondButton, thirdButton, forthButton].forEach { button in
            button.backgroundColor = ThemeColor.mainColor
        }
    }
    
    func checkAnswer(title: String) -> Bool {
        var flag = false
        guard let currentVC = currentViewController as? QuizViewController else { return flag }
        let currentQuestion = currentVC.quizBodyView.gameTitle.text
        let gameArray = currentVC.quizData
        let answer = gameArray.filter{ $0.question == currentQuestion }.map{ $0.answer }.joined()
        
        if title == answer {
            currentVC.currentNumber += 1
            currentVC.score += 1
            currentVC.gameStart()
            flag = true
        } else {
            let currentData = currentVC.quizData[currentVC.currentNumber]
            let data = ReminderModel(index: 0, word: currentData.question, meaning: currentData.answer, category: currentVC.receivedData!.category)
            NotificationCenter.default.post(name: .quiz, object: data)
            currentVC.currentNumber += 1
            currentVC.gameStart()
        }
        return flag
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
        stackView.distribution = .fillEqually
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
