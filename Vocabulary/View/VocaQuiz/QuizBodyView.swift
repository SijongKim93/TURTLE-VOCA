//
//  GamePageBodyView.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/13/24.
//

import UIKit
import SnapKit

class QuizBodyView: UIView {
    
    lazy var gameTitle = LabelFactory().makeLabel(title: "문제", color: .black, size: 30, textAlignment: .center, isBold: true)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout () {
        self.addSubview(gameTitle)
        
        gameTitle.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
}
