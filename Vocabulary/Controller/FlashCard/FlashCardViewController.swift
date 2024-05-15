//
//  FlashCardViewController.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/15/24.
//

import UIKit
import SnapKit

class FlashCardViewController: UIViewController {
    
    lazy var flashHeaderView = FlashHeaderView()
    lazy var flashBodyView = FlashBodyView()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            UIView(),
            flashHeaderView,
            flashBodyView,
            UIView()
        ])
        stackView.axis = .vertical
        return stackView
    }()
    
    let alertController = AlertController()
    let dummyGenerator = DummyGenerator()
    var wordList = [DummyModel]()
    var currentNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        layout()
        
        generate()
        addGesture()
        updateUI()
    
    }
    
    private func addGesture () {
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(showAnswer))
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(showNext))
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(showNext))
        swipeLeftGesture.direction = .left
        swipeRightGesture.direction = .right
        flashBodyView.gestureRecognizers = [touchGesture, swipeLeftGesture, swipeRightGesture]
    }
    
    private func generate() {
        wordList = dummyGenerator.makeDummy()
    }
    
    private func updateUI () {
        if currentNumber > wordList.count - 1 {
            let alert = alertController.makeAlertWithCompletion(title: "마지막 단어입니다.", message: "다시 시작하시겠습니까?\n단어는 랜덤으로 다시 만들어집니다.") { [weak self] _ in
                self?.generate()
                self?.currentNumber = 0
                self?.flashBodyView.wordLabel.text = self?.wordList[self!.currentNumber].words
            }
            self.present(alert, animated: true)
        } else {
            flashBodyView.wordLabel.text = wordList[currentNumber].words
            flashBodyView.answerLabel.isHidden = true
            flashBodyView.answerLabel.text = wordList[currentNumber].meaning
        }
        
    }
    
    private func layout() {
        view.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        flashHeaderView.snp.makeConstraints {
            $0.top.equalTo(vStackView.snp.top).offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        flashBodyView.snp.makeConstraints {
            $0.top.equalTo(flashHeaderView.snp.bottom)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-100)
        }
    }
    
    @objc func showAnswer() {
        flashBodyView.answerLabel.isHidden = false
    }
    
    @objc func showNext() {
        currentNumber += 1
        updateUI()
    }
}
