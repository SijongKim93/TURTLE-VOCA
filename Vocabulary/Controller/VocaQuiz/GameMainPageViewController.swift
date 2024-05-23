//
//  VocaQuizViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/13/24.
//

import UIKit
import SnapKit

protocol SendCount: AnyObject {
    func sendData(count: Int)
}

class GameMainPageViewController: UIViewController {
    
    let gameMainHeaderView = GameMainHeaderView()
    let gameMainBottomView = GameMainBottomView()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            UIView(),
            gameMainHeaderView,
            gameMainBottomView,
            UIView()
        ])
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    let selectVC = SelectVocaViewController()
    let buttonList = ["FlashCard", "Quiz", "Turtle Game", "기록보기", "설정하기"]
    let alertController = AlertController()
    var receivedData: GenQuizModel?
    var dataList = [ReminderModel]()
    var data = [WordEntity]()
    var gameCount: Int = 0
    weak var delegate: SendCount?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setUp()
        layout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getSetting), name: .sender, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: .getData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(countUp), name: .count, object: nil)
        }

    
    // 게임 설정을 했는지 안했는지 확인.
    func checkSetting() {
        if receivedData == nil {
            let alert = alertController.makeNormalAlert(title: "설정값이 없습니다.", message: "게임 설정이 필요합니다.")
            self.present(alert, animated: true)
        }
    }
    
    
    func checkData() {
        data = CoreDataManager.shared.getWordList()
    }
    
    private func layout () {
        view.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        gameMainHeaderView.snp.makeConstraints {
            $0.top.equalTo(vStackView.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }
        
        
        gameMainBottomView.snp.makeConstraints {
            $0.top.equalTo(gameMainHeaderView.snp.bottom).offset(30)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc func getSetting (_ notification: Notification) {
        if let data = notification.object as? GenQuizModel {
            receivedData = data
        }
    }
    
    @objc func getData(_ notification: Notification) {
        if let data = notification.object as? ReminderModel {
            dataList.append(data)
        }
    }
    
    @objc func countUp() {
        gameCount += 1
        self.delegate?.sendData(count: gameCount)
    }
}


