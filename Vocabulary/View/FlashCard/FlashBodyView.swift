//
//  FlashBodyView.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/15/24.
//

import UIKit
import SnapKit

class FlashBodyView: UIView {
    
    lazy var frameView: UIView = {
        let view = UIView()
        view.addSubview(wordLabel)
        view.addSubview(answerLabel)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var wordLabel = LabelFactory().makeLabel(title: "Word", size: 40, isBold: true)
    lazy var answerLabel = LabelFactory().makeLabel(title: "answer", size: 20, isBold: false)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout () {
        addSubview(frameView)
        
        frameView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.bottom.trailing.equalToSuperview().inset(20)
        }
        
        wordLabel.snp.makeConstraints {
            $0.top.equalTo(frameView.snp.top).offset(20)
            $0.leading.equalTo(frameView.snp.leading).offset(20)
            $0.trailing.trailing.equalTo(frameView.snp.trailing).inset(20)
        }
        
        answerLabel.snp.makeConstraints {
            $0.top.equalTo(wordLabel.snp.bottom).offset(150)
            $0.leading.equalTo(frameView.snp.leading).offset(20)
            $0.trailing.trailing.equalTo(frameView.snp.trailing).inset(20)
            $0.bottom.equalTo(frameView.snp.bottom).inset(75)
        }
    }
    
}
