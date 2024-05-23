//
//  HangManGameViewController.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/16/24.
//

import UIKit
import SnapKit

class HangManGameViewController: UIViewController {
    
    lazy var hangManHeaderView = HangManHeaderView()
    lazy var hangManBodyView = HangManBodyView()
    var hangManBottomView: HangManBottomView?
    var label = UILabel()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            UIView(),
            hangManHeaderView,
            hangManBodyView,
            UIView()
        ])
        stackView.axis = .vertical
        
        return stackView
    }()
    
    let alertController = AlertController()
    
    var labelList = [UILabel]()
    var failCount = 0
    var score = 0
    var imageList = (0...7).map{String($0)}
    var isGameEnd = false
    var answer = ""
    var quizArray = [WordEntity]()
    var receivedData: GenQuizModel?
    var currentCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        layout()
        getData()
        gameStart()
        
    }
    
    
    private func layout() {
        view.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        hangManHeaderView.snp.makeConstraints {
            $0.top.equalTo(vStackView.snp.top).offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        hangManBodyView.snp.makeConstraints {
            $0.top.equalTo(hangManHeaderView.snp.bottom)
            $0.height.equalTo(350)
        }
        
        
    }
    
}

// MARK: - Game Logic
extension HangManGameViewController {
    
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
        quizArray = Array(quizArray.prefix(receivedData!.quizCount))
    }
    
    func gameStart () {
        failCount = 0
        score = 0
        isGameEnd = false
        
        if !labelList.isEmpty {
            resetLabel()
        }
        
        hangManBottomView = HangManBottomView()
        
        vStackView.addSubview(hangManBottomView!)
        
        hangManBottomView!.snp.makeConstraints {
            $0.top.equalTo(hangManBodyView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-60)
        }
        if currentCount < quizArray.count {
            answer = quizArray[currentCount].word!
            makeWordLabel(word: answer)
            
            updateUI()
        } else {
            let alert = alertController.makeNormalAlert(title: "게임종료", message: "게임이 끝났습니다.")
            self.present(alert, animated: true)
        }
    }
    
    func guessAnswer(alphabet: Character) {
        let words = answer.map { $0 }
        for i in words.indices {
            if words[i] == alphabet {
                labelList[i].text = String(alphabet)
                score += 1
                monitorScore()
            }
        }
    }
    
    func monitorScore() {
        
        if score == answer.count {
            let alert = alertController.makeAlertWithCompletion(title: "축하합니다.", message: "정답을 맞추셨습니다\n다시 시작하시겠습니까?") { [weak self] _ in
                self?.hangManBottomView?.removeFromSuperview()
                self?.resetLabel()
                self?.currentCount += 1
                self?.gameStart()
                self?.isGameEnd = false
            }
            self.present(alert, animated: true)
            isGameEnd = true
        }
    }
    
    
    
    func updateUI () {
        guard let word = quizArray[currentCount].word, let meaning = quizArray[currentCount].definition, let category = receivedData?.category else {
            return
        }
        let data = ReminderModel(index: 1, word: word, meaning: meaning, category: category)
        if failCount >= 7 {
            hangManBodyView.hangManImageView.image = UIImage(named: imageList[failCount])
            let alert = alertController.makeAlertWithCompletion(title: "게임종료", message: "게임이 끝났습니다.\n다시 시작하시겠습니까?") { [weak self] _ in
                self?.hangManBottomView?.removeFromSuperview()
                self?.resetLabel()
                self?.currentCount += 1
                self?.gameStart()
                self?.isGameEnd = false
            }
            NotificationCenter.default.post(name: .hangman, object: data)
            self.present(alert, animated: true)
            isGameEnd = true
            
        } else {
            hangManBodyView.hangManImageView.image = UIImage(named: imageList[failCount])
        }
    }
    
    
    
    func makeWordLabel (word: String) {
        for i in 0 ... word.count - 1 {
            label = LabelFactory().hangManLabel(title: "_", size: 20, isBold: true)
            hangManBodyView.wordFrameView.addSubview(label)
            labelList.append(label)
            
            label.snp.makeConstraints {
                $0.leading.equalTo(hangManBodyView.wordFrameView.snp.leading).offset(i * 20)
            }
        }
    }
    
    func resetLabel () {
        for label in labelList {
            label.removeFromSuperview()
        }
        labelList.removeAll()
    }
    
}


