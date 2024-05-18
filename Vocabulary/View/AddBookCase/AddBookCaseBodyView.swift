//
//  AddBookCaseBodyView.swift
//  Vocabulary
//
//  Created by 김한빛 on 5/15/24.
//

import UIKit
import SnapKit

class AddBookCaseBodyView: UIView {
    
    let coreDataManager = CoreDataManager.shared
    
    weak var delegate: AddBookCaseBodyViewDelegate?
    
    //imageStackView
    let backImgLabel = LabelFactory().makeLabel(title: "배경 이미지", size: 20, textAlignment: .left, isBold: true)
    
    let backImgView: UIImageView = {
        let backImgView = UIImageView()
        backImgView.image = UIImage(systemName: "plus")
        backImgView.contentMode = .center
        backImgView.tintColor = .white
        backImgView.backgroundColor = .systemGray2
        backImgView.layer.cornerRadius = 10
        return backImgView
    }()
    
    lazy var imageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backImgLabel, backImgView])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    //nameStackView
    let nameLabel = LabelFactory().makeLabel(title: "단어장 이름", size: 20, textAlignment: .left, isBold: true)
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "단어장 이름을 입력하세요"
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let nameCountLabel = LabelFactory().makeLabel(title: "0/10", size: 13, textAlignment: .right, isBold: false)
    
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
    
    let explainCountLabel = LabelFactory().makeLabel(title: "0/15", size: 13, textAlignment: .right, isBold: false)
    
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
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupConstraints()
        configureUI()
        setupImageViewGesture()
        
        // 텍스트필드 델리게이트 설정
        nameTextField.delegate = self
        explainTextField.delegate = self
        wordTextField.delegate = self
        meaningTextField.delegate = self
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        [imageStackView, nameStackView, explainStackView, languageStackView, addButton].forEach{
            addSubview($0)
        }
        
        imageStackView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview().inset(230)
        }
        
        nameStackView.snp.makeConstraints{
            $0.top.equalTo(imageStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        explainStackView.snp.makeConstraints{
            $0.top.equalTo(nameStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        languageStackView.snp.makeConstraints{
            $0.top.equalTo(explainStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        addButton.snp.makeConstraints{
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        //이미지 뷰 크기 조절
        backImgView.snp.makeConstraints{
            $0.height.equalTo(150)
        }
        
        //설명 부분 텍스트 필드 크게 설정
        explainTextField.snp.makeConstraints {
            $0.height.equalTo(80)
        }
        
        //버튼 크기 늘리기
        addButton.snp.makeConstraints{
            $0.height.equalTo(50)
        }
    }
    
    func configureUI(){
        backImgView.layer.cornerRadius = 10
        backImgView.layer.masksToBounds = true
    }
    
    private func setupImageViewGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        backImgView.isUserInteractionEnabled = true
        backImgView.addGestureRecognizer(tapGesture)
    }
    
    func setImage(_ image: UIImage) {
        backImgView.image = image
        backImgView.contentMode = .scaleToFill
    }
    
    @objc private func imageViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didSelectImage()
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        var isValid = true // 텍스트 필드가 채워져 있는지 확인하는 변수
        if nameTextField.text?.isEmpty ?? true {
            shakeTextField(nameTextField)
            isValid = false
        }
        if wordTextField.text?.isEmpty ?? true {
            shakeTextField(wordTextField)
            isValid = false
        }
        if meaningTextField.text?.isEmpty ?? true {
            shakeTextField(meaningTextField)
            isValid = false
        }

        if isValid {
            guard let name = nameTextField.text,
                  let explain = explainTextField.text,
                  let word = wordTextField.text,
                  let meaning = meaningTextField.text,
                  let image = backImgView.image else {
                return
            }
            var imageData: Data?
            if image == UIImage(systemName: "plus") { // 이미지 선택 안 해서 plus일 경우, 다른 기본 사진으로 저장
                imageData = UIImage(named: "mainturtle")?.jpegData(compressionQuality: 1.0)
            } else {
                imageData = image.jpegData(compressionQuality: 1.0)
            }
            coreDataManager.saveBookCase(name: name, explain: explain, word: word, meaning: meaning, image: imageData!)
            delegate?.addButtonTapped()
        }
    }
    
    func shakeTextField(_ textField: UITextField) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 10, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 10, y: textField.center.y))
        textField.layer.add(animation, forKey: "position")
        textField.layer.borderColor = UIColor.systemRed.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
    }
}

protocol AddBookCaseBodyViewDelegate: AnyObject {
    func addButtonTapped()
    func didSelectImage()
}

extension AddBookCaseBodyView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 백스페이스 실행 가능하게 하기
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // 글자 수 제한
        if textField == nameTextField { return prospectiveText.count <= 10 }
        if textField == explainTextField { return prospectiveText.count <= 15 }
        if textField == wordTextField { return prospectiveText.count <= 8 }
        if textField == meaningTextField { return prospectiveText.count <= 8 }
        return true
    }
}
