//
//  GamePageViewController.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/13/24.
//

import UIKit
import SnapKit
import CoreData


class QuizViewController: UIViewController {
    
    lazy var quizHeaderView = QuizHeaderView()
    lazy var quizBodyView = QuizBodyView()
    lazy var quizBottomView = QuizBottomView()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            UIView(),
            quizHeaderView,
            quizBodyView,
            UIView(),
            quizBottomView,
            UIView()
        ])
        stackView.axis = .vertical
        
        return stackView
    }()
    
    let dummyGenerator = DummyGenerator()
    let alertController = AlertController()
    
    var dummyData = [DummyModel]()
    var quizData = [VocaQuizModel]()
    var currentNumber: Int = 0
    var score: Int = 0
    var titleText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        layout()
        generate(count: 5)
        gameStart()
        print(quizData)
    }
    
    private func generate(count: Int) { // 문제배열이 생성
        
        for _ in 0..<count {
            let dummyData = dummyGenerator.makeDummy() // Coredata 가져올애 지금은 Dummy
            let numberArray = (0...dummyData.count-1).map{ $0 }.shuffled()
            
            let getFourNumberArray = numberArray.prefix(4).map { numberArray[$0] } // 3 0 1 8
            
            let number1 = getFourNumberArray[0] // 3
            let number2 = getFourNumberArray[1] // 0
            let number3 = getFourNumberArray[2] // 1
            let number4 = getFourNumberArray[3] // 8
            
            
            let answerInfo = dummyData[number1]
            let question = answerInfo.words
            let answer = answerInfo.meaning
            let first = dummyData[number2].meaning
            let second = dummyData[number3].meaning
            let third = dummyData[number4].meaning
            
            let dummy = VocaQuizModel(question: question, answer: answer, incorrectFirst: first, incorrectSecond: second, incorrectThird: third)
            quizData.append(dummy)
        }
        
    }
    
    func gameStart () {
        if currentNumber > quizData.count - 1 {
            quizBodyView.gameTitle.text = "게임이 종료 되었습니다."
            quizHeaderView.scoreLabel.text = "Score: \(score) 점"
            [quizBottomView.firstButton, quizBottomView.secondButton, quizBottomView.thirdButton, quizBottomView.forthButton].forEach { button in
                button.isEnabled = false
            }
        } else {
            update()
            var answerList = [quizData[currentNumber].answer, quizData[currentNumber].incorrectFirst, quizData[currentNumber].incorrectSecond, quizData[currentNumber].incorrectThird]
            answerList.shuffle()
            
            quizBottomView.firstButton.setTitle(answerList[0], for: .normal)
            quizBottomView.secondButton.setTitle(answerList[1], for: .normal)
            quizBottomView.thirdButton.setTitle(answerList[2], for: .normal)
            quizBottomView.forthButton.setTitle(answerList[3], for: .normal)
        }
    }
    
    func update() {
        quizBodyView.gameTitle.text = quizData[currentNumber].question
        quizHeaderView.scoreLabel.text = "Score: \(score) 점"
        
    }
    
    private func layout () {
        view.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        quizHeaderView.snp.makeConstraints {
            $0.top.equalTo(vStackView.snp.top).offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        quizBodyView.snp.makeConstraints {
            $0.top.equalTo(quizHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        quizBottomView.snp.makeConstraints {
            $0.top.equalTo(quizBodyView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-100)
        }
    }
    
}
