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
    
    let alertController = AlertController()
    
    var currentNumber: Int = 0
    var score: Int = 0
    var titleText = ""
    var receivedData: GenQuizModel?
    var quizArray = [WordEntity]()
    var quizData = [VocaQuizModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        layout()
        getData()
        generate(count: receivedData!.quizCount)
        gameStart()
    }
    
    func checkException () {
        if receivedData!.quizCount > quizArray.count {
            receivedData?.quizCount = quizArray.count
        }
    }
    
    func getData () {
        quizArray = CoreDataManager.shared.getSpecificData(query: receivedData!.category, onError: { [unowned self] error in
            let alert = alertController.makeNormalAlert(title: "에러발생", message: "\(error.localizedDescription)가 발생했습니다.")
            self.present(alert, animated: true)
        }).shuffled()
        checkException()
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
            $0.top.equalTo(quizBodyView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-100)
        }
    }
    
}

// MARK: - Game Logic

extension QuizViewController {
    
    func generate(count: Int) {
        
        var madeList = [String]()
        
        for _ in 0 ..< count {
            var numberArray = (0...quizArray.count-1).map { $0 }.shuffled()
            
            var getFourNumberArray = numberArray.prefix(4).map { numberArray[$0] }
            var answerInfo = quizArray[getFourNumberArray[0]]
            
            while madeList.contains(answerInfo.word!) {
                numberArray = (0...quizArray.count-1).map { $0 }.shuffled()
                getFourNumberArray = numberArray.prefix(4).map { numberArray[$0] }
                answerInfo = quizArray[getFourNumberArray[0]]
            }
            
            let question = answerInfo.word!
            let answer = answerInfo.definition!
            let first = quizArray[getFourNumberArray[1]].definition!
            let second = quizArray[getFourNumberArray[2]].definition!
            let third = quizArray[getFourNumberArray[3]].definition!
            
            let dummy = VocaQuizModel(question: question, answer: answer, incorrectFirst: first, incorrectSecond: second, incorrectThird: third)
            quizData.append(dummy)
            madeList.append(question)
            print(dummy)
            print("=====")
        }
        
    }
    
    func gameStart () {
        if currentNumber > quizData.count - 1 {
            quizBodyView.gameTitle.text = "게임이 종료 되었습니다."
            quizHeaderView.scoreLabel.text = "Score: \(score) 점"
            NotificationCenter.default.post(name: .count, object: nil)
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
    
}
