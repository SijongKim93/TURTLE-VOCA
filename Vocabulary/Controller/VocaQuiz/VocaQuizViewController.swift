//
//  VocaQuizViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SnapKit

class VocaQuizViewController: UIViewController {
    
    let quizHeaderView = QuizHeaderView()
    let quizBodyView = QuizBodyView()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            UIView(),
            quizHeaderView,
            UIView(),
            quizBodyView,
            UIView()
        ])
        stackView.axis = .vertical
        stackView.spacing = 50
        return stackView
    }()
    
    let buttonList = ["시작하기", "기록보기", "FlashCard", "Hangman"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setUp()
        layout()
        
    }
    
    private func layout () {
        view.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        quizHeaderView.snp.makeConstraints {
            $0.top.equalTo(vStackView.snp.top).offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        quizBodyView.snp.makeConstraints {
            $0.top.equalTo(quizHeaderView.snp.bottom).offset(180)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-100)
        }
    }
    
    
}
