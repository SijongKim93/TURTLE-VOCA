//
//  GamePageViewController.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/13/24.
//

import UIKit
import SnapKit

class GamePageViewController: UIViewController {
    
    lazy var gamePageHeaderView = GamePageHeaderView()
    lazy var gamePageBodyView = GamePageBodyView()
    lazy var gamePageBottomView = GamePageBottomView()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            UIView(),
            gamePageHeaderView,
            gamePageBodyView,
            UIView(),
            gamePageBottomView,
            UIView()
        ])
        stackView.axis = .vertical
        
        return stackView
    }()
    
    let dummyData = ["영어", "단어", "뜻", "스위프트"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        layout()
        setUp()
    }
    

    private func layout () {
        view.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gamePageHeaderView.snp.makeConstraints {
            $0.top.equalTo(vStackView.snp.top).offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        gamePageBodyView.snp.makeConstraints {
            $0.top.equalTo(gamePageHeaderView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        gamePageBottomView.snp.makeConstraints {
            $0.top.equalTo(gamePageBodyView.snp.bottom).offset(100)
            $0.bottom.equalToSuperview()
        }
    }

}
