//
//  AddBookCaseBodyView.swift
//  Vocabulary
//
//  Created by Luz on 5/15/24.
//

import UIKit
import SnapKit

class AddBookCaseBodyView: UIView {
    
    //nameStackView
    let nameLabel = LabelFactory().makeLabel(title: "단어장 이름", size: 20, textAlignment: .left, isBold: true)
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "단어장 이름을 입력하세요"
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let nameCountLabel = LabelFactory().makeLabel(title: "0/20", size: 13, textAlignment: .right, isBold: false)
    
    lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField, nameCountLabel])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    //explainStackView
    let explainLabel = LabelFactory().makeLabel(title: "단어장 간단 설명", size: 20, textAlignment: .left, isBold: true)
    
    let explainTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "단어장에 대한 간단한 설명을 적어주세요"
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let explainCountLabel = LabelFactory().makeLabel(title: "0/40", size: 13, textAlignment: .right, isBold: false)
    
    lazy var explainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [explainLabel, explainTextField, explainCountLabel])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    //languageStackView
    let languageLabel = LabelFactory().makeLabel(title: "언어 (단어 & 의미)", size: 20, textAlignment: .left, isBold: true)
    
    let wordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "단어"
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let meaningTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "의미"
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    // 단어 & 의미 스택뷰
    lazy var wmStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [wordTextField, meaningTextField])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var languageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [languageLabel, wmStackView])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    //addButton
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("단어장 생성", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        [nameStackView, explainStackView, languageStackView, addButton].forEach{
            addSubview($0)
        }
        
        nameStackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        explainStackView.snp.makeConstraints{
            $0.top.equalTo(nameStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        languageStackView.snp.makeConstraints{
            $0.top.equalTo(explainStackView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        addButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        //설명 부분 텍스트 필드 크게 설정
        explainTextField.snp.makeConstraints {
            $0.height.equalTo(100)
        }
        
        //버튼 크기 늘리기
        addButton.snp.makeConstraints{
            $0.height.equalTo(50)
        }
    }
}
