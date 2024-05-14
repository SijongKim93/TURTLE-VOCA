//
//  CalenderDetailModelViewController.swift
//  Vocabulary
//
//  Created by 김시종 on 5/14/24.
//

import UIKit
import SnapKit

class CalenderDetailModelViewController: UIViewController {

    
    let filterMainLabel = LabelFactory().makeLabel(title: "단어 정렬 설정", size: 23, textAlignment: .left, isBold: true)
    
    let xButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(filterMainLabel)
        stackView.addArrangedSubview(xButton)
        return stackView
    }()
    
    let viewLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let recentAdd = LabelFactory().makeLabel(title: "최근 저장 순", color: .black, size: 20, textAlignment: .left, isBold: false)
    let lastAdd = LabelFactory().makeLabel(title: "나중 저장 순", color: .black, size: 20, textAlignment: .left, isBold: false)
    let memoryVoca = LabelFactory().makeLabel(title: "외운 단어 순", color: .black, size: 20, textAlignment: .left, isBold: false)
    let unmemoryVoca = LabelFactory().makeLabel(title: "못 외운 단어 순", color: .black, size: 20, textAlignment: .left, isBold: false)
    let randomVoca = LabelFactory().makeLabel(title: "랜덤", color: .black, size: 20, textAlignment: .left, isBold: false)
    
    lazy var bodyLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 40
        
        stackView.addArrangedSubview(recentAdd)
        stackView.addArrangedSubview(lastAdd)
        stackView.addArrangedSubview(memoryVoca)
        stackView.addArrangedSubview(unmemoryVoca)
        stackView.addArrangedSubview(randomVoca)
        return stackView
    }()
    
    let recentAddButton = ButtonFactory().makeButton(normalImageName: "circle", selectedImageName: "circle.circle", tintColor: .black)
    let lastAddButton = ButtonFactory().makeButton(normalImageName: "circle", selectedImageName: "circle.circle", tintColor: .black)
    let memoryVocaButton = ButtonFactory().makeButton(normalImageName: "circle", selectedImageName: "circle.circle", tintColor: .black)
    let unmemoryVocaButton = ButtonFactory().makeButton(normalImageName: "circle", selectedImageName: "circle.circle", tintColor: .black)
    let randomVocaButton = ButtonFactory().makeButton(normalImageName: "circle", selectedImageName: "circle.circle", tintColor: .black)
    
    lazy var bodyButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 40
        
        stackView.addArrangedSubview(recentAddButton)
        stackView.addArrangedSubview(lastAddButton)
        stackView.addArrangedSubview(memoryVocaButton)
        stackView.addArrangedSubview(unmemoryVocaButton)
        stackView.addArrangedSubview(randomVocaButton)
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        
        view.addSubview(topStackView)
        view.addSubview(viewLine)
        view.addSubview(bodyLabelStackView)
        view.addSubview(bodyButtonStackView)
        
        topStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        xButton.snp.makeConstraints {
            $0.width.equalTo(50)
        }
        
        viewLine.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        bodyLabelStackView.snp.makeConstraints {
            $0.top.equalTo(viewLine.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        bodyButtonStackView.snp.makeConstraints {
            $0.top.equalTo(viewLine.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
