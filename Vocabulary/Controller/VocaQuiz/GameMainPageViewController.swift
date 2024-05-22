//
//  VocaQuizViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SnapKit

class GameMainPageViewController: UIViewController {
    
    let gameMainHeaderView = GameMainHeaderView()
    let gameMainBodyView = GameMainBodyView()
    let gameMainBottomView = GameMainBottomView()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            UIView(),
            gameMainHeaderView,
            gameMainBodyView,
            gameMainBottomView,
            UIView()
        ])
        stackView.axis = .vertical
        stackView.spacing = 50
        return stackView
    }()
    
    let selectVC = SelectVocaViewController()
    let buttonList = ["FlashCard", "Quiz", "Hangman", "기록보기", "설정하기"]
    let alertController = AlertController()
    var receivedData: GenQuizModel?
    var dataList = [ReminderModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setUp()
        layout()
        NotificationCenter.default.addObserver(self, selector: #selector(getSetting), name: .sender, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: .quiz, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: .hangman, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .sender, object: nil)
        NotificationCenter.default.removeObserver(self, name: .quiz, object: nil)
        NotificationCenter.default.removeObserver(self, name: .hangman, object: nil)
    }
    
    func checkSetting() {
        if receivedData == nil {
            let alert = alertController.makeAlertWithCompletion(title: "설정값이 없습니다.", message: "게임 설정이 필요합니다.\n설정 페이지로 이동합니다.") { _ in
                let vc = SelectVocaViewController()
                vc.modalPresentationStyle = .custom
                vc.transitioningDelegate = self
                self.present(vc, animated: true, completion: nil)
            }
            self.present(alert, animated: true)
        }
    }
    
    private func layout () {
        view.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        gameMainHeaderView.snp.makeConstraints {
            $0.top.equalTo(vStackView.snp.top).offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        gameMainBodyView.snp.makeConstraints {
            $0.top.equalTo(gameMainHeaderView.snp.bottom).offset(50)
            $0.height.equalTo(150)
        }
        
        gameMainBottomView.snp.makeConstraints {
            $0.top.equalTo(gameMainBodyView.snp.bottom).offset(50)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-100)
        }
    }
    
    @objc func getSetting (_ notification: Notification) {
        if let data = notification.object as? GenQuizModel {
            receivedData = data
        }
    }
    
    @objc func getData(_ notification: Notification) {
        if let data = notification.object as? ReminderModel {
            //print(data)
            dataList.append(data)
        }
    }
}
