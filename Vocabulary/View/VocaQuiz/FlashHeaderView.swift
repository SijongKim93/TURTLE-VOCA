//
//  FlashHeaderView.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/15/24.
//

import UIKit
import SnapKit

class FlashHeaderView: UIView {
    
    private lazy var titleLabel = LabelFactory().makeLabel(title: "거북이의 단어퀴즈", size: 25, textAlignment: .left, isBold: true)
    private lazy var subLabel = LabelFactory().makeLabel(title: "FlashCard", size: 15, textAlignment: .left, isBold: false)
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            subLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = -30
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
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}
