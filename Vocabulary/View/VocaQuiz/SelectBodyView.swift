//
//  SelectBodyView.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/20/24.
//

import UIKit
import SnapKit

class SelectBodyView: UIView {
    
    private lazy var bookLabel = LabelFactory().makeLabel(title: "단어장 선택", size: 15, textAlignment: .center, isBold: true)
    
    lazy var bookPicker: UIPickerView = {
        let picker = UIPickerView()
        
        return picker
    }()
    
    private lazy var vFirstStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            bookLabel,
            bookPicker
        ])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var subLabel = LabelFactory().makeLabel(title: "출제 문제 수", size: 15, textAlignment: .center, isBold: true)
    
    lazy var numberLabel = LabelFactory().makeLabel(title: "1", size: 15, textAlignment: .center, isBold: true)
    
    private lazy var plusButton = ButtonFactory().makeButton(title: "+") { [weak self] _ in
        self?.addCount()
    }
    private lazy var minusButton = ButtonFactory().makeButton(title: "-") { [weak self] _ in
        self?.minusCount()
    }
    
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            UIView(),
            minusButton,
            numberLabel,
            plusButton,
            UIView()
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var vSecondStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            subLabel,
            hStackView
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            vFirstStackView,
            vSecondStackView,
            UIView()
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addCount () {
        if let currentVC = currentViewController as? SelectVocaViewController {
            currentVC.quizCount += 1
            self.numberLabel.text = currentVC.quizCount.stringValue
        }
    }
    
    private func minusCount () {
        if let currentVC = currentViewController as? SelectVocaViewController {
            if currentVC.quizCount > 1 {
                currentVC.quizCount -= 1
                self.numberLabel.text = currentVC.quizCount.stringValue
            } else {
                currentVC.quizCount = 1
                self.numberLabel.text = currentVC.quizCount.stringValue
            }
        }
    }
    
    private func layout() {
        addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        vFirstStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        bookLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        bookPicker.snp.makeConstraints {
            $0.top.equalTo(bookLabel.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        vSecondStackView.snp.makeConstraints {
            $0.top.equalTo(vFirstStackView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-50)
        }

        
    }
    
    
}
