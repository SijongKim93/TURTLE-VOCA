//
//  GamePageHeaderView.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/13/24.
//

import UIKit
import SnapKit

class GamePageHeaderView: UIView {
    
    private lazy var titleLabel = LabelFactory().makeLabel(title: "거북이의 단어장", size: 25, textAlignment: .left, isBold: true)
    private lazy var subLabel = LabelFactory().makeLabel(title: "단어외우기",color: .gray, size: 15, textAlignment: .left, isBold: false)
    
    lazy var scoreLabel = LabelFactory().makeLabel(title: "Score:", color: .gray, size: 15, textAlignment: .right, isBold: false)
    
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            subLabel,
            scoreLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = -30
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
    
    private func layout() {
        addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
    }
    
}
